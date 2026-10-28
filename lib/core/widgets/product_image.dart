import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool tintWhite;

  /// نفس لون خلفية صور المنتجات في الديزاين
  static const Color tint = Color(0xFFE9DDD3);

  const ProductImage(
    this.path, {
    super.key,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.tintWhite = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget errorBuilder(BuildContext _, Object _, StackTrace? _) =>
        const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFFB9A79D)),
        );

    // Local products use asset paths; API products use http(s) URLs.
    final isNetwork = path.startsWith('http');

    return Container(
      width: width,
      height: height,
      color: tint,
      child: isNetwork
          ? Image.network(
              path,
              fit: fit,
              width: width,
              height: height,
              color: tintWhite ? tint : null,
              colorBlendMode: tintWhite ? BlendMode.multiply : null,
              errorBuilder: errorBuilder,
            )
          : Image.asset(
              path,
              fit: fit,
              width: width,
              height: height,
              color: tintWhite ? tint : null,
              colorBlendMode: tintWhite ? BlendMode.multiply : null,
              errorBuilder: errorBuilder,
            ),
    );
  }
}
