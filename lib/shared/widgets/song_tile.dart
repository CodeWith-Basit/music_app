import 'package:flutter/material.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/shared/models/song_model.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onMoreTap;
  final bool isFavorite;
  final Widget? trailing;
  final int? index;

  const SongTile({
    super.key,
    required this.song,
    this.isPlaying = false,
    required this.onTap,
    this.onFavoriteTap,
    this.onMoreTap,
    this.isFavorite = false,
    this.trailing,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColors.electricViolet.withValues(alpha: 0.15),
        highlightColor: AppColors.electricViolet.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (index != null) ...[
                SizedBox(
                  width: 24,
                  child: Text(
                    '${index! + 1}',
                    style: AppTypography.metadata(
                      color: isPlaying ? AppColors.neonCyan : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                    ).copyWith(fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              // Artwork
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      song.coverUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 52,
                        height: 52,
                        color: AppColors.darkSurfaceElevated,
                        child: const Icon(Icons.music_note, color: AppColors.neonCyan),
                      ),
                    ),
                  ),
                  if (isPlaying)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: EqualizerBarsMini(),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Title & Artist
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
                        color: isPlaying
                            ? AppColors.neonCyan
                            : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary),
                      ).copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.artistName(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        Text(
                          ' • ${Formatters.formatDuration(song.duration)}',
                          style: AppTypography.metadata(
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Buttons
              if (trailing != null)
                trailing!
              else ...[
                if (onFavoriteTap != null)
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFavorite ? AppColors.cyberMagenta : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      size: 20,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                if (onMoreTap != null)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      size: 20,
                    ),
                    onPressed: onMoreTap,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EqualizerBarsMini extends StatefulWidget {
  const EqualizerBarsMini({super.key});

  @override
  State<EqualizerBarsMini> createState() => _EqualizerBarsMiniState();
}

class _EqualizerBarsMiniState extends State<EqualizerBarsMini>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final val = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(6 + (val * 10)),
            const SizedBox(width: 2.5),
            _buildBar(14 - (val * 8)),
            const SizedBox(width: 2.5),
            _buildBar(8 + (val * 8)),
          ],
        );
      },
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 3,
      height: height.clamp(4.0, 18.0),
      decoration: BoxDecoration(
        color: AppColors.neonCyan,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
