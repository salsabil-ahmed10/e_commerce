import 'package:flutter/material.dart';
import '../viewmodels/cart_viewmodel.dart';

/// Home / Cart / Profile — بيتحدّث لوحده لما الكارت يتغير.
class AppBottomNav extends StatelessWidget {
  /// 0 = Home, 1 = Cart, 2 = Profile
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cartViewModel,
      builder: (context, _) {
        final count = cartViewModel.itemCount;
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: _bg,
          elevation: 0,
          selectedItemColor: _dark,
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                backgroundColor: _brown,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
