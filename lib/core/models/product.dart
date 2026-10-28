/// App-wide product model used by Home, Cart, Favorites and Product Details.
///
/// A product is either:
///  * local  -> [apiProductId] is null, data and image asset live in the app;
///  * API    -> [apiProductId] is the DummyJSON id used to load its details.
///
/// The optional fields keep older call sites (`Product(id:, image:, name:,
/// price:)`) working unchanged.
class Product {
  final String id;
  final String image;
  final String name;
  final double price;
  final String? description;
  final String? category;

  /// DummyJSON id when this product's details come from the API.
  /// Null for local products, which must never be sent to the API.
  final int? apiProductId;

  Product({
    required this.id,
    required this.image,
    required this.price,
    required this.name,
    this.description,
    this.category,
    this.apiProductId,
  });

  bool get isApiProduct => apiProductId != null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'apiProductId': apiProductId,
      };

  /// Returns null instead of throwing when the data is malformed, so a
  /// corrupted saved entry can be skipped.
  static Product? tryFromJson(Object? json) {
    if (json is! Map) return null;

    final id = json['id'];
    final image = json['image'];
    final name = json['name'];
    final price = json['price'];

    if (id is! String || image is! String || name is! String || price is! num) {
      return null;
    }

    final description = json['description'];
    final category = json['category'];
    final apiId = json['apiProductId'];

    return Product(
      id: id,
      image: image,
      name: name,
      price: price.toDouble(),
      description: description is String ? description : null,
      category: category is String ? category : null,
      apiProductId: apiId is int ? apiId : null,
    );
  }
}
