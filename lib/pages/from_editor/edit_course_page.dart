import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_courses_created_app_state.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../utils/localization.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

  @override
  State<EditCoursePage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditCoursePage> with AutomaticKeepAliveClientMixin<EditCoursePage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<UserCoursesCreatedAppState>(
        builder: (context, userCoursesCreatedAppState, _){
          return Column(
              children: [
                BloqoBreadcrumbs(breadcrumbs: [

                ])
              ]
          );
        }
      )
    );
  }

  @override
  bool get wantKeepAlive => true;

}