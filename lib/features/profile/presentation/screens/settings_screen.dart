import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/constants/app_colors.dart';
import 'package:music_app/core/constants/app_typography.dart';
import 'package:music_app/core/utils/glassmorphism.dart';
import 'package:music_app/features/profile/presentation/controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final settingsNotifier = ref.read(settingsControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Settings & Audio',
          style: AppTypography.screenTitle(
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section: Appearance
          Text(
            'APPEARANCE',
            style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      settingsState.isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: AppColors.electricViolet,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Dark Atmosphere',
                      style: AppTypography.songTitle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 15),
                    ),
                  ],
                ),
                Switch(
                  activeThumbColor: AppColors.neonCyan,
                  value: settingsState.isDarkMode,
                  onChanged: (_) => settingsNotifier.toggleTheme(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: Audio Quality & Engine
          Text(
            'AUDIO ENGINE & QUALITY',
            style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Streaming Fidelity',
                      style: AppTypography.songTitle(
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ).copyWith(fontSize: 15),
                    ),
                    DropdownButton<String>(
                      value: settingsState.audioQuality,
                      dropdownColor: AppColors.darkSurfaceElevated,
                      style: const TextStyle(color: AppColors.neonCyan, fontWeight: FontWeight.bold),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'Lossless 320kbps',
                          child: Text('Lossless 320kbps'),
                        ),
                        DropdownMenuItem(
                          value: 'Hi-Res FLAC 24-Bit',
                          child: Text('Hi-Res FLAC 24-Bit'),
                        ),
                        DropdownMenuItem(
                          value: 'Standard 192kbps',
                          child: Text('Standard 192kbps'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) settingsNotifier.setAudioQuality(val);
                      },
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderSubtle, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spatial Audio Simulation',
                          style: AppTypography.songTitle(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ).copyWith(fontSize: 15),
                        ),
                        Text(
                          'Simulates 3D soundstage immersion',
                          style: AppTypography.metadata(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    Switch(
                      activeThumbColor: AppColors.neonCyan,
                      value: settingsState.enableSpatialAudio,
                      onChanged: (v) => settingsNotifier.toggleSpatialAudio(v),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderSubtle, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gapless Crossfade',
                          style: AppTypography.songTitle(
                            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          ).copyWith(fontSize: 15),
                        ),
                        Text(
                          'Smooth transitions between tracks',
                          style: AppTypography.metadata(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    Switch(
                      activeThumbColor: AppColors.neonCyan,
                      value: settingsState.enableCrossfade,
                      onChanged: (v) => settingsNotifier.toggleCrossfade(v),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: About & Info
          Text(
            'ABOUT AURALIS',
            style: AppTypography.metadata(color: AppColors.softCyan).copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version', style: AppTypography.bodyText(color: isDark ? Colors.white : AppColors.lightTextPrimary)),
                    Text('1.0.0 (Build 2026.1)', style: AppTypography.metadata(color: AppColors.neonCyan)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Auralis • Feel Every Frequency',
                  style: AppTypography.metadata(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
