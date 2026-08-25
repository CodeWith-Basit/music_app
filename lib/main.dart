import 'package:flutter/material.dart';
import 'package:music_app/controllers/audio_controller.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  final AudioController audioController = AudioController();

  MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibes',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(audioController: audioController),
    );
  }
}
