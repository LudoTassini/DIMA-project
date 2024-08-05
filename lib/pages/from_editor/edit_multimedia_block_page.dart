import 'dart:io';

import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/multimedia/bloqo_video_player.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_block.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../../utils/multimedia_uploader.dart';

class EditMultimediaBlockPage extends StatefulWidget {
  const EditMultimediaBlockPage({
    super.key,
    required this.onPush,
    required this.courseId,
    required this.chapterId,
    required this.sectionId,
    required this.block
  });

  final void Function(Widget) onPush;
  final String courseId;
  final String chapterId;
  final String sectionId;
  final BloqoBlock block;

  @override
  State<EditMultimediaBlockPage> createState() => _EditMultimediaBlockPageState();
}

class _EditMultimediaBlockPageState extends State<EditMultimediaBlockPage> with AutomaticKeepAliveClientMixin<EditMultimediaBlockPage> {

  late TextEditingController multimediaTypeController;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    multimediaTypeController = TextEditingController();
    multimediaTypeController.addListener(_onMultimediaTypeChanged);
  }

  void _onMultimediaTypeChanged() {
    if(!firstBuild) {
      setState(() {});
    }
    else{
      firstBuild = false;
    }
  }

  @override
  void dispose() {
    multimediaTypeController.removeListener(_onMultimediaTypeChanged);
    multimediaTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<EditorCourseAppState>(
        builder: (context, editorCourseAppState, _) {
          BloqoCourse course = getEditorCourseFromAppState(context: context)!;
          BloqoChapter chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
          BloqoSection section = getEditorCourseSectionFromAppState(context: context, chapterId: widget.chapterId, sectionId: widget.sectionId)!;
          BloqoBlock block = getEditorCourseBlockFromAppState(context: context, sectionId: widget.sectionId, blockId: widget.block.id)!;
          List<DropdownMenuEntry<String>> multimediaTypes = buildMultimediaTypesList(localizedText: localizedText);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BloqoBreadcrumbs(breadcrumbs: [
                course.name,
                chapter.name,
                section.name,
                block.name,
              ]),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BloqoSeasaltContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.choose_multimedia_type,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                                children:[
                                  Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      BloqoDropdown(
                                                          controller: multimediaTypeController,
                                                          dropdownMenuEntries: multimediaTypes,
                                                          initialSelection: multimediaTypes[0].value,
                                                          width: availableWidth
                                                      )
                                                    ]
                                                );
                                              }
                                          )
                                      )
                                  )
                                ]
                            ),
                          ],
                        ),
                      ),
                      BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            if(multimediaTypeController.text == BloqoBlockType.multimediaVideo.multimediaShortText(localizedText: localizedText))
                              Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          localizedText.upload_video,
                                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                            color: BloqoColors.russianViolet,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: BloqoFilledButton(
                                            color: BloqoColors.russianViolet,
                                            onPressed: () async {
                                              final newUrl = await _askUserForAVideo(
                                                context: context,
                                                localizedText: localizedText,
                                                courseId: widget.courseId,
                                                blockId: widget.block.id
                                              );
                                              if(newUrl != null) {
                                                if(!context.mounted) return;
                                                block.content = newUrl;
                                                updateEditorCourseBlockInAppState(context: context, sectionId: section.id, block: block);
                                              }
                                            },
                                            text: localizedText.upload_from_device,
                                            icon: Icons.upload
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                                        child: BloqoFilledButton(
                                            color: BloqoColors.russianViolet,
                                            onPressed: () {}, //TODO
                                            text: localizedText.embed_from_youtube,
                                            icon: Icons.link
                                        )
                                    )
                                  ]
                              )
                          ],
                        ),
                      ),
                      BloqoSeasaltContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.preview,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            BloqoVideoPlayer(
                              url: widget.block.content!
                            )
                          ]
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: BloqoFilledButton(
                  color: BloqoColors.russianViolet,
                  onPressed: () async {
                    context.loaderOverlay.show();
                    try {
                      await _saveChanges(
                        context: context,
                        courseId: course.id,
                        sectionId: section.id,
                        block: block,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                      );
                      context.loaderOverlay.hide();
                    } on BloqoException catch (e) {
                      if (!context.mounted) return;
                      context.loaderOverlay.hide();
                      showBloqoErrorAlert(
                        context: context,
                        title: localizedText.error_title,
                        description: e.message,
                      );
                    }
                  },
                  text: localizedText.save_changes,
                  icon: Icons.edit,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _saveChanges({required BuildContext context, required String courseId, required String sectionId, required BloqoBlock block}) async {
    var localizedText = getAppLocalizations(context)!;

    //block.content = textController.text;
    block.type = BloqoBlockType.text.toString();

    await saveBlockChanges(
      localizedText: localizedText,
      updatedBlock: block,
    );

    if (!context.mounted) return;
    BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
    updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

    await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);
  }

  Future<String?> _askUserForAVideo({required BuildContext context, required var localizedText, required String courseId, required String blockId}) async {
    PermissionStatus permissionStatus = await Permission.photos.request();

    if (permissionStatus.isGranted) {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        if (!context.mounted) return null;
        context.loaderOverlay.show();

        try {
          final video = File(pickedFile.path);
          final url = await uploadVideo(
            localizedText: localizedText,
            video: video,
            courseId: courseId,
            blockId: blockId
          );
          if (!context.mounted) return null;
          context.loaderOverlay.hide();

          ScaffoldMessenger.of(context).showSnackBar(
            BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
          );
          return url;
        } on BloqoException catch (e) {
          if (!context.mounted) return null;
          context.loaderOverlay.hide();
          showBloqoErrorAlert(
            context: context,
            title: localizedText.error_title,
            description: e.message,
          );
        }
      }
    }
    return null;
  }

}