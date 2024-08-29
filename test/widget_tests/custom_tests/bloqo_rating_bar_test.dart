import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/custom/bloqo_rating_bar.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  int rating = 0;

  Widget buildTestWidget({
    int initialRating = 0,
    bool disabled = false
  }) {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ],
          child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoRatingBar(
                    rating: initialRating,
                    onRatingChanged: (newRating) {
                      rating = newRating;
                    },
                    disabled: disabled
                  ),
                );
              }
          ),
        )
    );
  }

  setUp(() {
    rating = 0;
  });

  testWidgets('Rating bar present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoRatingBar), findsOneWidget);
  });

  testWidgets('Rating bar initialized at 0 reacts to tap', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    final starFinder = find.byIcon(Icons.star_border).at(3);
    await tester.tap(starFinder);
    await tester.pump();

    final selectedStars = find.byIcon(Icons.star);
    expect(selectedStars, findsNWidgets(4));

    expect(rating, 4);
  });

  testWidgets('Rating bar initialized at 5 reacts to tap', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialRating: 5));

    final starFinder = find.byIcon(Icons.star).at(2);
    await tester.tap(starFinder);
    await tester.pump();

    final selectedStars = find.byIcon(Icons.star);
    expect(selectedStars, findsNWidgets(3));

    expect(rating, 3);
  });

  testWidgets('Rating bar shows the amount of stars it starts with', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialRating: 3));
    final starFinder = find.byIcon(Icons.star);
    expect(starFinder, findsNWidgets(3));
  });

  testWidgets('Rating bar cannot be modified if it is disabled', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialRating: 3, disabled: true));
    final starFinder = find.byIcon(Icons.star);
    expect(starFinder, findsNWidgets(3));

    await tester.tap(find.byIcon(Icons.star_border).last);
    await tester.pump();

    expect(starFinder, findsNWidgets(3));
  });

}