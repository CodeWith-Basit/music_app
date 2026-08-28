import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/widgets/song_tile.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final queue = playerState.queue;
    final currentSong = playerState.currentSong;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Playing Queue',
          style: AppTypography.screenTitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 32,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(playerControllerProvider.notifier).clearQueue(),
            child: Text(
              'Clear',
              style: AppTypography.metadata(color: AppColors.cyberMagenta)
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
      body: queue.isEmpty
          ? Center(
              child: Text(
                'Your queue is empty.',
                style: AppTypography.bodyText(color: AppColors.textMuted),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentSong != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text(
                      'NOW PLAYING',
                      style: AppTypography.metadata(color: AppColors.neonCyan).copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SongTile(
                    song: currentSong,
                    isPlaying: playerState.isPlaying,
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.borderSubtle, height: 24),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'UP NEXT (${queue.length} Tracks)',
                    style: AppTypography.metadata(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: queue.length,
                    onReorder: (oldIdx, newIdx) {
                      ref
                          .read(playerControllerProvider.notifier)
                          .reorderQueue(oldIdx, newIdx);
                    },
                    itemBuilder: (context, index) {
                      final song = queue[index];
                      final isCurrent = song.id == currentSong?.id;

                      return Dismissible(
                        key: ValueKey(song.id + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppColors.warmPink.withValues(alpha: 0.8),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref
                              .read(playerControllerProvider.notifier)
                              .removeFromQueue(song.id);
                        },
                        child: SongTile(
                          index: index,
                          song: song,
                          isPlaying: isCurrent && playerState.isPlaying,
                          onTap: () {
                            ref
                                .read(playerControllerProvider.notifier)
                                .playSong(song);
                          },
                          trailing: const Icon(
                            Icons.drag_handle_rounded,
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
