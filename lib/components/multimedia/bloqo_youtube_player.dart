import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../style/bloqo_colors.dart';

class BloqoYouTubePlayer extends StatefulWidget {
  const BloqoYouTubePlayer({
    super.key,
    required this.url,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
  });

  final String url;
  final EdgeInsetsDirectional padding;

  @override
  State<BloqoYouTubePlayer> createState() => _BloqoYouTubePlayerState();
}

class _BloqoYouTubePlayerState extends State<BloqoYouTubePlayer> {

  bool shouldPlay = false;
  bool shouldShowError = false;
  late YoutubePlayerController youTubePlayerController;

  @override
  void initState() {
    super.initState();
    String? initialVideoId = YoutubePlayer.convertUrlToId(widget.url);
    if(initialVideoId != null) {
      youTubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(initialVideoId)!,
        flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            showLiveFullscreenButton: false
        ),
      );
    }
    else{
      shouldShowError = true;
    }
  }

  @override
  void dispose() {
    if(!shouldShowError) {
      youTubePlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationText = getAppLocalizations(context)!;
    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double aspectRatio = 16 / 9;

          if (!shouldShowError) {
            shouldPlay
                ? youTubePlayerController.play()
                : youTubePlayerController.pause();
          }

          return Center(
            child: !shouldShowError ? AspectRatio(
              aspectRatio: aspectRatio,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    shouldPlay = !shouldPlay;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.transparent,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    YoutubePlayer(controller: youTubePlayerController),
                    if (!shouldPlay)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                  ],
                )
              )
          ) : Center(
                child: Text(
                    localizationText.invalid_link,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: BloqoColors.error,
                        fontWeight: FontWeight.w500
                    )
                )
            ),
          );
        }
      ),
    );
  }
}