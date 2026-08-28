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

          // Floating Mini Player and Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniPlayer(),
                // Floating Bottom Bar Container
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: GlassContainer(
                    borderRadius: BorderRadius.circular(24),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    blur: 24,
                    opacity: isDark ? 0.3 : 0.8,
                    color: isDark ? const Color(0xFF131322) : Colors.white,
                    border: Border.all(
                      color: isDark ? AppColors.darkGlassBorder : AppColors.lightBorder,
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: (idx) => setState(() => _currentIndex = idx),
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
        ],
      ),
    );
  }
}
