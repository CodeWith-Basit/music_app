import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/app_background.dart';

class SongScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String songPath;
  final String imagePath;
  final bool isDarkMode;

  const SongScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.songPath,
    required this.imagePath,
    required this.isDarkMode,
  });

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  double currentPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        isDarkMode: widget.isDarkMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //appbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: widget.isDarkMode
                          ? Colors.white
                          : const Color(0xFF3B0B4F),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 30,
                      color: widget.isDarkMode
                          ? Colors.white
                          : const Color(0xFF3B0B4F),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        blurRadius: 15,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(widget.imagePath),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.artist,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: widget.isDarkMode ? Colors.white38 : Colors.black38,
                ),
              ),
              SizedBox(height: 30),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 0,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: 100,
                  value: currentPosition,
                  activeColor: widget.isDarkMode
                      ? Colors.white
                      : const Color(0xFF3B0B4F),
                  inactiveColor: widget.isDarkMode
                      ? Colors.white24
                      : Colors.black12,
                  onChanged: (value) {
                    setState(() {
                      currentPosition = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: widget.isDarkMode
                            ? Colors.white
                            : const Color(0xFF3B0B4F),
                      ),
                      child: Icon(
                        Icons.skip_previous,
                        color: widget.isDarkMode
                            ? Color(0xFF3B0B4F)
                            : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: widget.isDarkMode
                            ? Colors.white
                            : const Color(0xFF3B0B4F),
                      ),
                      child: Icon(
                        size: 30,
                        Icons.play_arrow,
                        color: widget.isDarkMode
                            ? Color(0xFF3B0B4F)
                            : Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: widget.isDarkMode
                            ? Colors.white
                            : const Color(0xFF3B0B4F),
                      ),
                      child: Icon(
                        Icons.skip_next,
                        color: widget.isDarkMode
                            ? Color(0xFF3B0B4F)
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
