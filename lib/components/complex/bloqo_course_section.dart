import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:flutter/material.dart';
import '../../utils/localization.dart';

class BloqoCourseSection extends StatelessWidget{
  const BloqoCourseSection({
    super.key,
    required this.onPressed,
    required this.section,
    required this.index,
    required this.isClickable,
    required this.isInLearnPage,
    this.isCompleted = false,
  });

  final Function() onPressed;
  final BloqoSectionData section;
  final int index;
  final bool isClickable;
  final bool isInLearnPage;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15),
      child: isClickable ?
        ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.all(11)),
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
          child: _buildContent(context, localizedText, isCompleted),
        ) : Container(
          decoration: BoxDecoration(
            color: theme.colors.highContrastColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colors.leadingColor,
              width: 3,
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          child: _buildContent(context, localizedText, isCompleted),
        ),
    );
  }

  Widget _buildContent(BuildContext context, var localizedText, bool isCompleted) {
    var theme = getAppThemeFromAppState(context: context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: Text(
                        '${localizedText.section} ${index + 1}',
                        style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                          fontSize: 14,
                          color: theme.colors.secondaryText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 0), //10, 10, 10, 0
                      child: Text(
                        section.name,
                        textAlign: TextAlign.start,
                        style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                          color: theme.colors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    if(isInLearnPage && isCompleted)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                        child: Row(
                          children: [
                            Text(
                              localizedText.completed_section,
                              textAlign: TextAlign.start,
                              style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                fontSize: 16,
                                color: theme.colors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Icon(
                                Icons.check,
                                color: theme.colors.success,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if(isInLearnPage && !isCompleted)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 5, 10, 5),
                        child: Row(
                          children: [
                            Text(
                              localizedText.not_completed,
                              textAlign: TextAlign.start,
                              style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                fontSize: 16,
                                color: theme.colors.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if(!isCompleted && !isInLearnPage)
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                      ), // This will take up no space
                  ],
                ),
              ),
            ),

            isClickable ?
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
                child: Icon(
                  Icons.play_circle,
                  color: theme.colors.leadingColor,
                  size: 24,
                ),
              ) : const SizedBox.shrink(),

          ],
        ),
      ],
    );
  }
}