# flutter_figma_preview
A Figma component preview for your Flutter widget.

It will obtain the png version of the component from Figma and display a half transparent overlay on top of your widget.

In order to use the FigmaPreview widget you will need to know the Figma API token and your component id.
TODO: describe how to obtain those. 

Example(MyComponentStory.dart): 

```
FigmaPreview(
    id: '2429:111',
    child: MyComponent()
)
```

Works best in a separate app target, like this: 
```
void main() {
  runApp(MaterialApp(
      home: MyComponentStory()));
}
```