import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'pages/product_page.dart';
import 'pages/about.dart';
import 'pages/login_signup.dart';
import 'pages/cart_page.dart';
import 'pages/collections.dart';
import 'dart:async';
import 'widgets/header_widget.dart';
import 'widgets/footer_widget.dart';

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
          '/': (context) => const HomeScreen(),
          '/product': (context) => const ProductPage(),
          '/about': (context) => const AboutPage(),
          '/auth': (context) => const AuthPage(),
          '/cart': (context) => const CartPage(),
          '/collections': (context) => const CollectionsPage(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(),

            // Hero Section (replaced by carousel)
            HeroCarousel(
              height: MediaQuery.of(context).size.width < 600 ? 300 : 400,
              imageUrls: const [
                'assets/images/black_hoodie1.jpg',
                'assets/images/white_hoodie1.jpg',
                'assets/images/white_shirt1.jpg',
              ],
              onBrowse: placeholderCallbackForButtons,
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width < 600 ? 16.0 : 40.0,
                ),
                child: Column(
                  children: [
                    Text(
                      'SIGNATURE RANGE',
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 600 ? 16 : 20,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.width < 600 ? 24 : 48),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        double childAspectRatio = 0.75;

                        if (constraints.maxWidth > 900) {
                          crossAxisCount = 2;
                          childAspectRatio = 1.0;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                          childAspectRatio = 0.85;
                        } else {
                          crossAxisCount = 1;
                          childAspectRatio = 0.75;
                        }

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: childAspectRatio,
                          children: [
                            ProductCard(
                              id: 'white-shirt',
                              title: 'Essential T-Shirt',
                              price: '£6.99',
                              imageUrl: 'assets/images/white_shirt1.jpg',
                            ),
                            ProductCard(
                              id: 'white-hoodie',
                              title: 'Classic Hoodie',
                              price: '£25.00',
                              imageUrl: 'assets/images/white_hoodie1.jpg',
                            ),
                            ProductCard(
                              id: 'black-hoodie',
                              title: 'Black Hoodie',
                              price: '£25.00',
                              imageUrl: 'assets/images/black_hoodie1.jpg',
                            ),
                            ProductCard(
                              id: 'black-shirt',
                              title: 'Black T-Shirt',
                              price: '£15.00',
                              imageUrl: 'assets/images/black_shirt1.jpg',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer (reusable)
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: {
              'id': widget.id,
              'title': widget.title,
              'price': widget.price,
              'imageUrl': widget.imageUrl,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.imageUrl,
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
                    ),
                    // Grey overlay when hovered
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isHovered ? 0.3 : 0.0,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.price,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
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
