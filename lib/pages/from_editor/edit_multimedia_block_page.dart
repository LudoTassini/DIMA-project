import 'dart:io';

import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/multimedia/bloqo_youtube_player.dart';
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
import '../../components/popups/bloqo_confirmation_alert.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_block.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
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

  final formKeyYouTube = GlobalKey<FormState>();

  late TextEditingController multimediaTypeController;
  late TextEditingController youTubeLinkController;

  bool firstBuild = true;

  bool showAudioOptions = false;
  bool showImageOptions = false;
  bool showVideoOptions = false;
  bool showEmbedFromYouTube = false;

  @override
  void initState() {
    super.initState();
    multimediaTypeController = TextEditingController();
    multimediaTypeController.addListener(_onMultimediaTypeChanged);
    if(widget.block.type == BloqoBlockType.multimediaAudio.toString()){
      showAudioOptions = true;
    }
    else if(widget.block.type == BloqoBlockType.multimediaImage.toString()){
      showImageOptions = true;
    }
    else if(widget.block.type == BloqoBlockType.multimediaVideo.toString()){
      showVideoOptions = true;
    }
    youTubeLinkController = TextEditingController();
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
    youTubeLinkController.dispose();
    super.dispose();
  }

  void resetShowOptions(){
    showAudioOptions = false;
    showImageOptions = false;
    showVideoOptions = false;
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
          if(!firstBuild){
            if(multimediaTypeController.text == BloqoBlockType.multimediaAudio.multimediaShortText(localizedText: localizedText)){
              resetShowOptions();
              showAudioOptions = true;
            }
            else if(multimediaTypeController.text == BloqoBlockType.multimediaImage.multimediaShortText(localizedText: localizedText)){
              resetShowOptions();
              showImageOptions = true;
            }
            else if(multimediaTypeController.text == BloqoBlockType.multimediaVideo.multimediaShortText(localizedText: localizedText)){
              resetShowOptions();
              showVideoOptions = true;
            }
            else{
              resetShowOptions();
            }
          }
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
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      BloqoDropdown(
                                                          controller: multimediaTypeController,
                                                          dropdownMenuEntries: multimediaTypes,
                                                          initialSelection: widget.block.type != null ? widget.block.type.toString() : multimediaTypes[0].value,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: widget.block.content == "" && showVideoOptions ? Column(
                          children: [
                            if(showVideoOptions)
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
                                                await _saveChanges(context: context, courseId: widget.courseId, sectionId: widget.sectionId, block: block, blockType: BloqoBlockType.multimediaVideo);
                                                if(!context.mounted) return;
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
                                            onPressed: () {
                                              setState(() {
                                                showEmbedFromYouTube = true;
                                              });
                                            },
                                            text: localizedText.embed_from_youtube,
                                            icon: Icons.link
                                        )
                                    )
                                  ]
                              )
                          ],
                        ) : Container(),
                      ),
                      if(showEmbedFromYouTube)
                        BloqoSeasaltContainer(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                          child:  widget.block.content == "" && showVideoOptions ? Column(
                            children: [
                              if(showVideoOptions)
                                Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.embed_from_youtube,
                                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              color: BloqoColors.russianViolet,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: formKeyYouTube,
                                        child: BloqoTextField(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                                          formKey: formKeyYouTube,
                                          controller: youTubeLinkController,
                                          labelText: localizedText.youtube_link,
                                          hintText: localizedText.enter_youtube_link,
                                          maxInputLength: Constants.maxYouTubeLinkLength,
                                        )
                                      ),
                                      Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                                          child: BloqoFilledButton(
                                              color: BloqoColors.russianViolet,
                                              onPressed: () async {
                                                await _embedYouTubeVideo(
                                                    context: context,
                                                    localizedText: localizedText,
                                                    videoUrl: youTubeLinkController.text,
                                                    courseId: course.id,
                                                    sectionId: section.id,
                                                    block: widget.block
                                                );
                                              },
                                              text: localizedText.embed,
                                              icon: Icons.link
                                          )
                                      )
                                    ]
                                )
                            ],
                          ) : Container(),
                        ),
                      BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: widget.block.content != "" && showVideoOptions ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.multimedia_video_short,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            !widget.block.content!.startsWith("yt:") ? BloqoVideoPlayer(
                              url: widget.block.content!
                            ) : BloqoYouTubePlayer(url: widget.block.content!.substring(3)),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                              child: BloqoFilledButton(
                                color: BloqoColors.error,
                                onPressed: () {
                                  showBloqoConfirmationAlert(
                                    context: context,
                                    title: localizedText.warning,
                                    description: localizedText.delete_file_confirmation,
                                    confirmationFunction: () async {
                                      !widget.block.content!.startsWith("yt:") ?
                                      await _tryDeleteFile(
                                          context: context,
                                          localizedText: localizedText,
                                          filePath: 'videos/courses/${course
                                              .id}/${block.id}',
                                          courseId: course.id,
                                          sectionId: section.id,
                                          block: block
                                      ) : await _tryDeleteYouTubeLink(
                                        context: context,
                                        localizedText: localizedText,
                                        courseId: course.id,
                                        sectionId: section.id,
                                        block: block
                                      );
                                    },
                                    backgroundColor: BloqoColors.error
                                  );
                                },
                                text: localizedText.delete_file,
                                icon: Icons.delete_forever
                              )
                            )
                          ]
                        ) : Container()
                      ),
                    ],
                  ),
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

  Future<void> _tryDeleteFile({required BuildContext context, required var localizedText, required String filePath, required String courseId, required String sectionId, required BloqoBlock block}) async {
    context.loaderOverlay.show();
    try {
      await deleteFile(localizedText: localizedText, filePath: filePath);

      block.name = getNameBasedOnBlockSuperType(localizedText: localizedText,
          superType: BloqoBlockSuperType.multimedia);
      block.content = "";

      await saveBlockChanges(
        localizedText: localizedText,
        updatedBlock: block,
      );

      if (!context.mounted) return;
      BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(
          context: context)!.where((course) => course.courseId == courseId)
          .first;
      updateEditorCourseBlockInAppState(
          context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(localizedText: localizedText,
          updatedUserCourseCreated: userCourseCreated);

      if (!context.mounted) return;
      context.loaderOverlay.hide();
    } on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message
      );
    }
  }

  Future<void> _tryDeleteYouTubeLink({required BuildContext context, required var localizedText, required String courseId, required String sectionId, required BloqoBlock block}) async {
    context.loaderOverlay.show();
    try {

      block.name = getNameBasedOnBlockSuperType(localizedText: localizedText,
          superType: BloqoBlockSuperType.multimedia);
      block.content = "";

      await saveBlockChanges(
        localizedText: localizedText,
        updatedBlock: block,
      );

      if (!context.mounted) return;
      BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(
          context: context)!.where((course) => course.courseId == courseId)
          .first;
      updateEditorCourseBlockInAppState(
          context: context, sectionId: sectionId, block: block);

      await saveUserCourseCreatedChanges(localizedText: localizedText,
          updatedUserCourseCreated: userCourseCreated);

      if (!context.mounted) return;
      context.loaderOverlay.hide();
    } on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message
      );
    }
  }

  Future<void> _saveChanges({required BuildContext context, required String courseId, required String sectionId, required BloqoBlock block, required BloqoBlockType blockType}) async {
    var localizedText = getAppLocalizations(context)!;

    block.type = blockType.toString();
    block.name = getNameBasedOnBlockType(localizedText: localizedText, type: blockType);

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

  Future<void> _embedYouTubeVideo({required BuildContext context, required var localizedText, required String videoUrl, required String courseId, required String sectionId, required BloqoBlock block}) async {
      
    context.loaderOverlay.show();
    
    try {
        
      await saveVideoUrl(localizedText: localizedText, videoUrl: "yt:$videoUrl", blockId: block.id);

      block.content = videoUrl;
      block.name = getNameBasedOnBlockType(localizedText: localizedText, type: BloqoBlockType.multimediaVideo);
      block.type = BloqoBlockType.multimediaVideo.toString();

      if (!context.mounted) return;
      BloqoUserCourseCreated updatedUserCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
      await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: updatedUserCourseCreated);
      
      if (!context.mounted) return;
      updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);
      
      context.loaderOverlay.hide();

      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
      );
      
    } on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}