import 'package:music_app/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/app_background.dart';
import 'package:music_app/model/song_model.dart';
import 'package:music_app/screens/song_screen.dart';
import 'package:music_app/widiget/album_widiget.dart';
import 'package:music_app/widiget/equalizer_widget.dart';

class HomeScreen extends StatefulWidget {
  final AudioController audioController;
  const HomeScreen({super.key, required this.audioController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = true;
  int? currentSongIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        isDarkMode: isDarkMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.inter(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(
                          Icons.dark_mode,
                          size: 20,
                          color: Colors.white,
                        );
                      }

                      return const Icon(Icons.light_mode, size: 20);
                    }),
                    activeThumbColor: const Color(0xFF3B0B4F),
                    activeTrackColor: const Color(0xFFE8C7F2),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "What do you feel like today?",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AlbumWidiget(
                      albumImage: "assets/images/album_1.jpg",
                      label1: "R&B Playlist",
                      label2: "Chill your mind",
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(width: 10),
                    AlbumWidiget(
                      albumImage: "assets/images/album_2.jpg",
                      label1: "Relax Playlist",
                      label2: "Chill your mind",
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(width: 10),
                    AlbumWidiget(
                      albumImage: "assets/images/album_3.png",
                      label1: "Daily Mix 2",
                      label2: "Made for you",
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(width: 10),
                    AlbumWidiget(
                      albumImage: "assets/images/album_4.jpg",
                      label1: "Chill",
                      label2: "Chill your mind",
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(width: 10),
                    AlbumWidiget(
                      albumImage: "assets/images/album_5.jpg",
                      label1: "Happy",
                      label2: "Chill your mind",
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(width: 10),
                    AlbumWidiget(
                      albumImage: "assets/images/album_6.jpg",
                      label1: "Sad",
                      label2: "Chill your mind",
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Latest Songs",
                style: GoogleFonts.roboto(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4),
                  itemCount: songList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final song = songList[index];
                    final bool isCurrent = currentSongIndex == index;
                    final bool isCurrentlyPlaying =
                        isCurrent && widget.audioController.isPlaying;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => SongScreen(
                              title: song.title,
                              artist: song.artist,
                              songPath: song.songPath,
                              imagePath: song.imagePath,
                              isDarkMode: isDarkMode,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0D0D1A)
                              : const Color(0xFFF7F1FA),
                          borderRadius: BorderRadius.circular(14),
                          border: isCurrent
                              ? Border.all(
                                  color: const Color(0xFFDB2777).withAlpha(140),
                                  width: 1.4,
                                )
                              : Border.all(
                                  color: Colors.transparent,
                                  width: 1.4,
                                ),
                          boxShadow: isDarkMode
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF3B0B4F,
                                    ).withAlpha(64),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(30),
                                    blurRadius: 14,
                                    spreadRadius: -6,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              song.imagePath,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isCurrent
                                  ? const Color(0xFFDB2777)
                                  : (isDarkMode ? Colors.white : Colors.black),
                            ),
                          ),
                          subtitle: Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.white.withAlpha(97)
                                  : Colors.black.withAlpha(97),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () async {
                              if (isCurrentlyPlaying) {
                                await widget.audioController.pauseSong();

                                setState(() {});
                              } else {
                                await widget.audioController.playSong(
                                  song.songPath,
                                );
                                setState(() {
                                  currentSongIndex = index;
                                });
                              }
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent
                                    ? const Color(0xFFDB2777).withAlpha(38)
                                    : Colors.transparent,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                child: isCurrentlyPlaying
                                    ? const EqualizerAnimation(
                                        key: ValueKey('eq'),
                                        color: Color(0xFFDB2777),
                                        height: 18,
                                        barWidth: 3,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        key: const ValueKey('play'),
                                        color: isCurrent
                                            ? const Color(0xFFDB2777)
                                            : (isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                      ),
                              ),
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
    );
  }
}
