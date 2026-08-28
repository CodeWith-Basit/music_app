import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/shared/models/song_model.dart';

enum RepeatMode { off, all, one }

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playerStateController = StreamController<PlayerState>.broadcast();

  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  PlayerState _currentState = PlayerState.stopped;
  PlayerState get currentState => _currentState;

  Duration _currentPosition = Duration.zero;
  Duration get currentPosition => _currentPosition;

  Duration _totalDuration = Duration.zero;
  Duration get totalDuration => _totalDuration;

  AudioPlayerService() {
    _initListeners();
  }

  void _initListeners() {
    _player.onPositionChanged.listen((pos) {
      _currentPosition = pos;
      _positionController.add(pos);
    });

    _player.onDurationChanged.listen((dur) {
      _totalDuration = dur;
      _durationController.add(dur);
    });

    _player.onPlayerStateChanged.listen((state) {
      _currentState = state;
      _playerStateController.add(state);
    });
  }

  Future<void> playSong(SongModel song) async {
    try {
      await _player.stop();
      // audioplayers AssetSource expects relative path from assets/ folder
      // e.g. songs/lat-lag-gaye.mp3
      String assetPath = song.assetPath;
      if (assetPath.startsWith('assets/')) {
        assetPath = assetPath.replaceFirst('assets/', '');
      }
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      // Fallback in case of asset path issues
      await _player.play(AssetSource(song.assetPath));
    }
  }

  Future<void> resume() async {
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setPlaybackRate(double rate) async {
    await _player.setPlaybackRate(rate);
  }

  void onPlayerComplete(void Function() onComplete) {
    _player.onPlayerComplete.listen((_) => onComplete());
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _positionController.close();
    await _durationController.close();
    await _playerStateController.close();
  }
}
