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

 