
import 'package:flutter_bloc/flutter_bloc.dart';

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
      await authRepository.login(
        username: username,
        password: password,
      );

      emit(
        const LoginState(status: LoginStatus.success),
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
}
