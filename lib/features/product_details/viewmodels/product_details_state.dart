import '../models/product_details.dart';

enum ProductDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

class ProductDetailsState {
  final ProductDetailsStatus status;
  final ProductDetails? product;
  final String? errorMessage;

  /// Index (in `product.images`) of the image shown as the main picture.
  final int selectedImageIndex;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.errorMessage,
    this.selectedImageIndex = 0,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    ProductDetails? product,
    String? errorMessage,
    int? selectedImageIndex,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}
