import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/shared/widgets/auralis_icon.dart';
import 'package:music_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:music_app/features/auth/presentation/screens/login_screen.dart';
import 'package:music_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:music_app/features/shell/presentation/screens/main_shell_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.85).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
      ),
    );

    _animController.forward();

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _navigateNext();
          }
        });
      }
    });
  }

  void _navigateNext() {
    final authState = ref.read(authControllerProvider);
    Widget destination;

    if (authState.status == AuthStatus.authenticated) {
      // User is logged in -> jump straight to Main App
      destination = const MainShellScreen();
    } else if (authState.hasSeenOnboarding) {
      // User has seen onboarding before -> jump straight to Login
      destination = const LoginScreen();
    } else {
      // First time launch -> show Onboarding
      destination = const OnboardingScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background ambient gradient mesh - Top Left Glow
            Positioned(
              top: -120,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.electricViolet.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Background ambient gradient mesh - Bottom Right Glow
            Positioned(
              bottom: -100,
              right: -80,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.neonCyan.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Central Logo and Frequency Pulse - Guaranteed Screen Center
            Center(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Glowing Brand Glyph
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.electricViolet
                                          .withValues(
                                            alpha: _glowAnimation.value * 0.6,
                                          ),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                    BoxShadow(
                                      color: AppColors.neonCyan.withValues(
                                        alpha: _glowAnimation.value * 0.4,
                                      ),
                                      blurRadius: 50,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const AuralisLogo(size: 96),
                            ],
                          ),
                          const SizedBox(height: 28),
                          // Brand Name
                          Text(
                            'AURALIS',
                            textAlign: TextAlign.center,
                            style:
                                AppTypography.heroTitle(
                                  color: AppColors.textPrimary,
                                ).copyWith(
                                  fontSize: 34,
                                  letterSpacing: 6.0,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 8),
                          // Tagline
                          Text(
                            'FEEL EVERY FREQUENCY',
                            textAlign: TextAlign.center,
                            style:
                                AppTypography.metadata(
                                  color: AppColors.neonCyan,
                                ).copyWith(
                                  letterSpacing: 4.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 48),
                          // Frequency Wave Bars
                          _buildFrequencyWave(_animController.value),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyWave(double progress) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(9, (index) {
          final barPhase = (progress * 6 + index * 0.6) % 3.1415;
          final height =
              8.0 +
              (24.0 * (1 - (barPhase - 1.57).abs() / 1.57)).clamp(0.0, 24.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 3.5,
            height: height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.electricViolet, AppColors.neonCyan],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}
