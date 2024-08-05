import 'package:flutter/material.dart';

import '../../components/containers/bloqo_main_container.dart';
import '../../utils/localization.dart';

class SearchResultsPage extends StatefulWidget {

  const SearchResultsPage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with AutomaticKeepAliveClientMixin<SearchResultsPage> {

  @override
  Widget build(BuildContext context){
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    return const Text("Search Results Page");

    /*

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
        Consumer<UserCoursesEnrolledAppState>(
        builder: (context, userCoursesEnrolledAppState, _) {
          List<BloqoUserCourseEnrolled> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context) ?? [];
          userCoursesEnrolled = userCoursesEnrolled.where((course) => !course.isCompleted).toList();
          return Column(
            children: [
            BloqoBreadcrumbs(breadcrumbs: [
              course.name,
              ]),
            Expanded(
            child:SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            ); */
  }

  @override
  bool get wantKeepAlive => true;

}