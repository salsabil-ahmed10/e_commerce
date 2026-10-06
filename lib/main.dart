import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'viewmodels/cart_cubit.dart';
import 'views/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}