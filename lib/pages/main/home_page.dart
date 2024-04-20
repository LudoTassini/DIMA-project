import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_user.dart';
import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:bloqo/style/bloqo_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state/user_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BloqoUser user = Provider.of<UserAppState>(context, listen: false).get()!;

    return BloqoMainContainer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Text(
                  'Do you mind some learning today?',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: BloqoColors.seasalt,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            BloqoSeasaltContainer(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              '"The greatest enemy of knowledge is not ignorance, it is the illusion of knowledge." - Stephen Hawking',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: BloqoColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(user.coursesEnrolledIn?.length ?? 0, (index) {
                          BloqoCourse? course = user.coursesEnrolledIn?[index];
                            return BloqoCourseEnrolled(
                                course: course,
                                );
                              },
                            ),
                          )
                        ),
                      ]
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Text(
                    'You have some work yet to be completed.',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: BloqoColors.seasalt,
                      fontSize: 30,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                  children: [
                      BloqoSeasaltContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: RichText(
                                    textScaler: MediaQuery.of(context).textScaler,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          '"Tell me and I forget. Teach me and I remember. Involve me and I learn. - Benjamin Franklin"',
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: BloqoColors.primaryText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(user.coursesCreated?.length ?? 0, (index) {
                              BloqoCourse? course = user.coursesCreated?[index];

                              return BloqoSeasaltContainer(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                        15, 15, 15, 0),
                                      child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: const AlignmentDirectional(-1, 0),
                                              child: Column(
                                              mainAxisSize: MainAxisSize.max,
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
                            } ),
                            ),
                          ),
                          Align( //FIXME
                            alignment: const AlignmentDirectional(1,-1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 15, 15, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment:
                                      const AlignmentDirectional(1, 0),
                                      child: Text(
                                        'View more',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                          color: BloqoColors.secondaryText,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_sharp,
                                      color: BloqoColors.secondaryText,
                                      size: 25,
                                    ),
                                  ],
                                ),
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
    );
  }

  @override
  bool get wantKeepAlive => true;

}