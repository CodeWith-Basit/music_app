import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/shared/widgets/song_tile.dart';
import 'package:music_app/shared/widgets/common_widgets.dart';
import 'package:music_app/features/search/presentation/controllers/search_controller.dart' as app_search;
import 'package:music_app/features/player/presentation/controllers/player_controller.dart';
import 'package:music_app/features/library/presentation/controllers/library_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchFieldController = TextEditingController();

  final List<String> _genres = [
    'All',
    'Pop',
    'Rock',
    'Synthwave',
    'Sufi',
    'Lo-Fi',
    'Acoustic',
    'Dance',
  ];

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(app_search.searchControllerProvider);
    final searchNotifier = ref.read(app_search.searchControllerProvider.notifier);
    final playerState = ref.watch(playerControllerProvider);
    final libraryState = ref.watch(libraryControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Search Header Title & Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Frequencies',
                      style: AppTypography.heroTitle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar Input
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: AppColors.neonCyan, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchFieldController,
                              style: TextStyle(
                                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                              ),
                              onChanged: (val) => searchNotifier.search(val),
                              onSubmitted: (val) => searchNotifier.addRecentSearch(val),
                              decoration: InputDecoration(
                                hintText: 'Songs, artists, albums, moods...',
                                hintStyle: TextStyle(
                                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchFieldController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchFieldController.clear();
                                searchNotifier.search('');
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Genre Filters (Horizontal Chips)
                    SizedBox(
                      height: 38,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _genres.length,
                        itemBuilder: (context, index) {
                          final genre = _genres[index];
                          final isSelected = searchState.selectedGenre == genre;
                          return GestureDetector(
                            onTap: () => searchNotifier.setGenre(genre),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isSelected
                                    ? null
                                    : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : (isDark ? AppColors.borderSubtle : AppColors.lightBorder),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  genre,
                                  style: AppTypography.metadata(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                                  ).copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Searches (if query is empty)
            if (searchState.query.isEmpty && searchState.recentSearches.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Searches',
                        style: AppTypography.sectionHeading(
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        ).copyWith(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => searchNotifier.clearRecentSearches(),
                        child: Text(
                          'Clear all',
                          style: AppTypography.metadata(color: AppColors.cyberMagenta),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: searchState.recentSearches.map((term) {
                      return ActionChip(
                        label: Text(term),
                        labelStyle: AppTypography.metadata(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                        ),
                        backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                        side: BorderSide(
                          color: isDark ? AppColors.borderSubtle : AppColors.lightBorder,
                        ),
                        onPressed: () {
                          _searchFieldController.text = term;
                          searchNotifier.search(term);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            // Results count
            SliverToBoxAdapter(
              child: SectionHeader(
                title: searchState.query.isEmpty
                    ? 'Explore Results'
                    : 'Found ${searchState.songs.length} Tracks',
              ),
            ),

            // Songs Result List
            if (searchState.songs.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'No matching frequencies found.',
                          style: AppTypography.bodyText(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = searchState.songs[index];
                    final isPlaying =
                        playerState.currentSong?.id == song.id && playerState.isPlaying;
                    final isFav = libraryState.likedSongIds.contains(song.id);

                    return SongTile(
                      index: index,
                      song: song,
                      isPlaying: isPlaying,
                      isFavorite: isFav,
                      onTap: () {
                        searchNotifier.addRecentSearch(song.title);
                        ref.read(playerControllerProvider.notifier).playSong(
                              song,
                              newQueue: searchState.songs,
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
                  childCount: searchState.songs.length,
                ),
              ),

            // Bottom Spacing for MiniPlayer
            const SliverToBoxAdapter(
              child: SizedBox(height: 110),
            ),
          ],
        ),
      ),
    );
  }
}
