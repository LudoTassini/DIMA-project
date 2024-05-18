import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/pages/main/main_page.dart';
import 'package:bloqo/style/bloqo_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../utils/localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    List<BloqoUserCourseEnrolled> userCoursesEnrolled = Provider.of<UserCoursesEnrolledAppState>(context, listen: false).get()!;
    List<BloqoUserCourseCreated> userCoursesCreated = Provider.of<UserCoursesCreatedAppState>(context, listen: false).get()!;

    return BloqoMainContainer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Text(
                  localizedText.homepage_learning,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: BloqoColors.seasalt,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            BloqoSeasaltContainer(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userCoursesEnrolled.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                localizedText.homepage_learning_quote,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: BloqoColors.primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (userCoursesEnrolled.isNotEmpty)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          userCoursesEnrolled.length,
                              (index) {
                            BloqoUserCourseEnrolled? course = userCoursesEnrolled[index];
                            return BloqoCourseEnrolled(course: course);
                          },
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizedText.homepage_no_enrolled_courses,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: BloqoColors.primaryText,
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                              child: BloqoFilledButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(selectedPageIndex: 1,),
                                    ),
                                  );
                                },
                                color: BloqoColors.russianViolet,
                                text: localizedText.take_me_there_button,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Text(
                  localizedText.homepage_editing,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: BloqoColors.seasalt,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            BloqoSeasaltContainer(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userCoursesCreated.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                localizedText.homepage_editing_quote,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: BloqoColors.primaryText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (userCoursesCreated.isNotEmpty)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          userCoursesCreated.length,
                              (index) {
                            BloqoUserCourseCreated? course = userCoursesCreated[index];
                            return BloqoCourseCreated(course: course);
                          },
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizedText.homepage_no_created_courses,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: BloqoColors.primaryText,
                                fontSize: 14,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                              child: BloqoFilledButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(selectedPageIndex: 3,),
                                    ),
                                  );
                                },
                                color: BloqoColors.russianViolet,
                                text: localizedText.take_me_there_button,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

          ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}