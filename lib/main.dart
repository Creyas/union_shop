import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import 'search_overlay.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/mobile_drawer.dart';

class HeaderWidget extends StatelessWidget {
  final bool showBack;

  const HeaderWidget({
    super.key,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    // For web, add extra delay to ensure Firebase is ready
    if (kIsWeb) {
      return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _buildHeader(context, isMobile, false, 'Guest');
          }

          return _buildAuthStreamBuilder(context, isMobile);
        },
      );
    }

    return _buildAuthStreamBuilder(context, isMobile);
  }

  Widget _buildAuthStreamBuilder(BuildContext context, bool isMobile) {
    try {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            print('Firebase Auth Stream error: ${snapshot.error}');
            return _buildHeader(context, isMobile, false, 'Guest');
          }

          // Handle loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildHeader(context, isMobile, false, 'Guest');
          }

          final isLoggedIn = snapshot.hasData && snapshot.data != null;
          final userName = snapshot.data?.displayName ?? 'Guest';

          return _buildHeader(context, isMobile, isLoggedIn, userName);
        },
      );
    } catch (e) {
      print('Firebase Auth error: $e');
      return _buildHeader(context, isMobile, false, 'Guest');
    }
  }

  Widget _buildHeader(
      BuildContext context, bool isMobile, bool isLoggedIn, String userName) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? _buildMobileHeader(context, isLoggedIn, userName)
          : _buildDesktopHeader(context, isLoggedIn, userName),
    );
  }

  Widget _buildDesktopHeader(
      BuildContext context, bool isLoggedIn, String userName) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo and Back Button
        Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Image.asset(
                  'assets/union_logo.jpg',
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'The Union Shop',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4d2963),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // Navigation Menu
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildShopDropdown(context),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: const Text(
                'About',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        // Icons and User Menu
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SearchOverlay(),
                );
              },
            ),
            // Shopping cart with badge
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            if (isLoggedIn)
              _buildUserMenu(context, userName)
            else
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/auth'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d2963),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHeader(
      BuildContext context, bool isLoggedIn, String userName) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/'),
              child: Image.asset(
                'assets/union_logo.jpg',
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'The Union Shop',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4d2963),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SearchOverlay(),
                );
              },
            ),
            // Shopping cart with badge
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserMenu(BuildContext context, String userName) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: const Color(0xFF4d2963),
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        label: Text(
          userName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 12),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'orders',
          child: Row(
            children: [
              Icon(Icons.shopping_bag, size: 20),
              SizedBox(width: 12),
              Text('My Orders'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Sign Out', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (String value) async {
        try {
          final AuthService authService = AuthService();
          if (value == 'profile') {
            Navigator.pushNamed(context, '/profile');
          } else if (value == 'orders') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order history coming soon!')),
            );
          } else if (value == 'logout') {
            await authService.signOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/');
            }
          }
        } catch (e) {
          print('Menu action error: $e');
        }
      },
    );
  }

  Widget _buildShopDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: TextButton(
        onPressed: null,
        child: Row(
          children: const [
            Text(
              'Shop',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'all',
          child: Text('All Products'),
        ),
        const PopupMenuItem<String>(
          value: 'collections',
          child: Text('Collections'),
        ),
        const PopupMenuItem<String>(
          value: 'print-shack',
          child: Text('Print Shack'),
        ),
      ],
      onSelected: (String value) {
        if (value == 'all') {
          Navigator.pushNamed(context, '/all-products');
        } else if (value == 'collections') {
          Navigator.pushNamed(context, '/collections');
        } else if (value == 'print-shack') {
          Navigator.pushNamed(context, '/print-shack');
        }
      },
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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
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
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Carousel
                  SizedBox(
                    height: 400,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: [
                        _buildCarouselItem('images/carousel1.jpg'),
                        _buildCarouselItem('images/carousel2.jpg'),
                        _buildCarouselItem('images/carousel3.jpg'),
                      ],
                    ),
                  ),

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
      // Add endDrawer for mobile menu
      endDrawer: const MobileDrawer(),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF4d2963),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.shop),
                    title: const Text('Shop'),
                    children: [
                      ListTile(
                        title: const Text('  All Products'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/all-products');
                        },
                      ),
                      ListTile(
                        title: const Text('  Collections'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/collections');
                        },
                      ),
                      ListTile(
                        title: const Text('  Print Shack'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/print-shack');
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Stack(
                      children: [
                        const Icon(Icons.shopping_cart),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${cartProvider.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: const Text('Cart'),
                    trailing: cartProvider.itemCount > 0
                        ? Text(
                            '${cartProvider.itemCount} items',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  const Divider(),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final isLoggedIn =
                          snapshot.hasData && snapshot.data != null;
                      final userName = snapshot.data?.displayName ?? 'Guest';

                      if (isLoggedIn) {
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF4d2963),
                                child: Text(
                                  userName.isNotEmpty
                                      ? userName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(userName),
                              subtitle: const Text('View Profile'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/profile');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.shopping_bag),
                              title: const Text('My Orders'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Order history coming soon!')),
                                );
                              },
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.red),
                              title: const Text('Sign Out',
                                  style: TextStyle(color: Colors.red)),
                              onTap: () async {
                                final AuthService authService = AuthService();
                                await authService.signOut();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/');
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Login / Sign Up'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/auth');
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ...rest of your existing ProductCard class...
