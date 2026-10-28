import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../cart/views/cart_screen.dart';
import '../../home/data/products.dart';
import '../../home/views/home_screen.dart';

/// Hosts the bottom-navigation tabs (Home, Cart).
///
/// The tabs live in an [IndexedStack], so switching tabs never rebuilds or
/// resets a screen (Home keeps its scroll position and loaded products), and
/// no screen is ever pushed twice. Pages such as Product Details, Favorites
/// and Offers are pushed on top of this shell with named routes.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _homeTab = 0;
  static const _cartTab = 1;
  static const _profileTab = 2;

  int _index = _homeTab;

  void _selectTab(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  void _onNavTap(int index) {
    // There is no Profile screen in the app yet; the tab does nothing,
    // exactly as before.
    if (index == _profileTab) return;
    _selectTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Back on another tab returns to Home first; back on Home leaves the app.
      canPop: _index == _homeTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _selectTab(_homeTab);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(
              products: products,
              onOpenCart: () => _selectTab(_cartTab),
            ),
            CartScreen(onContinueShopping: () => _selectTab(_homeTab)),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
