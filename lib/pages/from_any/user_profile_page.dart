import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_search_result_course.dart';
import '../../components/complex/bloqo_user_details.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/courses/published_courses/bloqo_review_data.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_chapter_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../from_search/course_search_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage,
    required this.author,
    required this.publishedCourses
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;
  final BloqoUserData author;
  final List<BloqoPublishedCourseData> publishedCourses;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with AutomaticKeepAliveClientMixin<UserProfilePage> {

  String? url;
  int _publishedCoursesDisplayed = Constants.coursesToShowAtFirst;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    void loadMorePublishedCourses() {
      setState(() {
        _publishedCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: SingleChildScrollView(
        child: Consumer<UserAppState>(
          builder: (context, userAppState, _) {
            if(widget.author.pictureUrl != "none"){
              url = widget.author.pictureUrl;
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BloqoUserDetails(
                  user: widget.author,
                  isFullNameVisible: widget.author.isFullNameVisible,
                  onPush: widget.onPush,
                  onNavigateToPage: widget.onNavigateToPage,
                  showFollowingOptions: widget.author.id != getUserFromAppState(context: context)!.id,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      localizedText.published_courses_by_author + widget.author.username,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        color: theme.colors.highContrastColor
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
                : const SizedBox(),

              ],
            );
          },
        ),
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
        reviews:reviews,
        rating: publishedCourse.rating,
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