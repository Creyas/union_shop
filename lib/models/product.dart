class Product {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double salePrice;
  final String imageUrl;
  final List<String> availableColors;
  final List<String> availableSizes;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.salePrice,
    required this.imageUrl,
    required this.availableColors,
    required this.availableSizes,
  });
}
