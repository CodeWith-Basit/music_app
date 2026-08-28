import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDarkMode;
  final String audioQuality;
  final bool enableCrossfade;
  final bool enableDataSaver;
  final bool enableSpatialAudio;

  const SettingsState({
    this.isDarkMode = true,
    this.audioQuality = 'Lossless 320kbps',
    this.enableCrossfade = true,
    this.enableDataSaver = false,
    this.enableSpatialAudio = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? audioQuality,
    bool? enableCrossfade,
    bool? enableDataSaver,
    bool? enableSpatialAudio,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      audioQuality: audioQuality ?? this.audioQuality,
      enableCrossfade: enableCrossfade ?? this.enableCrossfade,
      enableDataSaver: enableDataSaver ?? this.enableDataSaver,
      enableSpatialAudio: enableSpatialAudio ?? this.enableSpatialAudio,
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState()) {
    _loadSettings();
  }

  static const _themeKey = 'auralis_dark_mode';
  static const _qualityKey = 'auralis_quality';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    final quality = prefs.getString(_qualityKey) ?? 'Lossless 320kbps';
    state = state.copyWith(isDarkMode: isDark, audioQuality: quality);
  }

  Future<void> toggleTheme() async {
    final newMode = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newMode);
  }

  Future<void> setAudioQuality(String quality) async {
    state = state.copyWith(audioQuality: quality);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_qualityKey, quality);
  }

  void toggleCrossfade(bool val) => state = state.copyWith(enableCrossfade: val);
  void toggleDataSaver(bool val) => state = state.copyWith(enableDataSaver: val);
  void toggleSpatialAudio(bool val) => state = state.copyWith(enableSpatialAudio: val);
}
