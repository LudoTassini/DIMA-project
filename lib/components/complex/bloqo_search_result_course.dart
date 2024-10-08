import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/courses/tags/bloqo_subject_tag.dart';
import 'package:flutter/material.dart';
import '../../model/courses/tags/bloqo_difficulty_tag.dart';
import '../../model/courses/tags/bloqo_duration_tag.dart';
import '../../model/courses/tags/bloqo_language_tag.dart';
import '../../model/courses/tags/bloqo_modality_tag.dart';
import 'package:intl/intl.dart';

import '../../utils/localization.dart';

class BloqoSearchResultCourse extends StatelessWidget{

  final BloqoPublishedCourseData? course;
  final EdgeInsetsDirectional padding;
  final Function() onPressed;

  const BloqoSearchResultCourse({
    super.key,
    required this.course,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    return Padding(
        padding: padding,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
            backgroundColor: WidgetStateProperty.resolveWith((states) => theme.colors.highContrastColor),
            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: theme.colors.leadingColor,
                width: 3,
              ),
            )),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: theme.colors.leadingColor,
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Text(
                                  course!.courseName,
                                  style:
                                  theme.getThemeData().textTheme.displayMedium?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.person,
                                color: theme.colors.leadingColor,
                                size: 24,
                              ),
                            ),
                            Text(
                              course!.authorUsername,
                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.timer_outlined,
                                color: theme.colors.leadingColor,
                                size: 24,
                              ),
                            ),
                            Text(
                              localizedText.published_on + DateFormat('dd/MM/yyyy').format(course!.publicationDate.toDate()),
                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                course!.isPublic ? Icons.public : Icons.public_off,
                                color: theme.colors.leadingColor,
                                size: 24,
                              ),
                            ),

                            course!.isPublic ?
                              Text(
                                localizedText.public,
                                style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                              localizedText.private,
                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                fontSize: 14,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                            child: Icon(
                                              Icons.label,
                                              color: Color(0xFFFF00FF),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              getLanguageTagFromString(tag: course!.language).text(localizedText: localizedText),
                                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                              fontSize: 14,
                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 5, 0),
                                            child: Icon(
                                              Icons.label,
                                              color: Color(0xFFFF0000),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              getSubjectTagFromString(tag: course!.subject).text(localizedText: localizedText),
                                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 5, 0),
                                            child: Icon(
                                              Icons.label,
                                              color: Color(0xFF0000FF),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              getDurationTagFromString(tag: course!.duration).text(localizedText: localizedText),
                                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 5, 0),
                                            child: Icon(
                                              Icons.label,
                                              color: Color(0xFF00FF00),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              getModalityTagFromString(tag: course!.modality).text(localizedText: localizedText),
                                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 5, 0),
                                            child: Icon(
                                              Icons.label,
                                              color: Color(0xFFFFEA00),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              getDifficultyTagFromString(tag: course!.difficulty).text(localizedText: localizedText),
                                              style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.play_circle,
                      color: theme.colors.leadingColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          )

        ),
    );
  }

}