import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_player_service.dart';

final audioPlayerServiceProvider = Provider((ref) => AudioPlayerService());

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  final audioService = ref.watch(audioPlayerServiceProvider);
  return audioService.playerStateStream;
});

final positionDataProvider = StreamProvider<PositionData>((ref) {
  final audioService = ref.watch(audioPlayerServiceProvider);
  return audioService.positionDataStream;
});

final currentAffirmationProvider =
    StateProvider<AffirmationAudio?>((ref) => null);

class AffirmationAudio {
  final String id;
  final String title;
  final String category;
  final String audioUrl;
  final Duration duration;

  AffirmationAudio({
    required this.id,
    required this.title,
    required this.category,
    required this.audioUrl,
    required this.duration,
  });
}
