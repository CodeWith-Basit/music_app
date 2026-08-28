import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/shared/models/song_model.dart';
import 'package:music_app/shared/models/media_models.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LibraryState {
  final List<String> likedSongIds;
  final List<PlaylistModel> playlists;
  final List<SongModel> recentlyPlayed;

  const LibraryState({
    this.likedSongIds = const ['song_1', 'song_2', 'song_5'],
    this.playlists = const [],
    this.recentlyPlayed = const [],
  });

  LibraryState copyWith({
    List<String>? likedSongIds,
    List<PlaylistModel>? playlists,
    List<SongModel>? recentlyPlayed,
  }) {
    return LibraryState(
      likedSongIds: likedSongIds ?? this.likedSongIds,
      playlists: playlists ?? this.playlists,
      recentlyPlayed: recentlyPlayed ?? this.recentlyPlayed,
    );
  }
}

final libraryControllerProvider =
    StateNotifierProvider<LibraryController, LibraryState>((ref) {
  return LibraryController();
});

class LibraryController extends StateNotifier<LibraryState> {
  LibraryController() : super(const LibraryState()) {
    _loadFromStorage();
  }

  static const _likedKey = 'auralis_liked_songs';
  static const _playlistsKey = 'auralis_playlists';
  static const _recentKey = 'auralis_recent_songs';

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final liked = prefs.getStringList(_likedKey) ?? ['song_1', 'song_2', 'song_5'];

      List<PlaylistModel> playlists = DemoMusicRepository.initialPlaylists;
      final savedPlaylistsJson = prefs.getStringList(_playlistsKey);
      if (savedPlaylistsJson != null && savedPlaylistsJson.isNotEmpty) {
        playlists = savedPlaylistsJson
            .map((p) => PlaylistModel.fromJson(jsonDecode(p)))
            .toList();
      }

      final recentIds = prefs.getStringList(_recentKey) ?? ['song_1', 'song_6', 'song_3'];
      final recentSongs = recentIds
          .map((id) => DemoMusicRepository.songs.firstWhere(
                (s) => s.id == id,
                orElse: () => DemoMusicRepository.songs.first,
              ))
          .toList();

      state = state.copyWith(
        likedSongIds: liked,
        playlists: playlists,
        recentlyPlayed: recentSongs,
      );
    } catch (_) {
      state = state.copyWith(
        playlists: DemoMusicRepository.initialPlaylists,
        recentlyPlayed: DemoMusicRepository.songs.take(4).toList(),
      );
    }
  }

  Future<void> toggleFavorite(String songId) async {
    final currentLiked = List<String>.from(state.likedSongIds);
    if (currentLiked.contains(songId)) {
      currentLiked.remove(songId);
    } else {
      currentLiked.add(songId);
    }

    state = state.copyWith(likedSongIds: currentLiked);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedKey, currentLiked);
  }

  bool isFavorite(String songId) => state.likedSongIds.contains(songId);

  Future<void> addRecentlyPlayed(SongModel song) async {
    final updated = List<SongModel>.from(state.recentlyPlayed)
      ..removeWhere((s) => s.id == song.id)
      ..insert(0, song);

    final capped = updated.take(15).toList();
    state = state.copyWith(recentlyPlayed: capped);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, capped.map((s) => s.id).toList());
  }

  Future<void> createPlaylist(String title, String description) async {
    final newPlaylist = PlaylistModel(
      id: 'pl_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      coverPath: 'assets/images/album_1.jpg',
      songIds: [],
      createdAt: DateTime.now(),
    );

    final updated = List<PlaylistModel>.from(state.playlists)..insert(0, newPlaylist);
    state = state.copyWith(playlists: updated);
    _savePlaylists(updated);
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final updated = state.playlists.map((pl) {
      if (pl.id == playlistId && !pl.songIds.contains(songId)) {
        return pl.copyWith(songIds: [...pl.songIds, songId]);
      }
      return pl;
    }).toList();

    state = state.copyWith(playlists: updated);
    _savePlaylists(updated);
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final updated = state.playlists.map((pl) {
      if (pl.id == playlistId) {
        return pl.copyWith(
          songIds: pl.songIds.where((id) => id != songId).toList(),
        );
      }
      return pl;
    }).toList();

    state = state.copyWith(playlists: updated);
    _savePlaylists(updated);
  }

  Future<void> deletePlaylist(String playlistId) async {
    final updated = state.playlists.where((p) => p.id != playlistId).toList();
    state = state.copyWith(playlists: updated);
    _savePlaylists(updated);
  }

  Future<void> _savePlaylists(List<PlaylistModel> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = playlists.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_playlistsKey, jsonList);
  }
}
