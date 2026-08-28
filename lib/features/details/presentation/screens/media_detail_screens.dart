import 'package:flutter/material.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/models/media_models.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';
import 'package:music_app/shared/widgets/song_tile.dart';
import 'package:music_app/shared/widgets/common_widgets.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ArtistModel artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final artistSongs = DemoMusicRepository.songs
        .where((s) => s.artist.toLowerCase().contains(artist.name.toLowerCase()) || artist.songIds.contains(s.id))
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                artist.name,
                style: AppTypography.songTitle(color: Colors.white).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    artist.imagePath,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.electricViolet.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.electricViolet),
                        ),
                        child: Text(
                          artist.genre,
                          style: AppTypography.metadata(color: AppColors.neonCyan),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(artist.monthlyListeners / 1000000).toStringAsFixed(1)}M monthly listeners',
                        style: AppTypography.metadata(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    artist.bio.isNotEmpty
                        ? artist.bio
                        : 'Renowned artist delivering exceptional frequencies across global concert halls and spatial streaming services.',
                    style: AppTypography.bodyText(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Popular Tracks'),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = artistSongs[index];
                return SongTile(
                  index: index,
                  song: song,
                  onTap: () {},
                );
              },
              childCount: artistSongs.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 90),
          ),
        ],
      ),
    );
  }
}

class AlbumDetailScreen extends StatelessWidget {
  final AlbumModel album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final albumSongs = DemoMusicRepository.songs
        .where((s) => album.songIds.contains(s.id) || s.album.toLowerCase().contains(album.title.toLowerCase()))
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                album.title,
                style: AppTypography.songTitle(color: Colors.white).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    album.coverPath,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${album.artist} • ${album.releaseYear} • ${albumSongs.length} Songs',
                    style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    album.description.isNotEmpty
                        ? album.description
                        : 'A sonic masterpiece engineered with next-generation spatial acoustics.',
                    style: AppTypography.bodyText(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Tracklist'),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = albumSongs[index];
                return SongTile(
                  index: index,
                  song: song,
                  onTap: () {},
                );
              },
              childCount: albumSongs.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 90),
          ),
        ],
      ),
    );
  }
}
