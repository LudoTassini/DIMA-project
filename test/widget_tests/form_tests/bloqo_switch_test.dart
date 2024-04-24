import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/utils/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initializing BloqoTextField outside the testWidgets function
  final Toggle toggle = Toggle(initialValue: true);
  final testedWidget = MaterialApp(
    home: Scaffold(
      body: BloqoSwitch(
          value: toggle,
        )
      )
  );

  /*testWidgets('Switch form present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.text('Email'), findsOneWidget);
  });*/


}