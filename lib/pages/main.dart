import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'product_page.dart';
import 'about.dart';
import 'login_signup.dart';
import 'cart_page.dart';
import 'dart:async';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

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
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              compact: true,
              onLogoTap: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              onAbout: () => Navigator.pushNamed(context, '/about'),
            ),

            // Hero Section (replaced by carousel)
            HeroCarousel(
              height: 400,
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
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'SIGNATURE RANGE',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: const [
                        ProductCard(
                          title: 'Essential T-Shirt',
                          price: '£6.99',
                          imageUrl: 'assets/images/white_shirt1.jpg',
                        ),
                        ProductCard(
                          title: 'Classic Hoodie',
                          price: '£25.00',
                          imageUrl: 'assets/images/white_hoodie1.jpg',
                        ),
                        ProductCard(
                          title: 'Black Hoodie',
                          price: '£25.00',
                          imageUrl: 'assets/images/black_hoodie1.jpg',
                        ),
                        ProductCard(
                          title: 'Black T-Shirt',
                          price: '£15.00',
                          imageUrl: 'assets/images/black_shirt1.jpg',
                        ),
                      ],
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

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
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
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // PageView for images (wrapped so horizontal drags are forwarded)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              // forward horizontal drag to PageController so dragging works inside
              // the outer vertical scroll view and overlaid widgets
              onHorizontalDragUpdate: (details) {
                _pageController
                    .jumpTo(_pageController.offset - details.delta.dx);
              },
              onHorizontalDragEnd: (details) {
                // snap to the nearest page, with a velocity-based bias
                final double page = _pageController.page ??
                    _pageController.initialPage.toDouble();
                int target = page.round();
                final v = details.primaryVelocity ?? 0.0;
                if (v.abs() > 300) {
                  target = v < 0 ? (page + 1).toInt() : (page - 1).toInt();
                }
                target = target.clamp(0, widget.imageUrls.length - 1);
                _pageController.animateToPage(
                  target,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
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
                      // choose asset for local images, network otherwise
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
                      const IgnorePointer(
                        ignoring: true,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.5)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Content overlay (same content as before)
          Positioned(
            left: 24,
            right: 24,
            top: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Placeholder Hero Title',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "This is placeholder text for the hero section.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: widget.onBrowse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4d2963),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'BROWSE PRODUCTS',
                    style: TextStyle(fontSize: 14, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar: dots centered, pause/play on right
          Positioned(
            bottom: 16,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(widget.imageUrls.length, (i) {
                        final selected = i == _current;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
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
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white, size: 18),
                    onPressed: _togglePaused,
                    tooltip: _isPaused ? 'Resume' : 'Pause',
                    padding: const EdgeInsets.all(8),
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
