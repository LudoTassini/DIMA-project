import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:flutter/material.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';
import '../containers/bloqo_seasalt_container.dart';

class BloqoCourseCreated extends StatelessWidget {

  const BloqoCourseCreated({
    super.key,
    required this.course,
    this.showEditOptions = false,
    this.showPublishedOptions = false
  });

  final BloqoUserCourseCreated? course;
  final bool showEditOptions;
  final bool showPublishedOptions;

  @override
  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return BloqoSeasaltContainer(
      borderColor: BloqoColors.russianViolet,
      borderWidth: 3,
      borderRadius: 10,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: BloqoColors.russianViolet,
                              size: 24,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              course!.courseName,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "${course!.numChaptersCreated} ${localizedText.chapters}, ${course!.numSectionsCreated} ${localizedText.sections}",
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  showEditOptions ? Icons.edit_square : Icons.play_circle,
                  color: BloqoColors.russianViolet,
                  size: 24,
                ),
              ],
            ),
            showEditOptions
                ? Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: BloqoFilledButton(
                    color: BloqoColors.success,
                    onPressed: () {} /* TODO */,
                    text: localizedText.publish,
                    fontSize: 16,
                    height: 32,
                  )),
            )
                : Container(),
            showPublishedOptions
                ? Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        BloqoFilledButton(
                          color: BloqoColors.russianViolet,
                          onPressed: () {} /* TODO */,
                          text: localizedText.view_statistics,
                          fontSize: 16,
                          height: 32,
                        ),
                        BloqoFilledButton(
                          color: BloqoColors.error,
                          onPressed: () {} /* TODO */,
                          text: localizedText.dismiss,
                          fontSize: 16,
                          height: 32,
                        )
                      ])),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}