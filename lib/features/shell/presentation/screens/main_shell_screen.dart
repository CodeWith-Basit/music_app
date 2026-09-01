import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/home/presentation/screens/home_screen.dart';
import 'package:music_app/features/search/presentation/screens/search_screen.dart';
import 'package:music_app/features/library/presentation/screens/library_screen.dart';
import 'package:music_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:music_app/features/player/presentation/widgets/mini_player.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Screen View Indexed Stack
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Mini Player and Compact Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  // Sleek Compact Floating Bottom Bar Container
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(20),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      blur: 28,
                      opacity: isDark ? 0.45 : 0.88,
                      color: isDark ? const Color(0xFF141428) : const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: isDark ? AppColors.darkGlassBorder : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      child: BottomNavigationBar(
                        currentIndex: _currentIndex,
                        onTap: (idx) => setState(() => _currentIndex = idx),
                        selectedItemColor: isDark ? AppColors.neonCyan : AppColors.electricViolet,
                        unselectedItemColor: isDark ? const Color(0xFF9E9EBA) : const Color(0xFF64748B),
                        iconSize: 22,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_filled),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.search_rounded),
                            label: 'Search',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.library_music_rounded),
                            label: 'Library',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person_rounded),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
