class Product {
  final String id;
  final String title;
  final String price;
  final String defaultImageUrl;
  final Map<String, String> colorImages;
  final bool hasSize;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.defaultImageUrl,
    required this.colorImages,
    this.hasSize = true,
    required this.description,
  });
}

class ProductsData {
  static final List<Product> allProducts = [
    Product(
      id: 'white-shirt',
      title: 'Essential T-Shirt',
      price: '£6.99',
      defaultImageUrl: 'assets/images/white_shirt1.jpg',
      colorImages: {
        'White': 'assets/images/white_shirt1.jpg',
        'Black': 'assets/images/black_shirt1.jpg',
      },
      hasSize: true,
      description:
          'High-quality comfortable t-shirt perfect for everyday wear. Made from premium materials with attention to detail.',
    ),
    Product(
      id: 'white-hoodie',
      title: 'Classic Hoodie',
      price: '£25.00',
      defaultImageUrl: 'assets/images/white_hoodie1.jpg',
      colorImages: {
        'White': 'assets/images/white_hoodie1.jpg',
        'Black': 'assets/images/black_hoodie1.jpg',
      },
      hasSize: true,
      description:
          'Comfortable and warm hoodie perfect for casual wear. Features a cozy hood and front pocket.',
    ),
    Product(
      id: 'flask',
      title: 'University Flask',
      price: '£12.99',
      defaultImageUrl: 'assets/images/white_flask.jpg',
      colorImages: {
        'White': 'assets/images/white_flask.jpg',
        'Black': 'assets/images/black_flask.jpg',
      },
      hasSize: false,
      description:
          'Insulated stainless steel flask keeping your drinks hot or cold for hours. Perfect for campus life with University of Portsmouth branding.',
    ),
    Product(
      id: 'lanyard',
      title: 'University Lanyard',
      price: '£3.99',
      defaultImageUrl: 'assets/images/white_lanyard.jpg',
      colorImages: {
        'White': 'assets/images/white_lanyard.jpg',
        'Black': 'assets/images/black_lanyard.jpg',
      },
      hasSize: false,
      description:
          'High-quality University of Portsmouth lanyard. Perfect for holding your student ID card and keys. Durable and stylish.',
    ),
  ];

  static Product? getProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
