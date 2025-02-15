import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_player_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 긍정 확언'),
        scrolledUnderElevation: 0,
      ),
      body: const _HomeContent(),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: '확언 목록',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic),
            label: '녹음',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle),
            label: '플레이어',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/affirmations');
            case 2:
              context.go('/record');
            case 3:
              context.go('/player');
            case 4:
              context.go('/settings');
          }
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TodayAffirmationCard(),
          const SizedBox(height: 24),
          Text(
            '나의 확언 재생목록',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: _AffirmationPlaylist(),
          ),
        ],
      ),
    );
  }
}

class _TodayAffirmationCard extends ConsumerWidget {
  const _TodayAffirmationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.watch(audioPlayerServiceProvider);
    final playerState = ref.watch(playerStateProvider);

    // 오늘의 확언 데이터
    final todayAffirmation = AffirmationAudio(
      id: 'today',
      title: '나는 매일 더 나은 사람이 되어갑니다.',
      category: '오늘의 확언',
      audioUrl: 'assets/sounds/today.mp3',
      duration: const Duration(minutes: 0, seconds: 30), // 실제 오디오 길이에 맞게 수정
    );

    return GestureDetector(
      onTap: () => context.go('/player'),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 확언',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                '나는 매일 더 나은 사람이 되어갑니다.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      playerState.whenOrNull(
                            data: (state) => state.playing &&
                                    ref.read(currentAffirmationProvider)?.id ==
                                        'today'
                                ? Icons.pause
                                : Icons.play_arrow,
                          ) ??
                          Icons.play_arrow,
                    ),
                    onPressed: () async {
                      final currentAffirmation =
                          ref.read(currentAffirmationProvider);

                      if (currentAffirmation?.id == 'today') {
                        // 이미 재생 중인 경우
                        playerState.whenData((state) {
                          if (state.playing) {
                            audioService.pause();
                          } else {
                            audioService.play();
                          }
                        });
                      } else {
                        // 새로운 재생
                        ref.read(currentAffirmationProvider.notifier).state =
                            todayAffirmation;
                        await audioService
                            .setAudioSource(todayAffirmation.audioUrl);
                        await audioService.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AffirmationPlaylist extends StatelessWidget {
  const _AffirmationPlaylist();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CurrentlyPlayingCard(),
        const SizedBox(height: 16),
        Expanded(
          child: _PlaylistView(),
        ),
      ],
    );
  }
}

class _CurrentlyPlayingCard extends ConsumerWidget {
  const _CurrentlyPlayingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAffirmation = ref.watch(currentAffirmationProvider);
    final playerState = ref.watch(playerStateProvider);
    final positionData = ref.watch(positionDataProvider);
    final audioService = ref.watch(audioPlayerServiceProvider);

    if (currentAffirmation == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => context.go('/player'),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentAffirmation.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentAffirmation.category,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              positionData.when(
                data: (position) => Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position.position),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _formatDuration(position.duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('재생 오류'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () {},
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      playerState.whenData((state) {
                        if (state.playing) {
                          audioService.pause();
                        } else {
                          audioService.play();
                        }
                      });
                    },
                    child: Icon(
                      playerState.whenOrNull(
                            data: (state) =>
                                state.playing ? Icons.pause : Icons.play_arrow,
                          ) ??
                          Icons.play_arrow,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
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

class _PlaylistView extends ConsumerWidget {
  const _PlaylistView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 임시 데이터 - 나중에 실제 데이터로 교체
    final playlist = [
      AffirmationAudio(
        id: '1',
        title: '나는 매일 성장합니다',
        category: '자기 계발',
        audioUrl: 'assets/audio/affirmation1.mp3',
        duration: const Duration(minutes: 1, seconds: 30),
      ),
      AffirmationAudio(
        id: '2',
        title: '나는 가치 있는 사람입니다',
        category: '자존감',
        audioUrl: 'assets/audio/affirmation2.mp3',
        duration: const Duration(minutes: 1, seconds: 45),
      ),
      AffirmationAudio(
        id: '3',
        title: '나는 내 삶의 주인공입니다',
        category: '자신감',
        audioUrl: 'assets/audio/affirmation3.mp3',
        duration: const Duration(minutes: 2, seconds: 0),
      ),
    ];

    final currentAffirmation = ref.watch(currentAffirmationProvider);
    final audioService = ref.watch(audioPlayerServiceProvider);

    return ListView.builder(
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        final affirmation = playlist[index];
        final isPlaying = currentAffirmation?.id == affirmation.id;

        return GestureDetector(
          onTap: () {
            _playAffirmation(ref, affirmation);
            context.go('/player');
          },
          child: Card(
            elevation: 0,
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPlaying
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  isPlaying ? Icons.music_note : Icons.queue_music,
                  color: isPlaying
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                affirmation.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(affirmation.category),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(affirmation.duration),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'play':
                          _playAffirmation(ref, affirmation);
                        case 'addToFavorites':
                          // TODO: 즐겨찾기 추가 구현
                          break;
                        case 'share':
                          // TODO: 공유 기능 구현
                          break;
                        case 'delete':
                          // TODO: 삭제 기능 구현
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'play',
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text('재생'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'addToFavorites',
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(width: 8),
                            Text('즐겨찾기에 추가'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('공유'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 8),
                            Text('삭제'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _playAffirmation(
      WidgetRef ref, AffirmationAudio affirmation) async {
    final audioService = ref.read(audioPlayerServiceProvider);

    // 현재 재생 중인 확언 업데이트
    ref.read(currentAffirmationProvider.notifier).state = affirmation;

    // 오디오 소스 설정 및 재생
    await audioService.setAudioSource(affirmation.audioUrl);
    await audioService.play();
  }
}
