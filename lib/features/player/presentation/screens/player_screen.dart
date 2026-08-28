import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';
import 'package:music_app/features/library/presentation/controllers/library_controller.dart';
import 'package:music_app/features/player/presentation/screens/lyrics_screen.dart';
import 'package:music_app/features/player/presentation/screens/queue_screen.dart';
import 'package:music_app/features/player/data/audio_player_service.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerControllerProvider);
    final song = playerState.currentSong;

    if (playerState.isPlaying) {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat();
      }
    } else {
      if (_rotationController.isAnimating) {
        _rotationController.stop();
      }
    }

    if (song == null) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(child: Text('No song playing')),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final libraryState = ref.watch(libraryControllerProvider);
    final isFav = libraryState.likedSongIds.contains(song.id);

    final position = playerState.position;
    final duration = playerState.duration.inSeconds > 0
        ? playerState.duration
        : song.duration;

    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Dynamic backdrop ambient glow mapped to the cover
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.1,
                  colors: [
                    AppColors.electricViolet.withValues(alpha: 0.38),
                    AppColors.cyberMagenta.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  // Top Navigation Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 32,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Column(
                        children: [
                          Text(
                            'PLAYING FROM ALBUM',
                            style: AppTypography.metadata(
                              color: AppColors.softCyan,
                            ).copyWith(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.album,
                            style: AppTypography.songTitle(
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ).copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.queue_music_rounded,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, anim, secAnim) => const QueueScreen(),
                              transitionsBuilder: (context, anim, secAnim, child) =>
                                  FadeTransition(opacity: anim, child: child),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Center Vinyl / Pulsing Glowing Artwork
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft ambient glowing rings
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          width: 290,
                          height: 290,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: playerState.isPlaying
                                    ? AppColors.electricViolet.withValues(alpha: 0.4)
                                    : Colors.transparent,
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Spinning Vinyl Disc Edge
                        AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * 3.14159,
                              child: Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.borderSubtle.withValues(alpha: 0.8),
                                    width: 4,
                                  ),
                                  gradient: const SweepGradient(
                                    colors: [
                                      Color(0xFF1E1E2C),
                                      Color(0xFF0F0F1A),
                                      Color(0xFF28283E),
                                      Color(0xFF0F0F1A),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Hero(
                                    tag: 'player_artwork_${song.id}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        song.coverUrl,
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          width: 170,
                                          height: 170,
                                          color: AppColors.darkSurfaceElevated,
                                          child: const Icon(Icons.music_note,
                                              size: 60, color: AppColors.neonCyan),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Song Metadata & Heart action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.heroTitle(
                                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                              ).copyWith(fontSize: 22),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.artistName(
                                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              ).copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Favorite Toggle with scale feedback
                      IconButton(
                        iconSize: 28,
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? AppColors.cyberMagenta : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                        ),
                        onPressed: () => ref
                            .read(libraryControllerProvider.notifier)
                            .toggleFavorite(song.id),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Seeker Slider
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: AppColors.neonCyan,
                          inactiveTrackColor: isDark ? AppColors.borderSubtle : AppColors.lightBorder,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (val) {
                            final seekTo = Duration(
                              milliseconds: (val * duration.inMilliseconds).round(),
                            );
                            ref.read(playerControllerProvider.notifier).seek(seekTo);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Formatters.formatDuration(position),
                              style: AppTypography.metadata(
                                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            Text(
                              Formatters.formatDuration(duration),
                              style: AppTypography.metadata(
                                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Main Controls: Shuffle, Prev, Play/Pause, Next, Repeat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Shuffle
                      IconButton(
                        icon: Icon(
                          Icons.shuffle_rounded,
                          color: playerState.isShuffle
                              ? AppColors.neonCyan
                              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                        ),
                        onPressed: () =>
                            ref.read(playerControllerProvider.notifier).toggleShuffle(),
                      ),
                      // Previous
                      IconButton(
                        iconSize: 34,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: () =>
                            ref.read(playerControllerProvider.notifier).previous(),
                      ),
                      // Play / Pause glowing big center button
                      GestureDetector(
                        onTap: () => ref
                            .read(playerControllerProvider.notifier)
                            .togglePlayPause(),
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.electricViolet.withValues(alpha: 0.5),
                                blurRadius: 24,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            playerState.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      // Next
                      IconButton(
                        iconSize: 34,
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ),
                        onPressed: () =>
                            ref.read(playerControllerProvider.notifier).next(),
                      ),
                      // Repeat
                      IconButton(
                        icon: Icon(
                          playerState.repeatMode == RepeatMode.one
                              ? Icons.repeat_one_rounded
                              : Icons.repeat_rounded,
                          color: playerState.repeatMode != RepeatMode.off
                              ? AppColors.neonCyan
                              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                        ),
                        onPressed: () =>
                            ref.read(playerControllerProvider.notifier).cycleRepeatMode(),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Bottom Lyrics Drawer Peek Tab
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, anim, secAnim) => const LyricsScreen(),
                          transitionsBuilder: (context, anim, secAnim, child) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                  parent: anim, curve: Curves.easeOutCubic),
                            ),
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lyrics_outlined,
                              color: AppColors.softCyan, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'LYRICS & FREQUENCY SPECTRUM',
                            style: AppTypography.metadata(
                              color: AppColors.softCyan,
                            ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_up_rounded,
                              color: AppColors.softCyan, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
