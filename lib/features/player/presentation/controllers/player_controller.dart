import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/shared/models/song_model.dart';
import 'package:music_app/shared/data/demo_music_repository.dart';
import 'package:music_app/features/player/data/audio_player_service.dart';

class PlaybackState {
  final SongModel? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final List<SongModel> queue;
  final int currentIndex;
  final bool isShuffle;
  final RepeatMode repeatMode;
  final double playbackSpeed;

  const PlaybackState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.queue = const [],
    this.currentIndex = -1,
    this.isShuffle = false,
    this.repeatMode = RepeatMode.off,
    this.playbackSpeed = 1.0,
  });

  PlaybackState copyWith({
    SongModel? currentSong,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    List<SongModel>? queue,
    int? currentIndex,
    bool? isShuffle,
    RepeatMode? repeatMode,
    double? playbackSpeed,
  }) {
    return PlaybackState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isShuffle: isShuffle ?? this.isShuffle,
      repeatMode: repeatMode ?? this.repeatMode,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }
}

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final playerPositionStreamProvider = StreamProvider.autoDispose<Duration>((ref) {
  final audioService = ref.watch(audioPlayerServiceProvider);
  return audioService.positionStream;
});

final playerControllerProvider =
    StateNotifierProvider<PlayerController, PlaybackState>((ref) {
  final audioService = ref.watch(audioPlayerServiceProvider);
  return PlayerController(audioService);
});

class PlayerController extends StateNotifier<PlaybackState> {
  final AudioPlayerService _audioService;
  List<SongModel> _originalQueue = [];
  DateTime _lastPositionUpdate = DateTime.now();

  PlayerController(this._audioService) : super(const PlaybackState()) {
    _init();
  }

  void _init() {
    _audioService.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState == PlayerState.playing,
        isLoading: playerState == PlayerState.disposed,
      );
    });

    // Throttle position updates in the main state to prevent 60fps full-tree rebuilds
    _audioService.positionStream.listen((pos) {
      final now = DateTime.now();
      if (now.difference(_lastPositionUpdate).inMilliseconds >= 350) {
        _lastPositionUpdate = now;
        state = state.copyWith(position: pos);
      }
    });

    _audioService.durationStream.listen((dur) {
      state = state.copyWith(duration: dur);
    });

    _audioService.onPlayerComplete(() {
      _handleSongCompleted();
    });

    // Initialize with demo songs in queue
    final initialSongs = DemoMusicRepository.songs;
    _originalQueue = List.from(initialSongs);
    state = state.copyWith(
      queue: initialSongs,
      currentSong: initialSongs.first,
      currentIndex: 0,
      duration: initialSongs.first.duration,
    );
  }

  Future<void> playSong(SongModel song, {List<SongModel>? newQueue}) async {
    List<SongModel> updatedQueue = newQueue ?? state.queue;
    if (newQueue != null) {
      _originalQueue = List.from(newQueue);
      if (state.isShuffle) {
        updatedQueue = List.from(newQueue)..shuffle();
      }
    }

    final index = updatedQueue.indexWhere((s) => s.id == song.id);
    state = state.copyWith(
      currentSong: song,
      queue: updatedQueue,
      currentIndex: index >= 0 ? index : 0,
      isLoading: true,
      position: Duration.zero,
      duration: song.duration,
    );

    await _audioService.playSong(song);
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _audioService.pause();
    } else {
      if (state.currentSong != null) {
        if (state.position == Duration.zero) {
          await _audioService.playSong(state.currentSong!);
        } else {
          await _audioService.resume();
        }
      } else if (state.queue.isNotEmpty) {
        await playSong(state.queue.first);
      }
    }
  }

  Future<void> seek(Duration position) async {
    state = state.copyWith(position: position);
    await _audioService.seek(position);
  }

  Future<void> next() async {
    if (state.queue.isEmpty) return;

    int nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.queue.length) {
      if (state.repeatMode == RepeatMode.all) {
        nextIndex = 0;
      } else {
        return; // End of queue
      }
    }

    final nextSong = state.queue[nextIndex];
    await playSong(nextSong);
  }

  Future<void> previous() async {
    if (state.queue.isEmpty) return;

    if (state.position.inSeconds > 3) {
      // If played more than 3 seconds, restart current track
      await seek(Duration.zero);
      return;
    }

    int prevIndex = state.currentIndex - 1;
    if (prevIndex < 0) {
      prevIndex = state.repeatMode == RepeatMode.all ? state.queue.length - 1 : 0;
    }

    final prevSong = state.queue[prevIndex];
    await playSong(prevSong);
  }

  void toggleShuffle() {
    final newShuffle = !state.isShuffle;
    List<SongModel> newQueue;

    if (newShuffle) {
      final current = state.currentSong;
      newQueue = List.from(_originalQueue)..shuffle();
      if (current != null) {
        newQueue.removeWhere((s) => s.id == current.id);
        newQueue.insert(0, current);
      }
    } else {
      newQueue = List.from(_originalQueue);
    }

    final newIndex = state.currentSong != null
        ? newQueue.indexWhere((s) => s.id == state.currentSong!.id)
        : 0;

    state = state.copyWith(
      isShuffle: newShuffle,
      queue: newQueue,
      currentIndex: newIndex >= 0 ? newIndex : 0,
    );
  }

  void cycleRepeatMode() {
    final nextMode = switch (state.repeatMode) {
      RepeatMode.off => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.off,
    };
    state = state.copyWith(repeatMode: nextMode);
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = List<SongModel>.from(state.queue);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    final currentIndex = state.currentSong != null
        ? items.indexWhere((s) => s.id == state.currentSong!.id)
        : -1;

    state = state.copyWith(queue: items, currentIndex: currentIndex);
  }

  void removeFromQueue(String songId) {
    final items = List<SongModel>.from(state.queue)..removeWhere((s) => s.id == songId);
    final currentIndex = state.currentSong != null
        ? items.indexWhere((s) => s.id == state.currentSong!.id)
        : -1;

    state = state.copyWith(queue: items, currentIndex: currentIndex);
  }

  void addToQueue(SongModel song) {
    final items = List<SongModel>.from(state.queue)..add(song);
    state = state.copyWith(queue: items);
  }

  void clearQueue() {
    if (state.currentSong != null) {
      state = state.copyWith(queue: [state.currentSong!], currentIndex: 0);
    } else {
      state = state.copyWith(queue: [], currentIndex: -1);
    }
  }

  void setPlaybackSpeed(double speed) {
    _audioService.setPlaybackRate(speed);
    state = state.copyWith(playbackSpeed: speed);
  }

  void _handleSongCompleted() {
    if (state.repeatMode == RepeatMode.one) {
      if (state.currentSong != null) {
        seek(Duration.zero);
        _audioService.playSong(state.currentSong!);
      }
    } else {
      next();
    }
  }
}
