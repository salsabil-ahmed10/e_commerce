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
    return Container(
      width: width,
      height: height,
      color: tint,
      child: Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        color: tintWhite ? tint : null,
        colorBlendMode: tintWhite ? BlendMode.multiply : null,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFFB9A79D)),
        ),
      ),
    );
  }
}
