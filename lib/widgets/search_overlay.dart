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
      'keywords': [
        'print',
        'custom',
        'personalize',
        'hoodie',
        'customize',
        'text',
        'name'
      ],
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
      'keywords': [
        'clothes',
        'clothing',
        'apparel',
        'shirts',
        'hoodies',
        'wear'
      ],
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
      'keywords': [
        'sale',
        'freshers',
        'discount',
        'offer',
        'deals',
        'cheap',
        'savings'
      ],
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search products and pages...',
                        border: InputBorder.none,
                      ),
                      onChanged: _performSearch,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search Results
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchController.text.isEmpty
                      ? _buildEmptyState()
                      : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Start typing to search',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for products, collections, and pages',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final hasPageResults = _pageResults.isNotEmpty;
    final hasProductResults = _searchResults.isNotEmpty;

    if (!hasPageResults && !hasProductResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pages Section
        if (hasPageResults) ...[
          Row(
            children: [
              const Icon(Icons.pages, size: 20, color: Color(0xFF4d2963)),
              const SizedBox(width: 8),
              Text(
                'Pages (${_pageResults.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4d2963),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._pageResults.map((page) => _buildPageResultTile(page)),
          if (hasProductResults) const SizedBox(height: 24),
        ],

        // Products Section
        if (hasProductResults) ...[
          Row(
            children: [
              const Icon(Icons.inventory_2, size: 20, color: Color(0xFF4d2963)),
              const SizedBox(width: 8),
              Text(
                'Products (${_searchResults.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4d2963),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._searchResults.map((product) => _buildProductResultTile(product)),
        ],
      ],
    );
  }

  Widget _buildPageResultTile(Map<String, dynamic> page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4d2963).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            page['icon'] as IconData,
            color: const Color(0xFF4d2963),
            size: 24,
          ),
        ),
        title: Text(
          page['title'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          page['description'],
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToPage(page),
      ),
    );
  }

  Widget _buildProductResultTile(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            product.defaultImageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 30),
              );
            },
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (product.hasDiscount)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage!.toInt()}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          product.hasDiscount
              ? '${product.price} → ${product.discountedPrice}'
              : product.price,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: product.hasDiscount ? Colors.red : const Color(0xFF4d2963),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToProduct(product),
      ),
    );
  }
}
