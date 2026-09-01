import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final int songsPlayed;
  final int favoriteArtistsCount;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl = 'assets/images/person.jpg',
    this.songsPlayed = 142,
    this.favoriteArtistsCount = 8,
  });
}

enum AuthStatus { unauthenticated, authenticated, loading }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  final bool hasSeenOnboarding;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.user,
    this.errorMessage,
    this.hasSeenOnboarding = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool? hasSeenOnboarding,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState()) {
    _checkSavedSession();
  }

  static const _userKey = 'auralis_logged_in';
  static const _userNameKey = 'auralis_user_name';
  static const _userEmailKey = 'auralis_user_email';
  static const _onboardingSeenKey = 'auralis_onboarding_seen';

  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_userKey) ?? false;
    final hasSeenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;

    if (isLoggedIn) {
      final name = prefs.getString(_userNameKey) ?? 'Basit';
      final email = prefs.getString(_userEmailKey) ?? 'basit@auralis.app';
      state = AuthState(
        status: AuthStatus.authenticated,
        hasSeenOnboarding: true,
        user: UserModel(uid: 'user_local_1', email: email, displayName: name),
      );
    } else {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        hasSeenOnboarding: hasSeenOnboarding,
      );
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
    state = state.copyWith(hasSeenOnboarding: true);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 900));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Please enter both email and password',
      );
      return false;
    }

    final name = email.split('@').first;
    final capitalized = name.isNotEmpty
        ? '${name[0].toUpperCase()}${name.substring(1)}'
        : 'Basit';

    final user = UserModel(
      uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: capitalized,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userKey, true);
    await prefs.setBool(_onboardingSeenKey, true);
    await prefs.setString(_userNameKey, user.displayName);
    await prefs.setString(_userEmailKey, user.email);

    state = AuthState(
      status: AuthStatus.authenticated,
      hasSeenOnboarding: true,
      user: user,
    );
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 900));

    if (name.trim().isEmpty || email.trim().isEmpty || password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Password must be at least 6 characters.',
      );
      return false;
    }

    final user = UserModel(
      uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userKey, true);
    await prefs.setBool(_onboardingSeenKey, true);
    await prefs.setString(_userNameKey, user.displayName);
    await prefs.setString(_userEmailKey, user.email);

    state = AuthState(
      status: AuthStatus.authenticated,
      hasSeenOnboarding: true,
      user: user,
    );
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      hasSeenOnboarding: true,
    );
  }
}
