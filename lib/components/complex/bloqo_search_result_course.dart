import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_published_course.dart';
import 'package:flutter/material.dart';
import '../../style/bloqo_colors.dart';
import 'package:intl/intl.dart';

import '../../utils/localization.dart';

class BloqoSearchResultCourse extends StatelessWidget{

  final BloqoPublishedCourse? course;
  final EdgeInsetsDirectional padding;
  final Function() onPressed;

  const BloqoSearchResultCourse({
    super.key,
    required this.course,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;

    return BloqoSeasaltContainer(
      child:Padding(
        padding: padding,
        child: ElevatedButton(
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
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: BloqoColors.russianViolet,
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Text(
                                  course!.courseName,
                                  style:
                                  Theme.of(context).textTheme.displayMedium?.copyWith(
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
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.person,
                                color: BloqoColors.russianViolet,
                                size: 24,
                              ),
                            ),
                            Text(
                              course!.authorUsername,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.timer_outlined,
                                color: BloqoColors.russianViolet,
                                size: 24,
                              ),
                            ),
                            Text(
                              localizedText.uploaded_on + DateFormat('dd/MM/yyyy').format(course!.publicationDate.toDate()),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                            const Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Icon(
                                Icons.public,
                                color: BloqoColors.russianViolet,
                                size: 24,
                              ),
                            ),

                            course!.isPublic ?
                              Text(
                                localizedText.public,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                              localizedText.private,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                                              course!.subject, //FIXME: faccenda dei tags
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                                              course!.duration, //FIXME: solito discorso dei tag
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                                              course!.modality, //FIXME: solito discorso dei tag
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                                              color: Color(0xFFFFFF00),
                                              size: 24,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              course!.difficulty, //FIXME: solito discorso tag
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
              const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Icon(
                      Icons.play_circle,
                      color: BloqoColors.russianViolet,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          )

        ),
      ),
    );
  }

}