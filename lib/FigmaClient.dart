import 'dart:convert';
import 'dart:io';

import 'package:http2/http2.dart';

const base = 'api.figma.com';

class FigmaClient {
  final String accessToken;
  final String apiVersion;

  FigmaClient(this.accessToken, [this.apiVersion = 'v1']);

  Future<String> getImages(String key, FigmaQuery query) async => await _getFigma('/images/$key', query);

  Future<String> _getFigma(String path, [FigmaQuery query]) async {
    final uri = Uri.https(base, '$apiVersion$path', query?.figmaQuery);
    final response = await _sendRequest('GET', uri, _authHeaders);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      throw FigmaError(code: response.statusCode, message: response.body);
    }
  }

  Future<Response> _sendRequest(String method, Uri uri, Map<String, String> headers, [String body]) async {
    var transport = ClientTransportConnection.viaSocket(
      await SecureSocket.connect(
        uri.host,
        uri.port,
        supportedProtocols: ['h2'],
      ),
    );

    var stream = transport.makeRequest(
      [
        Header.ascii(':method', method),
        Header.ascii(':path', uri.path + (uri.hasQuery ? '?${uri.query}' : '')),
        Header.ascii(':scheme', uri.scheme),
        Header.ascii(':authority', uri.host),
        ...headers.entries.map(
          (e) => Header.ascii(e.key.toLowerCase(), e.value),
        ),
      ],
      endStream: body == null,
    );
    if (body != null) {
      stream.sendData(utf8.encode(body), endStream: true);
    }
    var status = 200;
    final buffer = StringBuffer();
    await for (var message in stream.incomingMessages) {
      if (message is HeadersStreamMessage) {
        for (var header in message.headers) {
          var name = utf8.decode(header.name);
          var value = utf8.decode(header.value);
          if (name == ':status') {
            status = int.parse(value);
          }
        }
      } else if (message is DataStreamMessage) {
        buffer.write(utf8.decode(message.bytes));
      }
    }
    await transport.finish();

    return Response(status, buffer.toString());
  }

  Map<String, String> get _authHeaders => {
        'X-Figma-Token': accessToken,
        'Content-Type': 'application/json',
      };
}

class Response {
  final int statusCode;
  final String body;
  const Response(this.statusCode, this.body);
}

class FigmaError extends Error {
  final int code;
  final String message;
  FigmaError({this.code, this.message});

  @override
  String toString() => '{code: $code, message: $message}';
}

class FigmaQuery {
  final List<String> ids;
  final int scale;
  final String format;
  final bool useAbsoluteBounds;
  final String version;

  const FigmaQuery({
    this.ids,
    this.scale,
    this.format,
    this.version,
    this.useAbsoluteBounds,
  });

  Map<String, String> get figmaQuery {
    var mapQuery = {
      'ids': ids?.join(','),
      'scale': scale?.toString(),
      'format': format,
      'use_absolute_bounds': useAbsoluteBounds?.toString(),
      'version': version,
    };
    mapQuery.removeWhere((key, value) => value == null);

    return mapQuery;
  }
}
