
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/views/data/auth_repository.dart';
import 'features/auth/views/viewmodel/login_cubit.dart';
import 'features/cart/viewmodels/cart_cubit.dart';
import 'features/favorites/data/shared_prefs_favorites_storage.dart';
import 'features/favorites/viewmodels/favorites_cubit.dart';
import 'features/home/data/products.dart';

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
        // One shared favorites state for the whole app (Home, Details,
        // Favorites). Saved on the device; to disable persistence use
        // InMemoryFavoritesStorage() instead.
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(
            SharedPrefsFavoritesStorage(),
            localCatalog: products,
          )..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
