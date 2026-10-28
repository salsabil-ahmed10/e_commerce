import 'package:flutter/material.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/main/views/main_shell.dart';
import '../../features/offers/views/offers_screen.dart';
import '../../features/product_details/views/product_details_screen.dart';
import '../models/product.dart';
import 'app_routes.dart';

/// The single place where route names are mapped to screens.
///
/// All Cubits are provided above `MaterialApp` (see main.dart), so every
/// route built here can read them.
class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(settings, const LoginScreen());

      case AppRoutes.main:
        return _page(settings, const MainShell());

      case AppRoutes.favorites:
        return _page(settings, const FavoritesScreen());

      case AppRoutes.offers:
        return _page(settings, const OffersScreen());

      case AppRoutes.productDetails:
        final args = settings.arguments;
        if (args is Product) {
          return _page(settings, ProductDetailsScreen(product: args));
        }
    }

    // Unknown name, or missing/wrong arguments.
    return _page(settings, const _RouteErrorScreen());
  }

  static MaterialPageRoute<dynamic> _page(RouteSettings settings, Widget page) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => page,
    );
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Page not found')),
    );
  }
}
