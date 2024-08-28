import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/complex/bloqo_search_result_course.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/pages/from_search/course_search_page.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_notification_data.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_chapter_data.dart';
import '../../model/courses/bloqo_section_data.dart';
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
  final List<BloqoPublishedCourseData> publishedCourses;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with AutomaticKeepAliveClientMixin<SearchResultsPage> {

  int _publishedCoursesDisplayed = Constants.coursesToShowAtFirst;
  int _coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequest;
  bool _initialized = false;

  @override
  Widget build(BuildContext context){
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    if(!_initialized && isTablet){
      setState(() {
      _publishedCoursesDisplayed = Constants.coursesToShowAtFirstTablet;
      _coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequestTablet;
      _initialized = true;
      });
    }

    void loadMorePublishedCourses() {
      setState(() {
        _publishedCoursesDisplayed += _coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Column(
        children: [
          Expanded(
          child:SingleChildScrollView(
            child: Padding(
              padding: !isTablet ? const EdgeInsetsDirectional.all(0) : Constants.tabletPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                      child: Text(
                        localizedText.search_results_header,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: theme.colors.highContrastColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  widget.publishedCourses.isNotEmpty
                      ? BloqoSeasaltContainer(
                    child: isTablet
                        ? Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
                      child: Column(
                        children: [
                          LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              double width = constraints.maxWidth / 2;
                              double height = width;
                              double childAspectRatio = width / height;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: childAspectRatio, // 2.5 / 2
                                ),
                                itemCount: _publishedCoursesDisplayed >
                                    widget.publishedCourses.length
                                    ? widget.publishedCourses.length
                                    : _publishedCoursesDisplayed,
                                itemBuilder: (context, index) {
                                  BloqoPublishedCourseData course = widget
                                      .publishedCourses[index];
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
                              );
                            }
                          ),

                          if (_publishedCoursesDisplayed < widget.publishedCourses.length)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                              child: BloqoTextButton(
                                onPressed: loadMorePublishedCourses,
                                text: localizedText.load_more,
                                color: theme.colors.leadingColor,
                              ),
                            ),
                        ],
                      ),
                    )
                        : Column(
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
                            BloqoPublishedCourseData course = widget.publishedCourses[index];
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
                              color: theme.colors.leadingColor,
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
                              color: theme.colors.leadingColor,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 15),
                            child: BloqoFilledButton(
                              onPressed: () => widget.onNavigateToPage(2),
                              color: theme.colors.leadingColor,
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
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _goToCourseSearchPage({required var localizedText, required BuildContext context,
    required BloqoPublishedCourseData publishedCourse}) async {
    context.loaderOverlay.show();
      try {
        var firestore = getFirestoreFromAppState(context: context);
        BloqoCourseData courseSelected = await getCourseFromId(
            firestore: firestore,
            localizedText: localizedText,
            courseId: publishedCourse.originalCourseId
        );
        List<BloqoChapterData> chapters = await getChaptersFromIds(
            firestore: firestore,
            localizedText: localizedText,
            chapterIds: courseSelected.chapters
        );
        Map<String, List<BloqoSectionData>> sections = {};
        for(String chapterId in courseSelected.chapters) {
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
              firestore: firestore,
              localizedText: localizedText,
              sectionIds: chapters.where((chapter) => chapter.id == chapterId).first.sections
          );
          sections[chapterId] = chapterSections;
        }
        BloqoUserData courseAuthor = await getUserFromId(
            firestore: firestore,
            localizedText: localizedText,
            id: courseSelected.authorId
        );
        List<BloqoReviewData> reviews = [];
        if(publishedCourse.reviews.isNotEmpty) {
          reviews = await getReviewsFromIds(
              firestore: firestore,
              localizedText: localizedText,
              reviewsIds: publishedCourse.reviews
          );
        }
        bool enrollmentAlreadyRequested = false;
        if(!publishedCourse.isPublic) {
          if(!context.mounted) return;
          BloqoUserData myself = getUserFromAppState(context: context)!;
          enrollmentAlreadyRequested = await getNotificationFromPublishedCourseIdAndApplicantId(
              firestore: firestore,
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