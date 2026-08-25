import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? currentSongPath;

  AudioController() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
    });

    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying = false;
    });
  }

  Future<void> playSong(String songPath) async {
    currentSongPath = songPath;
    await audioPlayer.play(AssetSource(songPath.replaceFirst('assets/', '')));
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
  }

  Future<void> resumeSong() async {
    await audioPlayer.resume();
  }

  Future<void> stopSong() async {
    await audioPlayer.stop();
    currentSongPath = null;
  }

  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}
