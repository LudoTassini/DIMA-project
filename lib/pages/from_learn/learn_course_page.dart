import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/learn_course_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../model/courses/bloqo_chapter.dart';
import '../../model/courses/bloqo_course.dart';
import '../../utils/localization.dart';

class LearnCoursePage extends StatefulWidget {
  const LearnCoursePage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

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
        child: Consumer<LearnCourseAppState>(
            builder: (context, learnCourseAppState, _){
              BloqoCourse course = getLearnCourseFromAppState(context: context)!;
              List<BloqoChapter> chapters = getLearnCourseChaptersFromAppState(context: context) ?? [];
              return Column(
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name,
                    ]),
                    Expanded(
                        child: Text(
                            course.name,
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