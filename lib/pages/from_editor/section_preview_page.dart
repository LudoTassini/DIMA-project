import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/quiz/bloqo_open_question_quiz.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../components/multimedia/bloqo_audio_player.dart';
import '../../components/multimedia/bloqo_video_player.dart';
import '../../components/multimedia/bloqo_youtube_player.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../components/quiz/bloqo_multiple_choice_quiz.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../style/bloqo_style_sheet.dart';

class SectionPreviewPage extends StatefulWidget {

  const SectionPreviewPage({
    super.key,
    required this.courseName,
    required this.chapterName,
    required this.sectionName,
    required this.blocks,
  });

  final String courseName;
  final String chapterName;
  final String sectionName;
  final List<BloqoBlockData> blocks;

  @override
  State<SectionPreviewPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPreviewPage> with AutomaticKeepAliveClientMixin<SectionPreviewPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isTablet = checkDevice(context);

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BloqoBreadcrumbs(
                    disable: true,
                    breadcrumbs: [
                      widget.courseName,
                      widget.chapterName,
                      widget.sectionName
                    ]),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Padding(
                          padding: isTablet ? Constants.tabletPadding : const EdgeInsetsDirectional.all(0),
                          child: Column(
                            children: [
                              ...List.generate(
                                  widget.blocks.length,
                                      (blockIndex) {
                                    var block = widget.blocks[blockIndex];

                                    if (block.type == BloqoBlockType.text.toString()) {
                                      return BloqoSeasaltContainer(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10), //20, 10, 20, 20
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                      child: MarkdownBody(
                                                        data: block.content,
                                                        styleSheet: BloqoMarkdownStyleSheet.get(),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    if(block.type == BloqoBlockType.multimediaAudio.toString()) {
                                      return BloqoSeasaltContainer(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20, 20, 20, 0),
                                        child: Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: BloqoAudioPlayer(
                                                      url: block.content
                                                  )
                                              ),
                                            ]
                                        ),
                                      );
                                    }

                                    if(block.type == BloqoBlockType.multimediaImage.toString()) {
                                      return BloqoSeasaltContainer(
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Image.network(block.content),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    if(block.type == BloqoBlockType.multimediaVideo.toString()) {
                                      return BloqoSeasaltContainer(
                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                              20, 20, 20, 0),
                                          child: block.content != "" ?
                                          Column(
                                              children: [
                                                !block.content.startsWith("yt:")
                                                    ? BloqoVideoPlayer(
                                                    url: block.content
                                                )
                                                    : BloqoYouTubePlayer(
                                                    url: block.content.substring(3)
                                                ),
                                              ]
                                          ) : Container()
                                      );
                                    }

                                    if(block.type == BloqoBlockType.quizOpenQuestion.toString()) {
                                      return BloqoOpenQuestionQuiz(
                                        block: block,
                                        isQuizCompleted: false,
                                        onQuestionAnsweredCorrectly: () {},
                                      );

                                    }

                                    if(block.type == BloqoBlockType.quizMultipleChoice.toString()) {
                                      return BloqoMultipleChoiceQuiz(
                                        block: block,
                                        isQuizCompleted: false,
                                        onQuestionAnsweredCorrectly: () {},
                                      );
                                    }
                                    return const SizedBox();
                                  }
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],

            ),

          );
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

}