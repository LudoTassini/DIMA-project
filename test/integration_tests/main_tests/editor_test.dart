import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_editable_block.dart';
import 'package:bloqo/components/complex/bloqo_editable_chapter.dart';
import 'package:bloqo/components/complex/bloqo_editable_quiz_answer.dart';
import 'package:bloqo/components/complex/bloqo_editable_section.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/multimedia/bloqo_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can create a new course test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a course and add a chapter to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a chapter and add a section to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a section and add a text block to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a section and add a multimedia block to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Multimedia Block").first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Multimedia"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a section and add a quiz block to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Quiz Block").first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Quiz"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a text block and add text to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Text Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Text"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).first, 'Text Block Test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.text("Text Block Test"), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a multimedia block and add an image to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Multimedia Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Multimedia"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Image").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Image");

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
            (Widget widget) =>
        widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/tests/test.png',
      ),
      findsOneWidget,
    );

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a multimedia block and add an audio to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Multimedia Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Multimedia"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Audio").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Audio");

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoAudioPlayer), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a multimedia block and add a video (from device) to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Multimedia Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Multimedia"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Video").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Video");

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    expect(find.byType(CircularProgressIndicator), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a multimedia block and add a video (from YouTube) to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Multimedia Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Multimedia"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Video").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Video");

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).last, 'yt:test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 1));
    });

    expect(find.text("Oops, we are not able to find that YouTube video. Please try again with another link."), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a quiz block and add a multiple choice question to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Quiz Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Quiz"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Multiple choice").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Multiple choice");

    await tester.enterText(find.byType(BloqoTextField).first, '1+1=2?');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).at(1), 'true');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(BloqoTextField).at(2), 'false');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableQuizAnswer), findsExactly(2));
    expect(find.text("Quiz: Multiple choice"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a quiz block and remove a choice from a multiple choice question test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Quiz Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Quiz"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Multiple choice").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Multiple choice");

    await tester.enterText(find.byType(BloqoTextField).first, '1+1=2?');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pump();

    await tester.enterText(find.byType(BloqoTextField).at(1), 'true');
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(BloqoTextField).at(2), 'false');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableQuizAnswer), findsExactly(2));
    expect(find.text("Quiz: Multiple choice"), findsOne);

    await tester.tap(find.byIcon(Icons.delete_forever).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK").last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableQuizAnswer), findsExactly(1));
    expect(find.text("Quiz: Multiple choice"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a quiz block and add a open question to it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Quiz Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);
    expect(find.text("Quiz"), findsOne);

    await tester.tap(find.byType(BloqoEditableBlock).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Open question").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Open question");

    await tester.enterText(find.byType(BloqoTextField).first, '1+1=2?');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).last, '2');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pump();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.text("Quiz: Open question"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can edit a section and remove a block from it test', (
      WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Editor"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.text("Course"), findsExactly(2));

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableChapter), findsOne);

    await tester.tap(find.byType(BloqoEditableChapter).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoEditableSection), findsOne);

    await tester.tap(find.byType(BloqoEditableSection).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Quiz Block").first);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsOne);

    await tester.tap(find.byIcon(Icons.delete_forever).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("OK").last);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    expect(find.byType(BloqoEditableBlock), findsNothing);

    await binding.setSurfaceSize(null);
  });

}