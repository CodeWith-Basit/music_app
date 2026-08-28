import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/shared/models/song_model.dart';
import 'package:music_app/shared/models/media_models.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';

class SearchState {
  final String query;
  final String selectedGenre;
  final List<SongModel> songs;
  final List<ArtistModel> artists;
  final List<AlbumModel> albums;
  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.selectedGenre = 'All',
    this.songs = const [],
    this.artists = const [],
    this.albums = const [],
    this.recentSearches = const ['Lat Lag Gayi', 'Mustafa Zahid', 'Synthwave', 'Rahat Fateh Ali Khan'],
  });

  SearchState copyWith({
    String? query,
    String? selectedGenre,
    List<SongModel>? songs,
    List<ArtistModel>? artists,
    List<AlbumModel>? albums,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      songs: songs ?? this.songs,
      artists: artists ?? this.artists,
      albums: albums ?? this.albums,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
  return SearchController();
});

class SearchController extends StateNotifier<SearchState> {
  SearchController()
      : super(SearchState(
          songs: DemoMusicRepository.songs,
          artists: DemoMusicRepository.artists,
          albums: DemoMusicRepository.albums,
        ));

  void setGenre(String genre) {
    state = state.copyWith(selectedGenre: genre);
    _filter();
  }

  void search(String query) {
    state = state.copyWith(query: query);
    _filter();
  }

  void addRecentSearch(String term) {
    if (term.trim().isEmpty) return;
    final updated = List<String>.from(state.recentSearches)
      ..remove(term)
      ..insert(0, term);
    state = state.copyWith(recentSearches: updated.take(8).toList());
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }

  void _filter() {
    final q = state.query.toLowerCase().trim();
    final genre = state.selectedGenre;

    final filteredSongs = DemoMusicRepository.songs.where((song) {
      final matchesQuery = q.isEmpty ||
          song.title.toLowerCase().contains(q) ||
          song.artist.toLowerCase().contains(q) ||
          song.album.toLowerCase().contains(q);

      final matchesGenre =
          genre == 'All' || song.genre.toLowerCase().contains(genre.toLowerCase());

      return matchesQuery && matchesGenre;
    }).toList();

    final filteredArtists = DemoMusicRepository.artists.where((artist) {
      final matchesQuery = q.isEmpty ||
          artist.name.toLowerCase().contains(q) ||
          artist.genre.toLowerCase().contains(q);
      final matchesGenre =
          genre == 'All' || artist.genre.toLowerCase().contains(genre.toLowerCase());
      return matchesQuery && matchesGenre;
    }).toList();

    final filteredAlbums = DemoMusicRepository.albums.where((album) {
      return q.isEmpty ||
          album.title.toLowerCase().contains(q) ||
          album.artist.toLowerCase().contains(q);
    }).toList();

    state = state.copyWith(
      songs: filteredSongs,
      artists: filteredArtists,
      albums: filteredAlbums,
    );
  }
}
