import 'package:flutter/material.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/widgets/common_widgets.dart';
import 'package:music_app/features/auth/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      title: "Your Music.\nYour Atmosphere.",
      description:
          "Experience pure lossless audio fidelity, tailored sound stages, and deeply immersive audio textures.",
      imagePath: 'assets/images/Screen 1.png',
      badgeText: "SPATIAL ENGINE",
    ),
    OnboardingItem(
      title: "Discover Sounds\nMatching Your Mood.",
      description:
          "From late night synth drives to spiritual sufi frequencies, explore curated audio dimensions curated for you.",
      imagePath: 'assets/images/album_1.jpg',
      badgeText: "DYNAMIC CURATION",
    ),
    OnboardingItem(
      title: "Feel Every\nSingle Frequency.",
      description:
          "Synchronized interactive lyrics, ultra responsive equalizer waveforms, and uninterrupted continuous background playback.",
      imagePath: 'assets/images/album_5.jpg',
      badgeText: "AURALIS PRO",
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Top ambient glows
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyberMagenta.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar with Skip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.cyanVioletGradient,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AURALIS',
                            style: AppTypography.songTitle(color: Colors.white).copyWith(
                              letterSpacing: 2.5,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          'Skip',
                          style: AppTypography.metadata(color: AppColors.textSecondary)
                              .copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Card Artwork Container
                            Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.electricViolet.withValues(alpha: 0.35),
                                    blurRadius: 30,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        item.imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          color: AppColors.darkSurfaceElevated,
                                          child: const Icon(
                                            Icons.music_note_rounded,
                                            size: 80,
                                            color: AppColors.neonCyan,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Gradient tint overlay
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(alpha: 0.65),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Badge
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: AppColors.neonCyan.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Text(
                                          item.badgeText,
                                          style: AppTypography.metadata(
                                            color: AppColors.neonCyan,
                                          ).copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 36),

                            // Title
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: AppTypography.heroTitle(
                                color: AppColors.textPrimary,
                              ).copyWith(fontSize: 28, height: 1.25),
                            ),
                            const SizedBox(height: 14),

                            // Description
                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyText(
                                color: AppColors.textSecondary,
                              ).copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Controls & Page Indicators
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    children: [
                      // Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 28 : 8,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: _currentPage == index
                                  ? AppColors.primaryGradient
                                  : null,
                              color: _currentPage == index
                                  ? null
                                  : AppColors.borderSubtle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Next / Get Started Button
                      GlowingButton(
                        text: _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next Step',
                        width: double.infinity,
                        icon: _currentPage == _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : null,
                        onPressed: _onNext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final String badgeText;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.badgeText,
  });
}
