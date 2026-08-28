import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';

class LyricsScreen extends ConsumerWidget {
  const LyricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final song = playerState.currentSong;

    if (song == null) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(child: Text('No song playing')),
      );
    }

    final lyrics = song.lyrics.isNotEmpty
        ? song.lyrics
        : [
            "Instrumental Frequency Breakdown...",
            "Immerse yourself in the spatial sound stage.",
            "Feel the sub-bass resonate through your headphones.",
            "Enjoy the lossless audio flow.",
          ];

    // Determine pseudo active lyric line based on progress
    final double progress = playerState.duration.inMilliseconds > 0
        ? (playerState.position.inMilliseconds / playerState.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    final activeIndex = (progress * lyrics.length).floor().clamp(0, lyrics.length - 1);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background ambient mesh
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(song.coverUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Container(
              height: 380,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.electricViolet.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 32, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Column(
                        children: [
                          Text(
                            song.title,
                            style: AppTypography.songTitle(color: Colors.white),
                          ),
                          Text(
                            song.artist,
                            style: AppTypography.artistName(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48), // balance back button
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Real-time Visualizer spectrum header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.graphic_eq_rounded,
                                color: AppColors.neonCyan, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'SPATIAL RESO-LYRICS',
                              style: AppTypography.metadata(color: AppColors.neonCyan)
                                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                          ],
                        ),
                        Text(
                          Formatters.formatDuration(playerState.position),
                          style: AppTypography.metadata(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Lyrics Stream List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: lyrics.length,
                    itemBuilder: (context, index) {
                      final isActive = index == activeIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          lyrics[index],
                          style: isActive
                              ? AppTypography.lyricsActive(color: AppColors.neonCyan)
                              : AppTypography.lyricsInactive(
                                  color: AppColors.textMuted.withValues(alpha: 0.6),
                                ),
                        ),
                      );
                    },
                  ),
                ),

                // Mini bottom control bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous_rounded,
                              color: Colors.white),
                          onPressed: () =>
                              ref.read(playerControllerProvider.notifier).previous(),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                          ),
                          child: IconButton(
                            icon: Icon(
                              playerState.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => ref
                                .read(playerControllerProvider.notifier)
                                .togglePlayPause(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded,
                              color: Colors.white),
                          onPressed: () =>
                              ref.read(playerControllerProvider.notifier).next(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
