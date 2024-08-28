import 'dart:async';
import 'dart:ui' as ui;
import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'localization.dart';

class BloqoCertificate extends StatelessWidget {
  const BloqoCertificate({
    super.key,
    required this.fullName,
    required this.courseName,
  });

  final String fullName;
  final String courseName;

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    DateTime now = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colors.leadingColor,
            theme.colors.trailingColor
          ],
          stops: const [0, 1],
          begin: const AlignmentDirectional(0, -1),
          end: const AlignmentDirectional(0, 1),
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                    child: Text(
                      'bloQo',
                      style: theme.getThemeData().textTheme.displayLarge?.copyWith(
                        color: theme.colors.highContrastColor,
                        fontSize: 60,
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/images/bloqo_logo_partial.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ]
              ),
            ),
            Text(
              localizedText.course_completion_certificate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colors.highContrastColor),
            ),
            const SizedBox(height: 20),
            Text(
              localizedText.assigned_to,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: theme.colors.highContrastColor),
            ),
            Text(
              fullName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.colors.highContrastColor),
            ),
            const SizedBox(height: 20),
            Text(
              localizedText.for_successfully_completing_course,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: theme.colors.highContrastColor),
            ),
            const SizedBox(height: 20),
            Text(
              courseName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: theme.colors.highContrastColor),
            ),
            const SizedBox(height: 20),
            Text(
              '${localizedText.date}: ${now.day}/${now.month}/${now.year}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: theme.colors.highContrastColor),
            ),
          ],
        ),
      )
    );
  }
}

Future<ui.Image> getCertificateImage({
  required BuildContext context,
  required String fullName,
  required String courseName,
}) async {

  GlobalKey globalKeyContainer = GlobalKey();
  GlobalKey globalKeyRB = GlobalKey();

  BloqoCertificate certificateWidget = BloqoCertificate(
    fullName: fullName,
    courseName: courseName,
  );

  final completer = Completer<ui.Image>();

  var renderObject = Container(
    key: globalKeyContainer,
    child: RepaintBoundary(
      key: globalKeyRB,
      child: certificateWidget,
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    RenderRepaintBoundary? renderRepaintBoundary =
    globalKeyContainer.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (renderRepaintBoundary != null) {
      ui.Image image = await renderRepaintBoundary.toImage(pixelRatio: 3.0);
      completer.complete(image);
    } else {
      completer.completeError('Error');
    }
  });

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (_) => Material(
      color: Colors.transparent,
      child: Center(child: renderObject),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  ui.Image image = await completer.future;

  await Future.delayed(const Duration(seconds: 1));

  overlayEntry.remove();

  return image;
}