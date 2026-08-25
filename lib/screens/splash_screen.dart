import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/controllers/audio_controller.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final AudioController audioController;
  const SplashScreen({super.key, required this.audioController});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  late AnimationController _fadeController;
  late AnimationController _titleSlideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();

    // Lottie controller — plays for 2.5 seconds
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Title slide-up + fade controller
    _titleSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _titleSlideController,
            curve: Curves.easeOutCubic,
          ),
        );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleSlideController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleSlideController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    // Exit fade controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 1. Start Lottie animation
    _lottieController.forward();

    // 2. After a short delay, slide in the title
    await Future.delayed(const Duration(milliseconds: 600));
    _titleSlideController.forward();

    // 3. Wait for the Lottie animation to finish + a small buffer
    await Future.delayed(const Duration(milliseconds: 2400));

    // 4. Fade out everything
    await _fadeController.forward();

    // 5. Navigate to HomeScreen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              HomeScreen(audioController: widget.audioController),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _fadeController.dispose();
    _titleSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie splash animation
              SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset(
                  'assets/splash.json',
                  controller: _lottieController,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // App name with slide-up animation
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFBB86FC), Color(0xFF03DAC6)],
                    ).createShader(bounds),
                    child: Text(
                      'Vibes',
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              FadeTransition(
                opacity: _subtitleFade,
                child: Text(
                  'Feel the music',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white38,
                    letterSpacing: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
