import 'package:flutter/material.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/models/media_models.dart';

class AlbumCard extends StatelessWidget {
  final AlbumModel album;
  final VoidCallback onTap;
  final double width;

  const AlbumCard({
    super.key,
    required this.album,
    required this.onTap,
    this.width = 148,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        album.coverPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.darkSurfaceElevated,
                          child: const Icon(Icons.album_rounded, color: AppColors.electricViolet),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              album.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.songTitle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ).copyWith(fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              album.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.artistName(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtistAvatar extends StatelessWidget {
  final ArtistModel artist;
  final VoidCallback onTap;
  final double radius;

  const ArtistAvatar({
    super.key,
    required this.artist,
    required this.onTap,
    this.radius = 42,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.cyanVioletGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricViolet.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundImage: AssetImage(artist.imagePath),
                backgroundColor: AppColors.darkSurfaceElevated,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: radius * 2.2,
              child: Text(
                artist.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.songTitle(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ).copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
