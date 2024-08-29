import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget({bool disable = false}) {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            return Navigator(
              pages: [
                MaterialPage(
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Page 1')),
                    body: const Center(child: Text('This is Page 1')),
                  ),
                ),
                MaterialPage(
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Page 2')),
                    body: const Center(child: Text('This is Page 2')),
                  ),
                ),
                MaterialPage(
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Page 3')),
                    body: Column(
                      children: [
                        BloqoBreadcrumbs(
                          breadcrumbs: const ["test1", "test2", "test3"],
                          disable: disable,
                        ),
                        const Center(child: Text('This is Page 3')),
                      ],
                    ),
                  ),
                ),
              ],
              onDidRemovePage: (_) => (),
            );
          },
        ),
      ),
    );
  }

  testWidgets('Breadcrumbs present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoBreadcrumbs), findsOneWidget);
  });

  testWidgets('Breadcrumbs can be tapped (if enabled)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    final breadcrumbFinder = find.byWidgetPredicate(
          (widget) =>
      widget is RichText &&
          widget.text.toPlainText().contains('test2'),
    );

    expect(breadcrumbFinder, findsOneWidget);
    await tester.tap(breadcrumbFinder);
    await tester.pumpAndSettle();
    expect(find.text("This is Page 2"), findsOneWidget);
  });

  testWidgets('Breadcrumbs cannot be tapped (if disabled)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(disable: true));
    final breadcrumbFinder = find.byWidgetPredicate(
          (widget) =>
      widget is RichText &&
          widget.text.toPlainText().contains('test2'),
    );

    expect(breadcrumbFinder, findsOneWidget);
    await tester.tap(breadcrumbFinder);
    await tester.pumpAndSettle();
    expect(find.text("This is Page 2"), findsNothing);
  });

}