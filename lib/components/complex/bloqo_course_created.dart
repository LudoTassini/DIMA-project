import 'package:flutter/material.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../containers/bloqo_seasalt_container.dart';

class BloqoCourseCreated extends StatelessWidget {

  const BloqoCourseCreated({
    super.key,
    required this.course, required this.child,
  });

  final Widget child;
  final BloqoCourse? course;

  @override
  Widget build(BuildContext context) {
    return BloqoSeasaltContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                15, 15, 15, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional
                                .fromSTEB(10, 10, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 5, 0),
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
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional
                                .fromSTEB(10, 5, 10, 10),
                            child: Text(
                              '2 chapters, 15 sections', //FIXME
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
                    const Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(
                          0, 0, 10, 0),
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
          ),
        ],
      ),
    );
  }
}