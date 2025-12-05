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
    // T-Shirts
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

    // Hoodies
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

    // Flask
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

    // Lanyard
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

    // Backpack
    Product(
      id: 'backpack',
      title: 'University Backpack',
      price: '£29.99',
      defaultImageUrl: 'assets/images/backpack.jpg',
      colorImages: {
        'Black': 'assets/images/backpack.jpg',
      },
      hasSize: false,
      description:
          'Durable and spacious backpack perfect for carrying textbooks, laptops, and essentials. Features multiple compartments and padded straps.',
    ),

    // Beer Pong
    Product(
      id: 'beerpong',
      title: 'Beer Pong Set',
      price: '£15.99',
      defaultImageUrl: 'assets/images/beerpong.jpg',
      colorImages: {
        'Red': 'assets/images/beerpong.jpg',
      },
      hasSize: false,
      description:
          'Complete beer pong set including cups and balls. Perfect for student parties and social events.',
    ),

    // Calculator
    Product(
      id: 'calculator',
      title: 'Scientific Calculator',
      price: '£8.99',
      defaultImageUrl: 'assets/images/calculator.jpg',
      colorImages: {
        'Black': 'assets/images/calculator.jpg',
      },
      hasSize: false,
      description:
          'Essential scientific calculator for all your academic needs. Features multiple functions and a clear display.',
    ),

    // Dart Set
    Product(
      id: 'dartset',
      title: 'Dart Set',
      price: '£12.99',
      defaultImageUrl: 'assets/images/dart_set.jpg',
      colorImages: {
        'Multi': 'assets/images/dart_set.jpg',
      },
      hasSize: false,
      description:
          'Professional dart set perfect for recreation room fun. Includes multiple darts with different designs.',
    ),

    // Football
    Product(
      id: 'football',
      title: 'University Football',
      price: '£18.99',
      defaultImageUrl: 'assets/images/football.jpg',
      colorImages: {
        'White': 'assets/images/football.jpg',
      },
      hasSize: false,
      description:
          'Official University of Portsmouth football. Perfect for intramural sports and recreational play.',
    ),
  ];

  static Product? getProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get products by category
  static List<Product> getProductsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'clothing':
        return allProducts.where((p) => p.hasSize).toList();
      case 'accessories':
        return allProducts.where((p) => !p.hasSize).toList();
      case 'sports':
        return allProducts
            .where((p) => ['football', 'dartset', 'beerpong'].contains(p.id))
            .toList();
      default:
        return allProducts;
    }
  }
}
