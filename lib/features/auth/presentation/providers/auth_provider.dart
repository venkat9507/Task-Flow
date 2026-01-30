import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

/// Auth state
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Login _login;
  final Logout _logout;
  final CheckAuthStatus _checkAuthStatus;

  AuthNotifier({
    required Login login,
    required Logout logout,
    required CheckAuthStatus checkAuthStatus,
  }) : _login = login,
       _logout = logout,
       _checkAuthStatus = checkAuthStatus,
       super(const AuthState(isLoading: true)) {
    checkStatus();
  }

  /// Check authentication status
  Future<void> checkStatus() async {
    state = state.copyWith(isLoading: true);

    final result = await _checkAuthStatus(NoParams());

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = const AuthState().copyWith(user: user, isLoading: false),
    );
  }

  /// Login
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _login(LoginParams(email: email, password: password));

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _logout(NoParams());

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (success) => state = const AuthState(),
    );
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    login: getIt<Login>(),
    logout: getIt<Logout>(),
    checkAuthStatus: getIt<CheckAuthStatus>(),
  );
});
