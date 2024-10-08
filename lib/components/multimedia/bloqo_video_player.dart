import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BloqoVideoPlayer extends StatefulWidget {
  const BloqoVideoPlayer({
    super.key,
    required this.url,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
  });

  final String url;
  final EdgeInsetsDirectional padding;

  @override
  State<BloqoVideoPlayer> createState() => _BloqoVideoPlayerState();
}

class _BloqoVideoPlayerState extends State<BloqoVideoPlayer> {
  bool shouldPlay = false;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    if(widget.url.startsWith("assets")){
      videoPlayerController = VideoPlayerController.asset(widget.url);
    }
    else {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url));
      videoPlayerController.initialize().then((_) {
        setState(() {}); // Ensures the widget rebuilds once the video is initialized
      });
    }
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    if(!widget.url.startsWith("assets")) {
      videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var theme = getAppThemeFromAppState(context: context);

        if (!videoPlayerController.value.isInitialized) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator(
                color: theme.colors.leadingColor
              ))
          );
        }

        double videoWidth = videoPlayerController.value.size.width;
        double videoHeight = videoPlayerController.value.size.height;
        double aspectRatio = videoWidth / videoHeight;

        shouldPlay ? videoPlayerController.play() : videoPlayerController.pause();

        return Padding(
          padding: widget.padding,
          child: Center(
            child: AspectRatio(
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
                    VideoPlayer(videoPlayerController),
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}