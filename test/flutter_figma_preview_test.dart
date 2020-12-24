import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_figma_preview/flutter_figma_preview.dart';

void main() {
  testWidgets('adds one to input values', (WidgetTester tester) async {
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    final figmaPreview = FigmaPreview(
        id: "100:123",
        child: Text("Hello"),
        fileId: '12341',
        figmaToken: 'token',
        isFullScreen: false);
    await tester.pumpWidget(createWidgetForTesting(child: figmaPreview));
    expect(figmaPreview, isNotNull);
    expect(find.byType(Text), findsOneWidget);
  });
}
