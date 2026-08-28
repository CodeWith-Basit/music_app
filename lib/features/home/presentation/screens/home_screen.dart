import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';
import 'package:music_app/shared/widgets/song_tile.dart';
import 'package:music_app/shared/widgets/media_cards.dart';
import 'package:music_app/shared/widgets/common_widgets.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';
import 'package:music_app/features/library/presentation/controllers/library_controller.dart';
import 'package:music_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:music_app/features/details/presentation/screens/media_detail_screens.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.displayName ?? 'Basit';
    final playerState = ref.watch(playerControllerProvider);
    final libraryState = ref.watch(libraryControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allSongs = DemoMusicRepository.songs;
    final allAlbums = DemoMusicRepository.albums;
    final allArtists = DemoMusicRepository.artists;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // Dynamic Header with Profile & Wave spectrum
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, $userName 👋',
                          style: AppTypography.heroTitle(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ).copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Feel Every Frequency Today',
                          style: AppTypography.metadata(
                            color: AppColors.neonCyan,
                          ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                    // Profile Avatar with Glow
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.cyanVioletGradient,
                      ),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/person.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Hero Featured Banner: Spatial Atmosphere
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.deepViolet, AppColors.cyberMagenta],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricViolet.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/images/album_1.jpg',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'FEATURED FREQUENCY',
                              style: AppTypography.metadata(color: AppColors.neonCyan)
                                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Spatial Night Drive',
                            style: AppTypography.heroTitle(color: Colors.white)
                                .copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '140 BPM Binaural Flow State',
                            style: AppTypography.metadata(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Made For You (Horizontal Album Cards)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Made For You',
                  actionText: 'See all',
                  onActionTap: () {},
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: allAlbums.length,
                    itemBuilder: (context, index) {
                      final album = allAlbums[index];
                      return AlbumCard(
                        album: album,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlbumDetailScreen(album: album),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Recommended Artists
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Recommended Artists',
                  actionText: 'View More',
                  onActionTap: () {},
                ),
                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: allArtists.length,
                    itemBuilder: (context, index) {
                      final artist = allArtists[index];
                      return ArtistAvatar(
                        artist: artist,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ArtistDetailScreen(artist: artist),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Trending Now Tracks (Vertical List)
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Spectrum',
              actionText: 'Shuffle All',
              onActionTap: () {
                ref.read(playerControllerProvider.notifier).playSong(
                      allSongs.first,
                      newQueue: allSongs,
                    );
              },
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = allSongs[index];
                final isPlaying =
                    playerState.currentSong?.id == song.id && playerState.isPlaying;
                final isFav = libraryState.likedSongIds.contains(song.id);

                return SongTile(
                  index: index,
                  song: song,
                  isPlaying: isPlaying,
                  isFavorite: isFav,
                  onTap: () {
                    ref.read(playerControllerProvider.notifier).playSong(
                          song,
                          newQueue: allSongs,
                        );
                    ref
                        .read(libraryControllerProvider.notifier)
                        .addRecentlyPlayed(song);
                  },
                  onFavoriteTap: () {
                    ref
                        .read(libraryControllerProvider.notifier)
                        .toggleFavorite(song.id);
                  },
                );
              },
              childCount: allSongs.length,
            ),
          ),

          // Bottom padding so MiniPlayer never covers items
          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
      ),
    );
  }
}
