import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/favorites/viewmodels/favorites_cubit.dart';
import '../../features/favorites/viewmodels/favorites_state.dart';
import '../models/product.dart';

/// Heart icon that shows whether [product] is a favorite and toggles it.
///
/// It reads and writes the shared [FavoritesCubit], so every heart in the
/// app (Home, Details, Favorites) always shows the real status and updates
/// immediately when it changes anywhere else.
class FavoriteButton extends StatelessWidget {
  final Product product;

  /// true: white circle, for placing on top of a product image.
  /// false: plain icon, for app bars.
  final bool onImage;

  const FavoriteButton({
    super.key,
    required this.product,
    this.onImage = true,
  });

  static const _brown = Color(0xFF8B5E52);
  static const _dark = Color(0xFF5C453D);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavoritesCubit, FavoritesState, bool>(
      selector: (state) => state.isFavorite(product.id),
      builder: (context, isFavorite) {
        return IconButton(
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          onPressed: () => context.read<FavoritesCubit>().toggle(product),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: onImage
              ? const BoxConstraints.tightFor(width: 34, height: 34)
              : null,
          style: onImage
              ? IconButton.styleFrom(backgroundColor: Colors.white)
              : null,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: onImage ? 19 : 26,
            color: onImage ? _brown : _dark,
          ),
        );
      },
    );
  }
}
