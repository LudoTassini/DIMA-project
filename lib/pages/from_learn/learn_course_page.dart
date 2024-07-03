import 'package:bloqo/app_state/user_courses_enrolled_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_courses_created_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../model/courses/bloqo_course.dart';
import '../../utils/localization.dart';

class LearnCoursePage extends StatefulWidget {
  const LearnCoursePage({
    super.key,
    required this.onPush,
    required this.course
  });

  final void Function(Widget) onPush;
  final BloqoCourse course;

  @override
  State<LearnCoursePage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnCoursePage> with AutomaticKeepAliveClientMixin<LearnCoursePage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<UserCoursesEnrolledAppState>(
            builder: (context, userCoursesEnrolledAppState, _){
              return Column(
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      widget.course.name
                    ]),
                    Expanded(
                        child: Text(
                            widget.course.name
                        )
                    )
                  ]
              );
            }
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

}