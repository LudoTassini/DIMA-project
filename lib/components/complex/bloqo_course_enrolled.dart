import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:flutter/material.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../style/bloqo_colors.dart';
import '../containers/bloqo_seasalt_container.dart';

class BloqoCourseEnrolled extends StatelessWidget{
  final BloqoUserCourseEnrolled? course;

  const BloqoCourseEnrolled({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    // FIXME: mettere button come in bloqo_setting e fare custom seasalt container
    return BloqoSeasaltContainer(
      borderColor: BloqoColors.russianViolet,
      borderWidth: 3,
      borderRadius: 10,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                                    course!.courseName,
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
                                  course!.courseAuthor,
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
                                  course!.sectionName,
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
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: BloqoProgressBar(
                      percentage: course!.numSectionsCompleted/course!.totNumSections,
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