import 'package:ielts/chat/halper/audio_chat_tile.dart';
import 'package:ielts/chat/halper/progressbar_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

// const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

class AudioPlayerManager {
  final player = AudioPlayer();
  Stream<DurationState>? durationState;
  Duration totalDuration = const Duration(seconds: 0);
  Duration currentPosition = const Duration(seconds: 0);
  Audio? currentlyPlayingAudio ;
  ProgressBarState progress = ProgressBarState(total: Duration(seconds: 0), current: Duration(seconds: 0));
  void init(String url) {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
            (position, playbackEvent) => DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration,
        ));
    player.setUrl(url);
  }

  playAudio(Audio audio) async {
    currentlyPlayingAudio = audio;
    await player.setUrl(audio.url);
    player.play();
    listenToStates();
  }

  listenToStates() {
    player.positionStream.listen((event) {
      currentPosition = event;
      progress = ProgressBarState(current: currentPosition, total: totalDuration);

    });

    player.durationStream.listen((event) {
      totalDuration = event
          ?? const Duration(seconds: 0);
    });

    player.playerStateStream.listen((state) {
      if (state.playing) {
      } else {}
      switch (state.processingState) {
        case ProcessingState.idle:
          {
            return;
          }
        case ProcessingState.loading:
          return;
        case ProcessingState.buffering:
          return;
        case ProcessingState.ready:
          return;
        case ProcessingState.completed:
          currentlyPlayingAudio = null;
          return;
      }
    });
  }

  stopAudio() {
    player.stop();
    currentlyPlayingAudio = null;
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}