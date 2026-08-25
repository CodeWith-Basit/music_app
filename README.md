# 🎵 Vibes — Flutter Music Player

Vibes is a modern music player mobile application built with Flutter.  
The app provides a clean and premium music-listening experience with dark/light mode, local audio playback, animated UI elements, and a dedicated music player screen.

---

## 📱 About The Project

Vibes is a Flutter-based music player designed to demonstrate how to build a modern music application with:

- Local audio playback
- Song and artist information
- Album artwork
- Play/Pause controls
- Dedicated song player screen
- Dark and Light mode
- Animated music indicators
- Responsive and modern UI

The project is built as a learning and portfolio project while exploring Flutter application architecture and audio handling.

---

## ✨ Features

### 🎧 Music Playback
- Play songs directly from the Home Screen
- Pause the currently playing song
- Play another song while the previous one stops
- Resume playback
- Stop playback
- Detect when a song finishes

### 🎨 Dark & Light Mode
- Dark mode with a premium purple gradient aesthetic
- Light mode with a clean minimal design
- Theme-aware text, icons, cards, and backgrounds
- Custom dark/light UI styling

### 🏠 Home Screen
- Welcome section
- Dark/Light mode switch
- Playlist/album section
- Latest songs list
- Album artwork
- Song title and artist
- Animated equalizer indicator for the currently playing song

### 🎵 Song Screen
- Large album artwork
- Song title
- Artist name
- Playback controls
- Music progress slider
- Dedicated player interface

### 🎬 Splash Screen
- Animated Lottie splash screen
- Animated app title
- Fade and slide animations
- Smooth transition to the Home Screen

---

## 🛠️ Technologies Used

- **Flutter**
- **Dart**
- **AudioPlayers**
- **Google Fonts**
- **Lottie**
- **Material Design**

---

## 📦 Packages

Main packages used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter

  audioplayers: ^latest
  google_fonts: ^latest
  lottie: ^latest

lib/
│
├── controllers/
│   └── audio_controller.dart
│
├── model/
│   └── song_model.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   └── song_screen.dart
│
├── widiget/
│   ├── album_widiget.dart
│   └── equalizer_widget.dart
│
├── app_background.dart
│
└── main.dart

🚀 Getting Started
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd vibes
flutter pub get
flutter run
