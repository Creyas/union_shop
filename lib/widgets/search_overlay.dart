import 'package:flutter/material.dart';
import '../data/products_data.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  List<Map<String, dynamic>> _pageResults = [];
  bool _isSearching = false;

  // Define searchable pages
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Home',
      'description': 'Return to homepage',
      'route': '/',
      'icon': Icons.home,
      'keywords': ['home', 'main', 'start'],
    },
    {
      'title': 'All Products',
      'description': 'Browse all available products with filters',
      'route': '/all-products',
      'icon': Icons.shopping_bag,
      'keywords': ['all', 'products', 'shop', 'browse', 'filter', 'sort'],
    },
    {
      'title': 'Print Shack',
      'description': 'Customize your own hoodie with personalization',
      'route': '/print-shack',
      'icon': Icons.print,
      'keywords': ['print', 'custom', 'personalize', 'hoodie', 'customize', 'text', 'name'],
    },
    {
      'title': 'Collections',
      'description': 'Browse product collections',
      'route': '/collections',
      'icon': Icons.collections,
      'keywords': ['collections', 'categories', 'browse'],
    },
    {
      'title': 'Clothes',
      'description': 'T-Shirts and Hoodies',
      'route': '/collection-detail',
      'arguments': {'category': 'clothes', 'title': 'Clothes'},
      'icon': Icons.checkroom,
      'keywords': ['clothes', 'clothing', 'apparel', 'shirts', 'hoodies', 'wear'],
    },
    {
      'title': 'Merchandise',
      'description': 'Accessories and more',
      'route': '/collection-detail',
      'arguments': {'category': 'merchandise', 'title': 'Merchandise'},
      'icon': Icons.shopping_basket,
      'keywords': ['merchandise', 'accessories', 'items', 'stuff', 'gear'],
    },
    {
      'title': 'Freshers Sale',
      'description': 'Special offers - 25% OFF selected items',
      'route': '/collection-detail',
      'arguments': {'category': 'freshers', 'title': 'Freshers Sale'},
      'icon': Icons.local_offer,
      'keywords': ['sale', 'freshers', 'discount', 'offer', 'deals', 'cheap', 'savings'],
    },
    {
      'title': 'About',
      'description': 'Learn more about The Union Shop',
      'route': '/about',
      'icon': Icons.info,
      'keywords': ['about', 'information', 'contact', 'us'],
    },
    {
      'title': 'Cart',
      'description': 'View your shopping cart',
      'route': '/cart',
      'icon': Icons.shopping_cart,
      'keywords': ['cart', 'basket', 'checkout', 'bag', 'purchase'],
    },
    {
      'title': 'Account',
      'description': 'Login or Sign up',
      'route': '/auth',
      'icon': Icons.person,
      'keywords': ['account', 'login', 'signup', 'register', 'profile', 'user'],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _pageResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final lowerQuery = query.toLowerCase();

    // Search products
    _searchResults = ProductsData.allProducts.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.id.toLowerCase().contains(lowerQuery);
    }).toList();

    // Search pages
    _pageResults = _pages.where((page) {
      return page['title'].toString().toLowerCase().contains(lowerQuery) ||
          page['description'].toString().toLowerCase().contains(lowerQuery) ||
          (page['keywords'] as List<String>).any(
            (keyword) => keyword.contains(lowerQuery),
          );
    }).toList();

    setState(() {
      _isSearching = false;
    });
  }

  void _navigateToPage(Map<String, dynamic> page) {
    Navigator.pop(context); // Close search overlay
    if (page['arguments'] != null) {
      Navigator.pushNamed(
        context,
        page['route'],
        arguments: page['arguments'],
      );
    } else {
      Navigator.pushNamed(context, page['route']);
    }
  }

  void _navigateToProduct(Product product) {
    Navigator.pop(context); // Close search overlay
    if (product.id == 'print-shack') {
      Navigator.pushNamed(context, '/print-shack');
    } else {
      Navigator.pushNamed(
        context,
        '/product',
        arguments: {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.defaultImageUrl,
        },
      );
    }
  }

  