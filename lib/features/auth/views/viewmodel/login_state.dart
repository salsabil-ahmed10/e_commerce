
import '../../models/user_profile.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  /// The logged-in user (set together with [LoginStatus.success]).
  final UserProfile? user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.user,
  });

  bool get isLoggedIn => status == LoginStatus.success && user != null;
}
