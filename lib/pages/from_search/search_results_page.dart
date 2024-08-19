import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_search_result_course.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_review.dart';
import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:bloqo/pages/from_search/course_search_page.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_notification_data.dart';
import '../../model/bloqo_published_course.dart';
import '../../model/bloqo_user.dart';
import '../../model/courses/bloqo_chapter.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
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

                widget.publishedCourses.isNotEmpty
                    ? BloqoSeasaltContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                      ),
                      ...List.generate(
                        _publishedCoursesDisplayed > widget.publishedCourses.length
                            ? widget.publishedCourses.length
                            : _publishedCoursesDisplayed,
                            (index) {
                          BloqoPublishedCourse course = widget.publishedCourses[index];
                          return BloqoSearchResultCourse(
                            course: course,
                            onPressed: () async {
                              _goToCourseSearchPage(
                                context: context,
                                localizedText: localizedText,
                                publishedCourse: course,
                              );
                            },
                          );
                        },
                      ),
                      if (_publishedCoursesDisplayed < widget.publishedCourses.length)
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                          child: BloqoTextButton(
                            onPressed: loadMorePublishedCourses,
                            text: localizedText.load_more,
                            color: BloqoColors.russianViolet,
                          ),
                        ),
                    ],
                  ),
                )

                  : BloqoSeasaltContainer(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localizedText.no_search_results,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: BloqoColors.russianViolet,
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 15),
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

  Future<void> _goToCourseSearchPage({required var localizedText, required BuildContext context,
    required BloqoPublishedCourse publishedCourse}) async {
    context.loaderOverlay.show();
      try {
        BloqoCourse courseSelected = await getCourseFromId(localizedText: localizedText, courseId: publishedCourse.originalCourseId);
        List<BloqoChapter> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: courseSelected.chapters);
        Map<String, List<BloqoSection>> sections = {};
        for(String chapterId in courseSelected.chapters) {
          List<BloqoSection> chapterSections = await getSectionsFromIds(
              localizedText: localizedText,
              sectionIds: chapters.where((chapter) => chapter.id == chapterId).first.sections);
          sections[chapterId] = chapterSections;
        }
        BloqoUser courseAuthor = await getUserFromId(localizedText: localizedText, id: courseSelected.authorId);
        List<BloqoReview> reviews = [];
        if(publishedCourse.reviews.isNotEmpty) {
          reviews = await getReviewsFromIds(
              localizedText: localizedText, reviewsIds: publishedCourse.reviews);
        }
        bool enrollmentAlreadyRequested = false;
        if(!publishedCourse.isPublic) {
          if(!context.mounted) return;
          BloqoUser myself = getUserFromAppState(context: context)!;
          enrollmentAlreadyRequested = await getNotificationFromPublishedCourseIdAndApplicantId(
              localizedText: localizedText,
              publishedCourseId: publishedCourse.publishedCourseId,
              applicantId: myself.id
          ) != null;
        }
        if(!context.mounted) return;
        context.loaderOverlay.hide();
        widget.onPush(CourseSearchPage(
          onPush: widget.onPush,
          onNavigateToPage: widget.onNavigateToPage,
          course: courseSelected,
          publishedCourse: publishedCourse,
          chapters: chapters,
          sections: sections,
          courseAuthor: courseAuthor,
          reviews: reviews,
          rating: publishedCourse.rating,
          enrollmentAlreadyRequested: publishedCourse.isPublic ? false : enrollmentAlreadyRequested,
        )
      );

      } on BloqoException catch(e) {
        if(!context.mounted) return;
          context.loaderOverlay.hide();
          showBloqoErrorAlert(
            context: context,
            title: localizedText.error_title,
            description: e.message,
          );
      }
  }

}