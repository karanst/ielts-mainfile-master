import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:ielts/chat/halper/audio_player_manager.dart';
import 'package:ielts/chat/halper/progressbar_state.dart';
import 'package:just_audio/just_audio.dart';

import '../models/message.dart';



class Audio {
  String id;
  String url;

  Audio({
    required this.id,
    required this.url,
  });
}

class AudioChatTile extends StatefulWidget {
  final Messages message;
  // final AudioPlayerManager audioPlayerManager;

  const AudioChatTile({Key? key, required  this.message}) : super(key: key);

  @override
  State<AudioChatTile> createState() => _AudioChatTileState();
}

//addon comment changes size and color & single play audio

class _AudioChatTileState extends State<AudioChatTile> {
  // final PlayerManager _playerManager = Get.find();
  ProgressBarState progress = ProgressBarState(total: Duration(seconds: 0), current: Duration(seconds: 0));

  var _isShowingWidgetOutline = false;
  var _labelLocation = TimeLabelLocation.below;
  var _labelType = TimeLabelType.totalTime;
  TextStyle? _labelStyle;
  var _thumbRadius = 10.0;
  var _labelPadding = 0.0;
  var _barHeight = 5.0;
  var _barCapShape = BarCapShape.round;
  Color? _baseBarColor;
  Color? _progressBarColor;
  Color? _bufferedBarColor;
  Color? _thumbColor;
  Color? _thumbGlowColor;
  var _thumbCanPaintOutsideBar = true;

  late AudioPlayerManager manager;

  @override
  void initState() {
    super.initState();
    manager = AudioPlayerManager();
    manager.init(widget.message.msg.toString());
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }
  // final player = AudioPlayer();

  Duration totalDuration = const Duration(seconds: 0);
  Duration currentPosition = const Duration(seconds: 0);
  Audio? currentlyPlayingAudio ;



  //
  // playAudioFile(File file) async {
  //   await player.setFilePath(file.path);
  //
  //   player.play();
  //   listenToStates();
  // }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: manager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: manager.player.seek,
          onDragUpdate: (details) {
            debugPrint('${details.timeStamp}, ${details.localPosition}');
          },
          barHeight: 2,
          baseBarColor: Colors.grey,
          progressBarColor: _progressBarColor,
          bufferedBarColor: _bufferedBarColor,
          thumbColor: _thumbColor,
          thumbGlowColor: Colors.amber,
          barCapShape: _barCapShape,
          thumbRadius: 6,
          thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
          timeLabelLocation: _labelLocation,
          timeLabelType: _labelType,
          timeLabelTextStyle: _labelStyle,
          timeLabelPadding: _labelPadding,
        );
      },
    );
  }
  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder<PlayerState>(
      stream: manager.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 25.0,
            height: 25.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 25.0,
            onPressed: manager.player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 25.0,
            onPressed: manager.player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 25.0,
            onPressed: () =>
                manager.player.seek(Duration.zero),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _playButton(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 20,
              child:  _progressBar()
            ),

          ],
        ),

      ],
    );
  }
}


