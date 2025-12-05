import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'pages/product_page.dart';
import 'pages/about.dart';
import 'pages/login_signup.dart';
import 'pages/cart_page.dart';
import 'pages/collections.dart';
import 'pages/collection_detail.dart';
import 'pages/all_products_page.dart';
import 'dart:async';
import 'widgets/header_widget.dart';
import 'widgets/footer_widget.dart';
import 'data/products_data.dart';

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Union Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
        ),
        routes: {
          '/': (context) => const HomePage(),
          '/product': (context) => const ProductPage(),
          '/about': (context) => const AboutPage(),
          '/auth': (context) => const AuthPage(),
          '/cart': (context) => const CartPage(),
          '/collections': (context) => const CollectionsPage(),
          '/collection-detail': (context) => const CollectionDetailPage(),
          '/all-products': (context) => const AllProductsPage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _heroSlides = [
    {
      'title': 'Welcome to The Union Shop',
      'subtitle': 'Official University of Portsmouth Merchandise',
      'description':
          'Discover exclusive apparel, accessories, and essentials for student life',
      'image': 'assets/images/white_hoodie1.jpg',
    },
    {
      'title': 'Freshers Sale - 25% OFF',
      'subtitle': 'Limited Time Offer',
      'description':
          'Get amazing discounts on selected items. Perfect for starting your university journey!',
      'image': 'assets/images/beerpong.jpg',
    },
    {
      'title': 'Quality Merchandise',
      'subtitle': 'Show Your University Pride',
      'description':
          'From hoodies to accessories, find everything you need to represent UoP',
      'image': 'assets/images/backpack.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _heroSlides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(),

            // Hero Section with Auto-Rotating Carousel
            SizedBox(
              height: isMobile ? 400 : 500,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _heroSlides.length,
                    itemBuilder: (context, index) {
                      return _buildHeroSlide(_heroSlides[index], isMobile);
                    },
                  ),
                  // Page Indicators
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _heroSlides.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Featured Products Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/all-products');
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: Color(0xFF4d2963),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      double childAspectRatio = 0.75;

                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                        childAspectRatio = 0.75;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.75;
                      }

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: childAspectRatio,
                        children:
                            ProductsData.allProducts.take(4).map((product) {
                          return ProductCard(
                            id: product.id,
                            title: product.title,
                            price: product.price,
                            imageUrl: product.defaultImageUrl,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide(Map<String, String> slide, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(slide['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24.0 : 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slide['subtitle']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slide['title']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 32 : 56,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: isMobile ? double.infinity : 500,
                    child: Text(
                      slide['description']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 14 : 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/all-products');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 32,
                        vertical: isMobile ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Browse Products',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final product = ProductsData.getProductById(id);
    final hasDiscount = product?.hasDiscount ?? false;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: {
              'id': id,
              'title': title,
              'price': price,
              'imageUrl': imageUrl,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: Image.asset(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Discount Badge
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product!.discountPercentage!.toInt()}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (hasDiscount) ...[
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product!.discountedPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4d2963),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroCarousel extends StatefulWidget {
  final double height;
  final List<String> imageUrls;
  final VoidCallback onBrowse;

  const HeroCarousel({
    super.key,
    required this.height,
    required this.imageUrls,
    required this.onBrowse,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _current = 0;
  bool _isPaused = false;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _isPaused) return;
      final next = (_current + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _togglePaused() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _stopTimer();
      } else {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // PageView for images
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              physics: const PageScrollPhysics(),
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _current = index);
                if (!_isPaused) {
                  _stopTimer();
                  _startTimer();
                }
              },
              itemBuilder: (context, index) {
                final url = widget.imageUrls[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    url.startsWith('http')
                        ? Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            url,
                            fit: BoxFit.cover,
                          ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Content overlay
          Positioned(
            left: 16,
            right: 16,
            top: isMobile ? 40 : 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Placeholder Hero Title',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 8 : 16),
                Text(
                  "This is placeholder text for the hero section.",
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 20,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 16 : 32),
                ElevatedButton(
                  onPressed: widget.onBrowse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4d2963),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 24,
                      vertical: isMobile ? 10 : 12,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'BROWSE PRODUCTS',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar: dots centered, pause/play on right
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: 4,
                      children: List.generate(widget.imageUrls.length, (i) {
                        final selected = i == _current;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: selected ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.black45,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: isMobile ? 16 : 18,
                    ),
                    onPressed: _togglePaused,
                    tooltip: _isPaused ? 'Resume' : 'Pause',
                    padding: EdgeInsets.all(isMobile ? 6 : 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
