import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/pages/from_editor/section_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state/editor_course_app_state.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../utils/check_device.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class CourseContentPreviewPage extends StatefulWidget {

  const CourseContentPreviewPage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

  @override
  State<CourseContentPreviewPage> createState() => _CourseContentPreviewPageState();
}

class _CourseContentPreviewPageState extends State<CourseContentPreviewPage> with AutomaticKeepAliveClientMixin<CourseContentPreviewPage> {

  final List<String> _showSectionsList = [];
  bool isInitializedSectionMap = false;

  late BloqoCourseData course;
  late List<BloqoChapterData> chapters;
  late Map<String, List<BloqoSectionData>> sections;
  late Map<String, List<BloqoBlockData>> blocks;

  void initializeSectionsToShowMap(List<BloqoChapterData> chapters, List<dynamic> chaptersCompleted) {
    for (var chapter in chapters) {
      if (!chaptersCompleted.contains(chapter.id)) {
        _showSectionsList.add(chapter.id);
        break;
      }
    }
    isInitializedSectionMap = true;
  }

  void loadSections(String chapterId) {
    setState(() {
      _showSectionsList.add(chapterId);
    });
  }

  void hideSections(String chapterId) {
    setState(() {
      _showSectionsList.remove(chapterId);
    });
  }

  @override
  void initState(){
    super.initState();
    course = getEditorCourseFromAppState(context: context)!;
    chapters = getEditorCourseChaptersFromAppState(context: context)!;
    sections = getEditorCourseSectionsFromAppState(context: context)!;
    blocks = getEditorCourseBlocksFromAppState(context: context)!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    bool isTablet = checkDevice(context);

    if(!isInitializedSectionMap) {
      initializeSectionsToShowMap(getEditorCourseChaptersFromAppState(context: context)?? [], []);
    }

    BloqoUserData user = getUserFromAppState(context: context)!;

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Column(
              children: [
                BloqoBreadcrumbs(breadcrumbs: [
                  course.name,
                ]),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: !isTablet ? const EdgeInsetsDirectional.all(0) : Constants.tabletPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Text(
                                          "${localizedText.by} ",
                                          style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                            color: theme.colors.highContrastColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          user.username,
                                          style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                            color: theme.colors.highContrastColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                          course.description != null && course.description != '' ?
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          localizedText.description,
                                          style: theme.getThemeData().textTheme.displayLarge?.copyWith(
                                            color: theme.colors.highContrastColor,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      course.description!,
                                      style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: theme.colors.highContrastColor,
                                        fontSize: 16,
                                      ),
                                    )
                                  )
                                )
                            ]
                          ) : const SizedBox.shrink(), // This will take up no space
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                localizedText.content,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: theme.colors.highContrastColor,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  ...List.generate(
                                    chapters.length,
                                        (chapterIndex) {
                                      var chapter = chapters[chapterIndex];

                                      return BloqoSeasaltContainer(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 0, 0),
                                              child: Text(
                                                '${localizedText.chapter} ${chapterIndex + 1}',
                                                style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                                  color: theme.colors.secondaryText,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      chapter.name,
                                                      style: theme.getThemeData().textTheme.displayLarge?.copyWith(
                                                        color: theme.colors.leadingColor,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                              child: chapter.description != '' ? Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 10),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          chapter.description!,
                                                          style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                            color: theme.colors.primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) : const SizedBox.shrink(), // This will take up no space
                                            ),

                                            ... _showSectionsList.contains(chapter.id)
                                                ? [
                                              if (!isTablet)
                                                ...List.generate(
                                                  sections[chapter.id]!.length,
                                                      (sectionIndex) {
                                                    var section = sections[chapter.id]![sectionIndex];

                                                    return BloqoCourseSection(
                                                      section: section,
                                                      index: sectionIndex,
                                                      isClickable: true,
                                                      isInLearnPage: false,
                                                      isCompleted: false,
                                                      onPressed: () {
                                                        _goToSectionPreviewPage(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            chapterName: chapter.name,
                                                            sectionName: section.name,
                                                            blocks: blocks[section.id]!
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
                                              else Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    double width = constraints.maxWidth / 2;
                                                    double height = width / 2.35;
                                                    double childAspectRatio = width / height;

                                                    return GridView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 10.0,
                                                        mainAxisSpacing: 10.0,
                                                        childAspectRatio: childAspectRatio, // 5/2
                                                      ),
                                                      itemCount: sections[chapter.id]!.length,
                                                      itemBuilder: (context, sectionIndex) {
                                                        var section = sections[chapter.id]![sectionIndex];
                                                          return Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: BloqoCourseSection(
                                                              section: section,
                                                              index: sectionIndex,
                                                              isClickable: true,
                                                              isInLearnPage: false,
                                                              isCompleted: false,
                                                              onPressed: () {
                                                                _goToSectionPreviewPage(
                                                                  context: context,
                                                                  localizedText: localizedText,
                                                                  chapterName: chapter.name,
                                                                  sectionName: section.name,
                                                                  blocks: blocks[section.id]!
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Align(
                                                          alignment: const AlignmentDirectional(1, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              hideSections(
                                                                  chapter.id
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localizedText.collapse,
                                                                  style: TextStyle(
                                                                    color: theme.colors.secondaryText,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.keyboard_arrow_up_sharp,
                                                                  color: theme.colors.secondaryText,
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
                                              ] : [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      15, 0, 15, 5),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Align(
                                                          alignment: const AlignmentDirectional(1, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              loadSections(
                                                                  chapter.id
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localizedText.view_more,
                                                                  style: TextStyle(
                                                                    color: theme.colors.secondaryText,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.keyboard_arrow_right_sharp,
                                                                  color: theme.colors.secondaryText,
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
                                              ]
                                            ],
                                          )
                                      );
                                    },
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          );
        }
    );

  }

  @override
  bool get wantKeepAlive => true;

  void _goToSectionPreviewPage({
    required BuildContext context,
    required var localizedText,
    required String chapterName,
    required String sectionName,
    required List<BloqoBlockData> blocks,
  }) {
    widget.onPush(
      SectionPreviewPage(
        courseName: course.name,
        chapterName: chapterName,
        sectionName: sectionName,
        blocks: blocks
      )
    );
  }

}

