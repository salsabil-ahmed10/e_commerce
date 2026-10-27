
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/views/data/auth_repository.dart';
import 'features/auth/views/viewmodel/login_cubit.dart';
import 'features/cart/viewmodels/cart_cubit.dart';
import 'features/auth/views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (_) => CartCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(AuthRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
