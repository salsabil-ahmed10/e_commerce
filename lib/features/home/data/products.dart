import '../../../core/models/product.dart';

/// DummyJSON product ids shown on Home next to the local products.
/// Each one is loaded from the API (see HomeCatalogCubit), so its image,
/// name and price always come from the same API response as its details.
const List<int> apiHomeProductIds = [];

/// Local rhode products. They use local assets and are NOT backed by the
/// API: their details screen is built from this data only.
///
/// NOTE: descriptions/categories are short placeholder copy derived from
/// the product names. Replace them with your real product text.
final List<Product> products = [
  Product(
    id: '2',
    image:
        'assets/images/rhode  Peptide Lip Shape Contouring Lip Shaper in Press - New in Box.jpeg',
    name: 'Peptide Lip Shape',
    price: 24,
    category: 'Makeup',
    description: 'A lip contouring product from the rhode collection.',
  ),
  Product(
    id: '3',
    image: 'assets/images/Pocket Blush.jpeg',
    name: 'Pocket Blush',
    price: 25,
    category: 'Makeup',
    description: 'A portable blush from the rhode collection.',
  ),
  Product(
    id: '4',
    image:
        "assets/images/How To Achieve The Viral 'Latte Makeup' Trend - Stolen Inspiration.jpeg",
    name: 'Peptide Glazing Fluid',
    price: 20,
    category: 'Skincare',
    description: 'A glazing fluid from the rhode skincare collection.',
  ),
  Product(
    id: '5',
    image: 'assets/images/تنزيل (2).jpeg',
    name: 'Lip Case',
    price: 38,
    category: 'Accessories',
    description: 'A lip case from the rhode collection.',
  ),
  Product(
    id: '1',
    image: 'assets/images/photo_2026-10-05_15-31-40.jpg',
    name: 'Glazing Milk',
    price: 32,
    category: 'Skincare',
    description: 'A glazing milk from the rhode skincare collection.',
  ),
  Product(
    id: '6',
    image: 'assets/images/تنزيل (4).jpeg',
    name: 'Peptide Eye Prep',
    price: 25,
    category: 'Skincare',
    description: 'An eye treatment from the rhode skincare collection.',
  ),
];
