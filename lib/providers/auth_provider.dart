import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/models/user.dart';
import 'package:green_cart/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final currentUserProvider = FutureProvider<User?>((ref) {
  return ref.watch(authServiceProvider).getCurrentUser();
});

// Login State Notifier
class LoginNotifier extends StateNotifier<AsyncValue<User>> {
  final AuthService _authService;

  LoginNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.login(email: email, password: password),
    );
  }

  void reset() => state = const AsyncValue.data(null);
}

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, AsyncValue<User>>(
  (ref) => LoginNotifier(ref.watch(authServiceProvider)),
);

// Signup State Notifier
class SignupNotifier extends StateNotifier<AsyncValue<User>> {
  final AuthService _authService;

  SignupNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.signup(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  void reset() => state = const AsyncValue.data(null);
}

final signupProvider = StateNotifierProvider.autoDispose<SignupNotifier, AsyncValue<User>>(
  (ref) => SignupNotifier(ref.watch(authServiceProvider)),
);

// Forgot Password State Notifier
class ForgotPasswordNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  ForgotPasswordNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> sendResetEmail({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.forgotPassword(email: email),
    );
  }

  void reset() => state = const AsyncValue.data(null);
}

final forgotPasswordProvider =
    StateNotifierProvider.autoDispose<ForgotPasswordNotifier, AsyncValue<void>>(
  (ref) => ForgotPasswordNotifier(ref.watch(authServiceProvider)),
);

// Logout
final logoutProvider = FutureProvider.autoDispose<void>((ref) async {
  return ref.watch(authServiceProvider).logout();
});