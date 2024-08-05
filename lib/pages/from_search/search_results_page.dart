import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_search_result_course.dart';
import 'package:flutter/material.dart';

import '../../components/buttons/bloqo_text_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../model/bloqo_published_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class SearchResultsPage extends StatefulWidget {

  const SearchResultsPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage,
    required this.publishedCourses,
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;
  final List<BloqoPublishedCourse> publishedCourses;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with AutomaticKeepAliveClientMixin<SearchResultsPage> {

  int _publishedCoursesDisplayed = Constants.coursesToShowAtFirst;

  @override
  Widget build(BuildContext context){
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    void loadMorePublishedCourses() {
      setState(() {
        _publishedCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Column(
        children: [
          Expanded(
          child:SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Text(
                      localizedText.search_results_header,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: BloqoColors.seasalt,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                if (widget.publishedCourses.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _publishedCoursesDisplayed > widget.publishedCourses.length ?
                      widget.publishedCourses.length : _publishedCoursesDisplayed,
                          (index) {
                        BloqoPublishedCourse course = widget.publishedCourses[index];
                        return BloqoSearchResultCourse(
                          course: course,
                          onPressed: () async {
                            //TODO
                            //await _goToLearnCoursePage(context: context, localizedText: localizedText, userCourseEnrolled: course);
                          },
                        );
                      },
                    ),
                  ),
                if (_publishedCoursesDisplayed < widget.publishedCourses.length)
                  BloqoFilledButton(
                      onPressed: loadMorePublishedCourses,
                      text: localizedText.load_more_courses,
                      color: BloqoColors.russianViolet
                  ),

                if (widget.publishedCourses.isEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localizedText.no_search_results,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: BloqoColors.primaryText,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 5),
                          child: BloqoFilledButton(
                            onPressed: () => widget.onNavigateToPage(2),
                            color: BloqoColors.russianViolet,
                            text: localizedText.take_me_there_button,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}