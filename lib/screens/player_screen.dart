import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAffirmation = ref.watch(currentAffirmationProvider);
    final playerState = ref.watch(playerStateProvider);
    final positionData = ref.watch(positionDataProvider);
    final audioService = ref.watch(audioPlayerServiceProvider);

    if (currentAffirmation == null) {
      return const Scaffold(
        body: Center(
          child: Text('재생 중인 확언이 없습니다'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('확언 플레이어'),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.music_note,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              currentAffirmation.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              currentAffirmation.category,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 48),
            positionData.when(
              data: (position) => Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: position.position.inMilliseconds.toDouble(),
                      max: position.duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        audioService.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position.position),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          _formatDuration(position.duration),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('재생 오류'),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  iconSize: 32,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  iconSize: 32,
                  onPressed: () {},
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        playerState.whenOrNull(
                              data: (state) => state.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ) ??
                            Icons.play_arrow,
                      ),
                      iconSize: 48,
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        playerState.whenData((state) {
                          if (state.playing) {
                            audioService.pause();
                          } else {
                            audioService.play();
                          }
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  iconSize: 32,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  iconSize: 32,
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
