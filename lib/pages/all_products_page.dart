import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/products_data.dart';
import '../main.dart'; // Import ProductCard from main.dart
import '../widgets/mobile_drawer.dart';
import '../widgets/product_card.dart'; // NEW - Import from widgets

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  // Sorting options
  String _sortBy = 'name_asc';

  // Filtering options
  String _filterCategory = 'all';
  String _filterPriceRange = 'all';
  bool _showDiscountOnly = false;

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  List<Product> get _filteredProducts {
    List<Product> products = List.from(ProductsData.allProducts);

    // Apply category filter
    if (_filterCategory != 'all') {
      switch (_filterCategory) {
        case 'clothes':
          products = products.where((p) => p.hasSize).toList();
          break;
        case 'merchandise':
          products =
              products.where((p) => !p.hasSize && !p.hasDiscount).toList();
          break;
        case 'sale':
          products = products.where((p) => p.hasDiscount).toList();
          break;
      }
    }

    // Apply price range filter
    if (_filterPriceRange != 'all') {
      products = products.where((p) {
        final price = double.parse(p.price.replaceAll('£', ''));
        switch (_filterPriceRange) {
          case 'under10':
            return price < 10;
          case '10to20':
            return price >= 10 && price < 20;
          case '20to30':
            return price >= 20 && price < 30;
          case 'over30':
            return price >= 30;
          default:
            return true;
        }
      }).toList();
    }

    // Apply discount filter
    if (_showDiscountOnly) {
      products = products.where((p) => p.hasDiscount).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name_asc':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'name_desc':
        products.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'price_asc':
        products.sort((a, b) {
          final priceA = double.parse(a.price.replaceAll('£', ''));
          final priceB = double.parse(b.price.replaceAll('£', ''));
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_desc':
        products.sort((a, b) {
          final priceA = double.parse(a.price.replaceAll('£', ''));
          final priceB = double.parse(b.price.replaceAll('£', ''));
          return priceB.compareTo(priceA);
        });
        break;
    }

    return products;
  }

  List<Product> get _paginatedProducts {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = start + _itemsPerPage;
    return _filteredProducts.sublist(
      start,
      end > _filteredProducts.length ? _filteredProducts.length : end,
    );
  }

  int get _totalPages => (_filteredProducts.length / _itemsPerPage).ceil();

  void _resetFilters() {
    setState(() {
      _sortBy = 'name_asc';
      _filterCategory = 'all';
      _filterPriceRange = 'all';
      _showDiscountOnly = false;
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),

            // Page Title
            Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 24.0 : 40.0,
                bottom: isMobile ? 16.0 : 24.0,
              ),
              child: Column(
                children: [
                  Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_filteredProducts.length} ${_filteredProducts.length == 1 ? 'product' : 'products'}',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Filters and Sorting Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
              ),
              child: isMobile
                  ? _buildMobileFilters()
                  : _buildDesktopFilters(isTablet),
            ),

            const SizedBox(height: 24),

            // Products Grid
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
              ),
              child: _paginatedProducts.isEmpty
                  ? _buildEmptyState()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 900) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.75,
                          children: _paginatedProducts.map((product) {
                            return ProductCard(product: product);
                          }).toList(),
                        );
                      },
                    ),
            ),

            // Pagination
            if (_totalPages > 1) ...[
              const SizedBox(height: 32),
              _buildPagination(isMobile),
            ],

            const SizedBox(height: 48),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopFilters(bool isTablet) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSortDropdown(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCategoryFilter(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPriceRangeFilter(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _showDiscountOnly,
                      onChanged: (value) {
                        setState(() {
                          _showDiscountOnly = value ?? false;
                          _currentPage = 1;
                        });
                      },
                      activeColor: const Color(0xFF4d2963),
                    ),
                    const Text('Show Sale Items Only'),
                  ],
                ),
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Filters'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF4d2963),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSortDropdown(),
            const SizedBox(height: 12),
            _buildCategoryFilter(),
            const SizedBox(height: 12),
            _buildPriceRangeFilter(),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _showDiscountOnly,
                  onChanged: (value) {
                    setState(() {
                      _showDiscountOnly = value ?? false;
                      _currentPage = 1;
                    });
                  },
                  activeColor: const Color(0xFF4d2963),
                ),
                const Expanded(child: Text('Show Sale Items Only')),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4d2963),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonFormField<String>(
      value: _sortBy,
      decoration: const InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'name_asc', child: Text('Name (A-Z)')),
        DropdownMenuItem(value: 'name_desc', child: Text('Name (Z-A)')),
        DropdownMenuItem(
            value: 'price_asc', child: Text('Price (Low to High)')),
        DropdownMenuItem(
            value: 'price_desc', child: Text('Price (High to Low)')),
      ],
      onChanged: (value) {
        setState(() {
          _sortBy = value ?? 'name_asc';
          _currentPage = 1;
        });
      },
    );
  }

  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      value: _filterCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Categories')),
        DropdownMenuItem(value: 'clothes', child: Text('Clothes')),
        DropdownMenuItem(value: 'merchandise', child: Text('Merchandise')),
        DropdownMenuItem(value: 'sale', child: Text('Sale Items')),
      ],
      onChanged: (value) {
        setState(() {
          _filterCategory = value ?? 'all';
          _currentPage = 1;
        });
      },
    );
  }

  Widget _buildPriceRangeFilter() {
    return DropdownButtonFormField<String>(
      value: _filterPriceRange,
      decoration: const InputDecoration(
        labelText: 'Price Range',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Prices')),
        DropdownMenuItem(value: 'under10', child: Text('Under £10')),
        DropdownMenuItem(value: '10to20', child: Text('£10 - £20')),
        DropdownMenuItem(value: '20to30', child: Text('£20 - £30')),
        DropdownMenuItem(value: 'over30', child: Text('Over £30')),
      ],
      onChanged: (value) {
        setState(() {
          _filterPriceRange = value ?? 'all';
          _currentPage = 1;
        });
      },
    );
  }

  Widget _buildPagination(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        ...List.generate(_totalPages, (index) {
          final pageNum = index + 1;
          if (_totalPages <= 5 ||
              pageNum == 1 ||
              pageNum == _totalPages ||
              (pageNum >= _currentPage - 1 && pageNum <= _currentPage + 1)) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _currentPage = pageNum;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: _currentPage == pageNum
                      ? const Color(0xFF4d2963)
                      : Colors.grey[200],
                  foregroundColor:
                      _currentPage == pageNum ? Colors.white : Colors.black,
                  minimumSize: Size(isMobile ? 36 : 40, isMobile ? 36 : 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('$pageNum'),
              ),
            );
          } else if (pageNum == _currentPage - 2 ||
              pageNum == _currentPage + 2) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            );
          }
          return const SizedBox.shrink();
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < _totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}
