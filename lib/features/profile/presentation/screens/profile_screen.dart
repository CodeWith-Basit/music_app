import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:music_app/features/auth/presentation/screens/login_screen.dart';
import 'package:music_app/features/profile/presentation/screens/settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Profile Card with Avatar & Stats
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.cyanVioletGradient,
                    ),
                    child: const CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage('assets/images/person.jpg'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Basit',
                    style: AppTypography.heroTitle(
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ).copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'basit@auralis.app',
                    style: AppTypography.metadata(
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.neonCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      'AURALIS PRO AUDIOPHILE',
                      style: AppTypography.metadata(color: AppColors.neonCyan).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Listening Statistics Dashboard
            Text(
              'LISTENING SPECTRUM',
              style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            GlassContainer(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('142', 'Played', AppColors.electricViolet, isDark),
                  _buildDivider(isDark),
                  _buildStatItem('34 hrs', 'Fidelity Time', AppColors.neonCyan, isDark),
                  _buildDivider(isDark),
                  _buildStatItem('8', 'Fav Artists', AppColors.cyberMagenta, isDark),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Links
            Text(
              'PREFERENCES & SYSTEM',
              style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: AppColors.softCyan),
                    title: Text(
                      'Settings & Audio Quality',
                      style: AppTypography.songTitle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 15),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                  const Divider(color: AppColors.borderSubtle, height: 1),
                  ListTile(
                    leading: const Icon(Icons.equalizer_rounded, color: AppColors.electricViolet),
                    title: Text(
                      'Parametric Equalizer',
                      style: AppTypography.songTitle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 15),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  const Divider(color: AppColors.borderSubtle, height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.warmPink),
                    title: Text(
                      'Sign Out',
                      style: AppTypography.songTitle(color: AppColors.warmPink)
                          .copyWith(fontSize: 15),
                    ),
                    onTap: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label, Color accent, bool isDark) {
    return Column(
      children: [
        Text(
          val,
          style: AppTypography.heroTitle(color: accent).copyWith(fontSize: 20),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.metadata(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? AppColors.borderSubtle : AppColors.lightBorder,
    );
  }
}
