import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';
import 'package:music_app/shared/widgets/song_tile.dart';
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';
import 'package:music_app/features/library/presentation/controllers/library_controller.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'New Playlist',
          style: AppTypography.songTitle(color: Colors.white).copyWith(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Playlist Name',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricViolet,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                ref
                    .read(libraryControllerProvider.notifier)
                    .createPlaylist(titleCtrl.text.trim(), descCtrl.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(libraryControllerProvider);
    final playerState = ref.watch(playerControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final likedSongs = DemoMusicRepository.songs
        .where((s) => libraryState.likedSongIds.contains(s.id))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Library',
                        style: AppTypography.heroTitle(
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 26),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                        onPressed: () => _showCreatePlaylistDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.neonCyan,
                    indicatorWeight: 3,
                    labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                    unselectedLabelColor: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    labelStyle: AppTypography.songTitle().copyWith(fontSize: 14),
                    tabs: const [
                      Tab(text: 'Liked Songs'),
                      Tab(text: 'Playlists'),
                      Tab(text: 'Recently Played'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: Liked Songs
              likedSongs.isEmpty
                  ? Center(
                      child: Text(
                        'No liked songs yet.\nTap heart on tracks you love.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyText(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: likedSongs.length,
                      itemBuilder: (context, index) {
                        final song = likedSongs[index];
                        final isPlaying =
                            playerState.currentSong?.id == song.id && playerState.isPlaying;
                        return SongTile(
                          index: index,
                          song: song,
                          isPlaying: isPlaying,
                          isFavorite: true,
                          onTap: () {
                            ref
                                .read(playerControllerProvider.notifier)
                                .playSong(song, newQueue: likedSongs);
                          },
                          onFavoriteTap: () {
                            ref
                                .read(libraryControllerProvider.notifier)
                                .toggleFavorite(song.id);
                          },
                        );
                      },
                    ),

              // TAB 2: Playlists
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: libraryState.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = libraryState.playlists[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              playlist.coverPath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 60,
                                height: 60,
                                color: AppColors.darkSurfaceElevated,
                                child: const Icon(Icons.queue_music_rounded,
                                    color: AppColors.softCyan),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist.title,
                                  style: AppTypography.songTitle(
                                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                                  ).copyWith(fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${playlist.songIds.length} Songs • ${playlist.description}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.metadata(
                                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill_rounded,
                                color: AppColors.electricViolet, size: 36),
                            onPressed: () {
                              if (playlist.songIds.isNotEmpty) {
                                final playlistSongs = DemoMusicRepository.songs
                                    .where((s) => playlist.songIds.contains(s.id))
                                    .toList();
                                if (playlistSongs.isNotEmpty) {
                                  ref
                                      .read(playerControllerProvider.notifier)
                                      .playSong(playlistSongs.first, newQueue: playlistSongs);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // TAB 3: Recently Played
              libraryState.recentlyPlayed.isEmpty
                  ? Center(
                      child: Text(
                        'No history yet. Start listening!',
                        style: AppTypography.bodyText(color: AppColors.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: libraryState.recentlyPlayed.length,
                      itemBuilder: (context, index) {
                        final song = libraryState.recentlyPlayed[index];
                        final isPlaying =
                            playerState.currentSong?.id == song.id && playerState.isPlaying;
                        final isFav = libraryState.likedSongIds.contains(song.id);

                        return SongTile(
                          index: index,
                          song: song,
                          isPlaying: isPlaying,
                          isFavorite: isFav,
                          onTap: () {
                            ref
                                .read(playerControllerProvider.notifier)
                                .playSong(song, newQueue: libraryState.recentlyPlayed);
                          },
                          onFavoriteTap: () {
                            ref
                                .read(libraryControllerProvider.notifier)
                                .toggleFavorite(song.id);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
