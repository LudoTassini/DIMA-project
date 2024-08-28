import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app_state/application_settings_app_state.dart';

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
    String? videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId != null) {
      youTubePlayerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
        ),
      )..addListener(() {
        if (youTubePlayerController.value.hasError) {
          setState(() {
            shouldShowError = true;
          });
        }
      });
    } else {
      setState(() {
        shouldShowError = true;
      });
    }
  }

  @override
  void dispose() {
    if (!shouldShowError) {
      youTubePlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
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
            child: !shouldShowError
                ? AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    YoutubePlayer(controller: youTubePlayerController),
                    if (!shouldPlay)
                      GestureDetector(
                        onTap: () {
                          if (youTubePlayerController.value.isPlaying) {
                            youTubePlayerController.pause();
                            setState(() {
                              shouldPlay = false;
                            });
                          } else {
                            youTubePlayerController.play();
                            setState(() {
                              shouldPlay = true;
                            });
                          }
                        },
                        child: Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                  ],
              ),
            )
            : Center(
              child: Text(
                localizationText.invalid_link,
                style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                  color: theme.colors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}