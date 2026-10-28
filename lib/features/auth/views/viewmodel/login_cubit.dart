
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_profile.dart';
import '../data/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit(this.authRepository) : super(const LoginState());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(
      const LoginState(status: LoginStatus.loading),
    );

    try {
      final data = await authRepository.login(
        username: username,
        password: password,
      );

      emit(
        LoginState(
          status: LoginStatus.success,
          user: UserProfile.tryFromJson(data),
        ),
      );
    } catch (e) {
      emit(
        LoginState(
          status: LoginStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Forgets the logged-in user. The app then behaves as a guest session.
  void logout() => emit(const LoginState());
}
