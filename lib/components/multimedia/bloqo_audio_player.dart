import 'package:audioplayers/audioplayers.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';

import '../../style/bloqo_colors.dart';
import '../buttons/bloqo_filled_button.dart';

class BloqoAudioPlayer extends StatefulWidget {
  const BloqoAudioPlayer({
    super.key,
    required this.url,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
  });

  final String url;
  final EdgeInsetsDirectional padding;

  @override
  State<BloqoAudioPlayer> createState() => _BloqoAudioPlayerState();
}

class _BloqoAudioPlayerState extends State<BloqoAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for completion event
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.url));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    return Padding(
        padding: widget.padding,
        child: Center(
          child: BloqoFilledButton(
              icon: isPlaying ? Icons.pause : Icons.play_arrow,
              onPressed: _playPause,
              color: BloqoColors.russianViolet,
              text: isPlaying ? localizedText.pause_audio : localizedText.play_audio
          ),
        )
    );
  }
}