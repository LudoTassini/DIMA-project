import 'package:bloqo/pages/from_any/qr_code_page.dart';
import 'package:bloqo/utils/bloqo_qr_code_type.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_search_result_course.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_published_course.dart';
import '../../model/bloqo_review.dart';
import '../../model/bloqo_user.dart';
import '../../model/courses/bloqo_chapter.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import 'course_search_page.dart';

class UserCoursesPage extends StatefulWidget {
  const UserCoursesPage({
    super.key,
    required this.onPush,
    required this.onNavigate,
    required this.author,
    required this.publishedCourses
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigate;
  final BloqoUser author;
  final List<BloqoPublishedCourse> publishedCourses;

  @override
  State<UserCoursesPage> createState() => _UserCoursesPageState();
}

class _UserCoursesPageState extends State<UserCoursesPage> with AutomaticKeepAliveClientMixin<UserCoursesPage> {

  String? url;
  int _publishedCoursesDisplayed = Constants.coursesToShowAtFirst;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

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
            final user = getUserFromAppState(context: context)!;
            if(user.pictureUrl != "none"){
              url = user.pictureUrl;
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Stack(
                            alignment: const AlignmentDirectional(0, 1),
                            children: [
                              AspectRatio(
                                aspectRatio: 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: url != null
                                      ? FadeInImage.assetNetwork(
                                    placeholder: "assets/images/portrait_placeholder.png",
                                    image: url!,
                                    fit: BoxFit.cover,
                                    placeholderFit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    "assets/images/portrait_placeholder.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(1, 1),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: BloqoColors.russianViolet,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(8),
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              user.isFullNameVisible ?
                                                  Text(
                                                    user.fullName,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                      color: BloqoColors.secondaryText,
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )
                                              : const SizedBox(),

                                              Text(
                                                user.username,
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                  color: BloqoColors.primaryText,
                                                  fontSize: 22,
                                                  letterSpacing: 0,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(1, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: BloqoColors.russianViolet,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.qr_code_2,
                                              color: BloqoColors.seasalt,
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              _showUserQrCode(
                                                username: user.username,
                                                userId: user.id,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                    child: Wrap(
                                      spacing: 15.0,
                                      runSpacing: 10.0,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  localizedText.followers,
                                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                user.followers.toString(),
                                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  localizedText.following,
                                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                user.following.toString(),
                                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      localizedText.published_courses_by_author + widget.author.username,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24,
                        color: BloqoColors.seasalt
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
                            text: localizedText.load_more_courses,
                            color: BloqoColors.russianViolet,
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

  void _showUserQrCode({required String username, required String userId}){
    widget.onPush(QrCodePage(
        qrCodeTitle: username,
        qrCodeContent: "${BloqoQrCodeType.user.name}_$userId"
    ));
  }

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
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(CourseSearchPage(
        onPush: widget.onPush,
        onNavigateToPage: widget.onNavigate,
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