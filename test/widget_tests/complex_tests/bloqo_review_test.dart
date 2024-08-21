import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_review.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
        ],
        child: MaterialApp(
          localizationsDelegates: getLocalizationDelegates(),
          supportedLocales: getSupportedLocales(),
          home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoReview(
                    review: BloqoReviewData(
                      authorUsername: "test",
                      authorId: "test",
                      commentTitle: "test",
                      comment: "test",
                      rating: 5,
                      id: "test"
                    )
                  )
                );
              }
          ),
        )
    );
  }

  testWidgets('Review present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoReview), findsOneWidget);
  });

  testWidgets('Review shown stars correspond to rating', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    final starFinder = find.byIcon(Icons.star);
    expect(starFinder, findsNWidgets(5));
  });

}