import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:flutter/material.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../style/bloqo_colors.dart';

class BloqoCourseEnrolled extends StatelessWidget{
  final BloqoUserCourseEnrolled? course;
  final EdgeInsetsDirectional padding;
  final bool showCompleted;
  final bool showInProgress;
  final Function() onPressed;

  const BloqoCourseEnrolled({
    super.key,
    required this.course,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
    required this.onPressed,
    this.showCompleted = false,
    this.showInProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    // FIXME: mettere button come in bloqo_setting e fare custom seasalt container
    return Padding(
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
          child: Column(
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
                          if(showInProgress)
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
                                      course?.sectionName ?? '', // this is because completed courses do not have a section name, but text can't be of type String?
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
            if(showInProgress)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Get the maximum available width
                              double maxWidth = constraints.maxWidth-20;

                              return BloqoProgressBar(
                                percentage: course!.isCompleted? 1 :
                                  (course!.sectionsCompleted?.length ?? 0) / course!.totNumSections,
                                width: maxWidth, // Pass the maximum width to the progress bar
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),

              if(showCompleted)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                        child:
                          course!.isRated ? BloqoFilledButton(
                            color: BloqoColors.rated,
                            onPressed: () {
                              //TODO:
                            },
                            text: 'Rated',
                            fontSize: 16,
                            height: 32,
                          )
                          :  BloqoFilledButton(
                              color: BloqoColors.rate,
                              onPressed: () {
                              //TODO:
                              },
                              text: 'Rate',
                              fontSize: 16,
                              height: 32,
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: BloqoFilledButton(
                          color: BloqoColors.success,
                          onPressed: () {
                            //TODO:
                          },
                          text: 'Get Certificate',
                          fontSize: 16,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }

}