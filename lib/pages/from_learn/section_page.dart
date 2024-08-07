import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/quiz/bloqo_open_question_quiz.dart';
import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../components/multimedia/bloqo_audio_player.dart';
import '../../components/multimedia/bloqo_video_player.dart';
import '../../components/multimedia/bloqo_youtube_player.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../components/quiz/bloqo_multiple_choice_quiz.dart';
import '../../model/courses/bloqo_block.dart';
import '../../style/bloqo_colors.dart';
import '../../style/bloqo_style_sheet.dart';
import '../../utils/localization.dart';

class SectionPage extends StatefulWidget {

  const SectionPage({
    super.key,
    required this.onPush,
    required this.section,
    required this.blocks,
    required this.courseName,
    required this.chapterName
  });

  final void Function(Widget) onPush;
  final BloqoSection section;
  final List<BloqoBlock> blocks;
  final String courseName;
  final String chapterName;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> with AutomaticKeepAliveClientMixin<SectionPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BloqoBreadcrumbs(
              breadcrumbs: [
                widget.courseName,
                widget.chapterName,
                widget.section.name
                // FIXME: non devono essere cliccabili
            ]),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                  ...List.generate(
                  widget.blocks.length,
                  (blockIndex) {
                    var block = widget.blocks[blockIndex];

                    if (block.type == BloqoBlockType.text.toString()) {
                      return BloqoSeasaltContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10), //20, 10, 20, 20
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  MarkdownBody(
                                    data: block.content,
                                    styleSheet: BloqoMarkdownStyleSheet.get(),
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
                            20, 0, 20, 20),
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
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
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
                            20, 0, 20, 20),
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
                    return BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: Column(
                          children: [
                            BloqoOpenQuestionQuiz(
                              onPush: widget.onPush,
                              block: block
                            ),

                        ],
                      ),
                    );
                  }

                  if(block.type == BloqoBlockType.quizMultipleChoice.toString()) {
                    return BloqoSeasaltContainer(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          BloqoMultipleChoiceQuiz(
                              onPush: widget.onPush,
                              block: block
                          ),

                        ],
                      ),
                    );
                  }

                    return const SizedBox();
                  }
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