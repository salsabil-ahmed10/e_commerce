/// Route names for the whole app. Use them with `Navigator.pushNamed`.
///
/// Home and Cart are not listed here: they are tabs inside the main shell
/// (see `MainShell`), not separate pages.
abstract final class AppRoutes {
  static const login = '/';
  static const main = '/main';
  static const favorites = '/favorites';
  static const offers = '/offers';

  /// Needs a `Product` as `arguments`.
  static const productDetails = '/product-details';
}
