import 'package:bloqo/app_state/learn_course_app_state.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoCourseSection extends StatelessWidget{
  const BloqoCourseSection({
    super.key,
    required this.onPressed,
    required this.section,
    required this.index,
    required this.isClickable,
    required this.isInLearnPage
  });

  final Function() onPressed;
  final BloqoSectionData section;
  final int index;
  final bool isClickable;
  final bool isInLearnPage;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    List<dynamic> sectionsCompleted = getLearnCourseSectionsCompletedFromAppState(context: context)?? [];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15),
      child: isInLearnPage & isClickable
          ? ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
          backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
          shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: BloqoColors.russianViolet,
              width: 3,
            ),
          )),
        ),
        onPressed: onPressed,
        child: _buildContent(context, localizedText, sectionsCompleted),
      )
          : Container(
        decoration: BoxDecoration(
          color: BloqoColors.seasalt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: BloqoColors.russianViolet,
            width: 3,
          ),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: _buildContent(context, localizedText, sectionsCompleted),
      ),
    );
  }

  Widget _buildContent(BuildContext context, var localizedText, List<dynamic> sectionsCompleted) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional
                          .fromSTEB(10, 10, 10, 0),
                      child: Text(
                        '${localizedText.section} ${index + 1}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                          fontSize: 14,
                          color: BloqoColors.secondaryText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10, 5, 10, 0), //10, 10, 10, 0
                      child: Text(
                        section.name,
                        textAlign: TextAlign.start,
                        style: Theme
                            .of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                          fontSize: 20,
                          color: BloqoColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    sectionsCompleted.contains(section.id) ?
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10, 5, 10, 5),
                      child: Row(
                        children: [
                          Text(
                            localizedText.completed,
                            textAlign: TextAlign.start,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                              fontSize: 16,
                              color: BloqoColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                            child: Icon(
                              Icons.check,
                              color: BloqoColors.success,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    )

                        : isInLearnPage ?
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10, 5, 10, 5),
                      child: Row(
                        children: [
                          Text(
                            localizedText.not_completed,
                            textAlign: TextAlign.start,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                              fontSize: 16,
                              color: BloqoColors.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                        : const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                    ), // This will take up no space
                  ],
                ),
              ),
            ),

            isInLearnPage & isClickable ?
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
              child: Icon(
                Icons.play_circle,
                color: BloqoColors.russianViolet,
                size: 24,
              ),
            )
                : const SizedBox.shrink(),

          ],
        ),
      ],
    );
  }
}