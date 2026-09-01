# 🎧 Auralis — Flutter Music Player

Auralis is a modern music player application built with **Flutter and Dart**. The project focuses on creating a clean music-listening experience with custom UI, local audio playback, smooth interactions, and reusable Flutter components.

I built this project to improve my understanding of **Flutter UI development, audio playback, state management, navigation, animations, and reusable architecture**.

---

## ✨ Features

* 🎵 Local music playback
* ▶️ Play and pause songs
* ⏭️ Next and previous song controls
* 🎚️ Music progress slider
* 🎨 Modern dark-themed UI
* 🖼️ Album artwork support
* ✨ Animated UI elements
* 🎧 Centralized audio controller
* 🔄 Audio controller shared between screens
* 📱 Clean and responsive interface
* ⚡ Smooth screen navigation
* 💫 Lottie splash screen animation

---

## 🛠️ Built With

| Technology       | Purpose                        |
| ---------------- | ------------------------------ |
| **Flutter**      | UI and application development |
| **Dart**         | Programming language           |
| **AudioPlayers** | Audio playback                 |
| **Google Fonts** | Custom typography              |
| **Lottie**       | Splash screen animation        |

---

## 📱 Screens

### Splash Screen

Animated splash screen with the Auralis branding and Lottie animation.

### Home Screen

Displays featured playlists and available songs. Users can start playing a song directly from the home screen.

### Song Screen

Provides a dedicated music player interface with album artwork, song information, progress control, and playback controls.

---

## 🎧 Audio Architecture

Auralis uses a centralized `AudioController` to handle audio playback.

Instead of creating a separate `AudioPlayer` for every screen, the application uses one shared audio controller to manage:

* Current song
* Play / pause state
* Resume
* Stop
* Audio completion
* Song switching

This allows the **Home Screen and Song Screen to work with the same audio player**.

---

## 📂 Project Structure

```text
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
```

### Folder Overview

**`controllers/`**
Contains application controllers such as the centralized audio controller.

**`model/`**
Contains data models used by the application, including the `Song` model.

**`screens/`**
Contains the main application screens.

**`widiget/`**
Contains reusable UI widgets such as album cards and equalizer animations.

**`app_background.dart`**
Handles the application's custom background design.

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

### 2. Open the project

```bash
cd auralis
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

Make sure Flutter is properly installed and configured on your machine.

---

## 📦 Dependencies

The main packages used in this project are:

```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^YOUR_VERSION
  google_fonts: ^YOUR_VERSION
  lottie: ^YOUR_VERSION
```

> The exact package versions are available in `pubspec.yaml`.

---

## 🎵 Adding Songs

Songs are defined using the `Song` model.

Example:

```dart
const Song(
  title: 'Song Name',
  artist: 'Artist Name',
  songPath: 'assets/songs/song.mp3',
  imagePath: 'assets/images/song.jpg',
);
```

The audio and image files should be added to the appropriate asset directories and registered in `pubspec.yaml`.

Example:

```yaml
flutter:
  assets:
    - assets/songs/
    - assets/images/
    - assets/splash.json
```

---

## 🧠 What I Learned

Building Auralis helped me understand several important Flutter concepts:

* Working with Flutter layouts and reusable widgets
* Building custom UI components
* Using `ListView.builder` with models
* Handling navigation between screens
* Working with local assets
* Implementing audio playback with `audioplayers`
* Managing play/pause state
* Sharing an audio controller between screens
* Working with animations
* Creating custom dark-themed interfaces
* Debugging Flutter rendering and state-related issues

---

## 🔮 Future Improvements

Some features I would like to add in future versions:

* 🔊 Volume control
* 🔀 Shuffle mode
* 🔁 Repeat mode
* ❤️ Favorite songs
* 📋 Playlist creation
* 🔍 Search functionality
* 💾 Persistent playback state
* 🎼 Lyrics support
* 🎚️ Better audio progress synchronization
* 🌐 Online music streaming

---

## 📸 Screenshots

Add your application screenshots here:

```text
screenshots/
├── splash_screen.png
├── home_screen.png
└── song_screen.png
```

You can display them in the README using:

```markdown
![Splash Screen](screenshots/splash_screen.png)
![Home Screen](screenshots/home_screen.png)
![Song Screen](screenshots/song_screen.png)
```

---

## 🎥 Demo

Add your screen recording or demo video link here.

**Auralis Music Player Demo:**
YOUR_DEMO_LINK

---

## 👨‍💻 Developer

**Abdul Basit**

Flutter Developer | Mobile Application Development

I'm currently focused on improving my Flutter and Dart skills by building real-world mobile applications.

---

## ⭐ Support

If you found this project useful or interesting, consider giving the repository a ⭐.

Feedback and suggestions are always welcome.

---

## 📄 License

This project is created for learning and portfolio purposes.

Please make sure you have the appropriate rights to use any music, images, or other third-party assets included in the project.
