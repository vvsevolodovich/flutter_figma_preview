import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_figma_preview/FigmaClient.dart';
import 'package:flutter_figma_preview/figma_component.dart';
import 'package:flutter_figma_preview/flutter_figma_preview.dart';

class FigmaComponentDescriptionState extends State<FigmaComponentDescription> {
  bool collapsed = true;

  TextStyle textStyle() => TextStyle(color: Colors.white, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    final figmaComponent = widget.figmaComponent;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${figmaComponent.name}",
                style: textStyle(),
                overflow: TextOverflow.fade,
              ),
              Text(
                "${figmaComponent.node_id}",
                style: textStyle(),
              ),
              collapsed
                  ? Container()
                  : FigmaPreview(
                      fileId: widget.fileId,
                      figmaToken: widget.figmaToken,
                      id: figmaComponent.node_id,
                      isFullScreen: false,
                      scale: 2)
            ]),
        width: MediaQuery.of(context).size.width - 128,
      ),
      Container(
          child: FlatButton(
        onPressed: (() {
          setState(() {
            collapsed = !collapsed;
          });
        }),
        padding: EdgeInsets.all(0.0),
        child: Transform.rotate(
            angle: (collapsed ? 0 : 180) * 3.14 / 180,
            child: Image.asset(
              'assets/arrow_down.png',
              package: 'flutter_figma_preview',
              width: 24,
              height: 24,
            )),
      ))
    ]);
  }
}

class FigmaComponentDescription extends StatefulWidget {
  final FigmaComponent figmaComponent;
  final String fileId;
  final String figmaToken;

  FigmaComponentDescription(this.figmaComponent, this.fileId, this.figmaToken);

  @override
  State createState() {
    return FigmaComponentDescriptionState();
  }
}

class FigmaSearchComponent extends StatefulWidget {
  final String fileId;
  final String figmaToken;

  const FigmaSearchComponent({this.fileId, this.figmaToken});

  @override
  State<StatefulWidget> createState() {
    return _FigmaSearchComponentState();
  }
}

class _FigmaSearchComponentState extends State<FigmaSearchComponent> {
  final myController = TextEditingController();
  List<FigmaComponent> components = [];
  List<FigmaComponent> filteredComponents = [];

  void loadComponents() async {
    var searchComponents =
        await FigmaClient(widget.figmaToken).searchComponents(widget.fileId);
    var result = jsonDecode(searchComponents);
    print(result);
    components = result['meta']['components'].map<FigmaComponent>((element) {
      return FigmaComponent.fromJson(element);
    }).toList();
    filteredComponents = components;
  }

  @override
  void initState() {
    loadComponents();
    myController.addListener(() {
      print(myController.text);
      setState(() {
        filteredComponents = components
            .where((i) => i.name.contains(myController.text))
            .toList();
      });
    });
  }

  Widget displayComponents() {
    return filteredComponents.isEmpty
        ? Container()
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: filteredComponents.length,
            itemBuilder: (context, index) {
              final item = filteredComponents[index];
              return FigmaComponentDescription(
                  item, widget.fileId, widget.figmaToken);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          Row(children: [
            Image.asset("assets/fi_search.png",
                width: 24, height: 24, package: 'flutter_figma_preview'),
            Expanded(
                child: TextField(
              controller: myController,
              decoration: InputDecoration(labelText: 'Search here...'),
              style: TextStyle(color: Colors.white),
            )),
          ]),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(top: 33),
                  child: displayComponents()))
        ]));
  }
}
