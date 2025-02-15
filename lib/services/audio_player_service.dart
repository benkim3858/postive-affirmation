import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          bufferedPosition: bufferedPosition,
          duration: duration ?? Duration.zero,
        ),
      );

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> setAudioSource(String url) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> stop() => _player.stop();

  void dispose() {
    _player.dispose();
  }
}
