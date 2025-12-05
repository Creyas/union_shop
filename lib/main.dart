import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'pages/product_page.dart';
import 'pages/about.dart';
import 'pages/login_signup.dart';
import 'pages/cart_page.dart';
import 'pages/collections.dart';
import 'pages/collection_detail.dart';
import 'pages/all_products_page.dart';
import 'pages/print_shack_page.dart';
import 'pages/freshers_sale_page.dart'; // Add this import
import 'widgets/header_widget.dart';
import 'widgets/footer_widget.dart';
import 'widgets/product_card.dart';
import 'widgets/mobile_drawer.dart';
import 'widgets/hero_carousel.dart';
import 'data/products_data.dart';
import 'pages/profile_page.dart';

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
        home: const FirebaseInitializer(),
        routes: {
          '/home': (context) => const HomePage(),
          '/product': (context) => const ProductPage(),
          '/about': (context) => const AboutPage(),
          '/auth': (context) => const LoginSignupPage(),
          '/cart': (context) => const CartPage(),
          '/collections': (context) => const CollectionsPage(),
          '/collection-detail': (context) => const CollectionDetailPage(),
          '/all-products': (context) => const AllProductsPage(),
          '/freshers-sale': (context) =>
              const FreshersSalePage(), // Add this line
          '/print-shack': (context) => const PrintShackPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}

class FirebaseInitializer extends StatefulWidget {
  const FirebaseInitializer({super.key});

  @override
  State<FirebaseInitializer> createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  Future<FirebaseApp>? _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error initializing Firebase: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initialization = Firebase.initializeApp(
                          options: DefaultFirebaseOptions.currentPlatform,
                        );
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          debugPrint('✅ Firebase initialized successfully');
          return const HomePage();
        }

        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4d2963)),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading Union Shop...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Carousel
                  const HeroCarousel(),

                  // Featured Products
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Featured Products',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = constraints.maxWidth > 1200
                                ? 4
                                : constraints.maxWidth > 800
                                    ? 3
                                    : constraints.maxWidth > 600
                                        ? 2
                                        : 1;

                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              children: ProductsData.allProducts
                                  .take(4)
                                  .map((product) {
                                return ProductCard(product: product);
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
