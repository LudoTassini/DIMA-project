import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:bloqo/model/bloqo_user_course_enrolled.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:flutter/material.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class CourseContentPage extends StatefulWidget {

  const CourseContentPage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> with AutomaticKeepAliveClientMixin<CourseContentPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    BloqoUserCourseEnrolled? course = getLearnCourseFromAppState(context: context);
    List<BloqoChapter>? chapters = course?.chapters;

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Column(
          children: [SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 0, 0),
                    child: Text(
                      localizedText.description,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: BloqoColors.seasalt,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 12),
                      child: Text(
                        course?.description ?? '', //FIXME: forse sarebbe meglio rendere description required
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: BloqoColors.seasalt,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 0, 0),
                    child: Text(
                      localizedText.content,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: BloqoColors.seasalt,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            chapters.length,
                                (index) {
                              var chapter = chapters[index];

                              return BloqoSeasaltContainer(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 0, 0),
                                      child: Text(
                                        'Chapter $index',
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                          color: BloqoColors.russianViolet,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                    child: Text(
                                    chapter.description ?? '', //FIXME: forse sarebbe meglio rendere description required
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: BloqoColors.russianViolet,
                                      ),
                                    ),
                                  ),

                                  // Spread the list of BloqoCourseSection widgets
                                  ...List.generate(
                                    chapter.sections!.length,
                                        (index) {
                                          var section = chapter.sections![index];
                                          return BloqoCourseSection(
                                            section: section,
                                            index: index,
                                            onPressed: () async {
                                              // TODO
                                            },
                                          );
                                        },
                                    ),
                                  ],
                              ),
                            );
                          },
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                course?.enrollmentDate as String,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: BloqoColors.seasalt,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0)),
                                  backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
                                  shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                ),
                                onPressed: () async {
                                  // TODO
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.close_sharp,
                                      size: 15,
                                    ),
                                    Flexible(
                                      child:Text(
                                        'Delete',
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ],
            ),
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
              child: BloqoProgressBar(
                percentage: course!.numSectionsCompleted/course.totNumSections,
                ),
              ),

            BloqoFilledButton(
                onPressed: () => () async {
                  // TODO
                  //widget.onNavigateToPage(3),
                },
                color: BloqoColors.success,
                text: localizedText.continue_learning,
                fontSize: 16,
                icon: Icons.lightbulb,
                ),
              ],
            ),

      ],
    ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

