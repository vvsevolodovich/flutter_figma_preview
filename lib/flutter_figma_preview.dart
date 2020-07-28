library flutter_figma_preview;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class FigmaPreviewState extends State<FigmaPreview> {

  final Widget child;
  final String id;
  final String figmaToken;

  int scale;
  String format;

  Future<http.Response> computation;

  FigmaPreviewState(this.child, this.id, this.figmaToken,
      {int scale = 3, String format = 'png'}) {
    assert(child != null, "Child can not be null");
    assert(id != null, "Figma component id can not be null");

    this.scale = scale;
    this.format = format;
  }

  @override
  void initState() {
    super.initState();
    computation = http.get(
        'https://api.figma.com/v1/images/48PvyUgfNikXWqPMAXX8ht?ids=${id}&scale=${scale}&format=${format}',
        headers: {
          'X-FIGMA-TOKEN': figmaToken
        });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return FutureBuilder(
        future: computation,
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            var jsonString = snapshot.data.body;
            var decode = json.decode(jsonString);
            var imageLink = decode["images"][id];
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                child,
                Positioned(
                  top: 0,
                  left: 0,
                  child: Opacity(opacity: 0.5, child: Image.network(imageLink, width: MediaQuery.of(context).size.width)),
                ),
              ],
            );
          } else {
            return child;
          }
        });
  }
}

class FigmaPreview extends StatefulWidget {
  final Widget child;
  final String id;
  final String figmaToken;

  const FigmaPreview({Key key, this.id, this.child, this.figmaToken}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FigmaPreviewState(child, id, figmaToken);
  }
}
