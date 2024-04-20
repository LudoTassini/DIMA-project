import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../containers/bloqo_seasalt_container.dart';

class BloqoCourseEnrolled extends StatelessWidget{
  final BloqoCourse? course;

  const BloqoCourseEnrolled({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return BloqoSeasaltContainer(
      borderColor: BloqoColors.russianViolet,
      borderWidth: 3,
      borderRadius: 10,
      child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
                          padding:const EdgeInsetsDirectional
                              .fromSTEB(10, 10, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding:EdgeInsetsDirectional
                                    .fromSTEB(0,0,5,0),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  color: BloqoColors.russianViolet,
                                  size: 24,
                                ),
                              ),
                              Flexible(
                                child: Align(
                                  alignment:const AlignmentDirectional(-1, 0),
                                  child: Text(
                                    course!.name,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 16, ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsetsDirectional
                              .fromSTEB(10, 0, 10, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional
                                    .fromSTEB(0,0,5,0),
                                child: Icon(
                                  Icons.person,
                                  color: BloqoColors.russianViolet,
                                  size: 24,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  course!.author,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsetsDirectional
                              .fromSTEB(10, 0, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional
                                    .fromSTEB(0,0,5,0),
                                child: Icon(
                                  Icons.bookmark_outlined,
                                  color: BloqoColors.russianViolet,
                                  size: 24,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'Section 2-3: DIMA projects', //TODO: replace
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 20,
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
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional
                          .fromSTEB(0, 0, 10, 0),
                      child: Icon(
                        Icons.play_circle,
                        color: BloqoColors.russianViolet,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: BloqoProgressBar(
                      percentage: 0.5,
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

}