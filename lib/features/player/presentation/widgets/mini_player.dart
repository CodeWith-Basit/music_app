import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';
import 'package:music_app/features/library/presentation/controllers/library_controller.dart';
import 'package:music_app/features/player/presentation/screens/player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final song = playerState.currentSong;

    if (song == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final libraryState = ref.watch(libraryControllerProvider);
    final isFav = libraryState.likedSongIds.contains(song.id);

    final double progress = playerState.duration.inMilliseconds > 0
        ? (playerState.position.inMilliseconds /
                playerState.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, _, _) => const PlayerScreen(),
              transitionsBuilder: (_, animation, _, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                        parent: animation, curve: Curves.easeOutCubic),
                  ),
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricViolet.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: GlassContainer(
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            blur: 24,
            opacity: isDark ? 0.22 : 0.7,
            color: isDark ? const Color(0xFF1E1E34) : Colors.white,
            border: Border.all(
              color: isDark
                  ? AppColors.electricViolet.withValues(alpha: 0.35)
                  : AppColors.lightBorder,
              width: 1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Small Rotating / Pulsing Album Art
                    Hero(
                      tag: 'player_artwork_${song.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          song.coverUrl,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 46,
                            height: 46,
                            color: AppColors.darkSurfaceElevated,
                            child: const Icon(Icons.music_note,
                                color: AppColors.neonCyan),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Song Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.songTitle(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ).copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.artistName(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ).copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Like button
                    IconButton(
                      icon: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav
                            ? AppColors.cyberMagenta
                            : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                        size: 22,
                      ),
                      onPressed: () => ref
                          .read(libraryControllerProvider.notifier)
                          .toggleFavorite(song.id),
                    ),

                    // Play / Pause Button
                    Container(
                      width: 42,
                      height: 42,
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
                          size: 24,
                        ),
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .togglePlayPause(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Tiny sleek progress line
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2.5,
                    backgroundColor: isDark
                        ? AppColors.borderSubtle
                        : AppColors.lightBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.neonCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
