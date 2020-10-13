import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FigmaClient.dart';

class FigmaPreview extends StatefulWidget {
  final Widget child;
  final String id;
  final String fileId;
  final String figmaToken;
  final bool isFullScreen;
  final int scale;
  final String format;

  const FigmaPreview({
    Key key,
    this.id,
    this.fileId,
    this.figmaToken,
    this.isFullScreen,
    this.child,
    this.scale = 3,
    this.format = 'png',
  }) : super(key: key);

  @override
  _FigmaPreviewState createState() => _FigmaPreviewState();
}

class _FigmaPreviewState extends State<FigmaPreview> {
  List<String> myIds = [];

  @override
  void initState() {
    myIds.add(widget.id);
    super.initState();
  }

  Future<String> fetchAlbum() async {
    final client = FigmaClient(widget.figmaToken);
    final jsonString =
    await client.getImages(widget.fileId, FigmaQuery(ids: myIds, scale: widget.scale, format: widget.format));
    final decode = json.decode(jsonString);
    final images = decode['images'];
    return images.values.first;
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Stack(
      children: [
        FutureBuilder(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    widget.child != null ? widget.child : Container(),
                    widget.isFullScreen
                        ? SingleChildScrollView(
                      child: Opacity(
                          opacity: 0.3,
                          child: Image.network(snapshot.data, width: MediaQuery.of(context).size.width)),
                    )
                        : Image.network(snapshot.data, width: MediaQuery.of(context).size.width)
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        if (widget.isFullScreen)
          Container(
            padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.1,
                child: FloatingActionButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(Icons.close),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          )
      ],
    );
  }
}
