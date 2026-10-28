import '../../../core/models/product.dart';

/// Prefix of app-level ids for API products ('api_1'), so they can never
/// collide with the local products' ids ('1'..'6').
const String apiProductIdPrefix = 'api_';

/// Everything the Product Details screen displays.
///
/// Built either from GET https://dummyjson.com/products/{id}
/// ([ProductDetails.fromJson]) or from a local [Product]
/// ([ProductDetails.fromProduct]). Fields the local data does not have
/// (rating, stock, discount, brand) are null and simply not shown.
class ProductDetails {
  /// Same value as `Product.id` of the product this describes.
  final String productId;

  /// DummyJSON id; null for local products.
  final int? apiId;

  final String title;
  final String description;
  final double price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final String? category;
  final String? brand; // some DummyJSON products have no brand
  final String thumbnail;
  final List<String> images;

  const ProductDetails({
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    this.apiId,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.category,
    this.brand,
  });

  bool get isFromApi => apiId != null;

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final images = (json['images'] as List?)?.whereType<String>().toList() ??
        const <String>[];

    return ProductDetails(
      productId: '$apiProductIdPrefix$id',
      apiId: id,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      // JSON may send 5 instead of 5.0, so go through num first.
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      thumbnail:
          (json['thumbnail'] as String?) ?? (images.isNotEmpty ? images.first : ''),
      images: images,
    );
  }

  /// Local product: shows exactly the data and asset Home already shows.
  factory ProductDetails.fromProduct(Product product) {
    return ProductDetails(
      productId: product.id,
      title: product.name,
      description: product.description ?? '',
      price: product.price,
      category: product.category,
      thumbnail: product.image,
      images: const [],
    );
  }

  /// Images for the gallery. The thumbnail comes first, which is the image
  /// Home and Favorites show, so the first image on the details screen is
  /// always the one the user tapped. Duplicates and empty urls are dropped.
  List<String> get gallery {
    final seen = <String>{};
    return [thumbnail, ...images].where((u) => u.isNotEmpty && seen.add(u)).toList();
  }

  /// The core [Product] for cart/favorites. Uses the same id and thumbnail
  /// as the Product Home builds, so both describe the same item.
  Product toProduct() {
    return Product(
      id: productId,
      image: thumbnail,
      name: title,
      price: price,
      description: description.isEmpty ? null : description,
      category: category,
      apiProductId: apiId,
    );
  }
}
