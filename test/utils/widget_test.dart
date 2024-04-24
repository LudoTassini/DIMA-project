import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetTest{

  final MaterialApp app;
  final BuildContext context;
  final AppLocalizations localizedText;

  WidgetTest({
    required this.app,
    required this.context,
    required this.localizedText
  });

  pumpWidget({required Widget widget}){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Scaffold(
          body: widget
        )
    ));
  }

}

Future<WidgetTest> initWidgetTest() async{
  late BuildContext sharedContext;
  MaterialApp app = MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Builder(
        builder: (BuildContext context) {
          sharedContext = context;
          return Scaffold(
            body: Container()
          );
        },
      )
  );
  return WidgetTest(
    app: app,
    context: sharedContext,
    localizedText: getAppLocalizations(sharedContext)!
  );
}