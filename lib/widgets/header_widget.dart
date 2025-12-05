import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import 'search_overlay.dart';

class HeaderWidget extends StatelessWidget {
  final bool showBack;

  const HeaderWidget({
    super.key,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data != null;
        final userName = snapshot.data?.displayName ?? 'User';

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
      },
    );
  }

  Widget _buildDesktopHeader(
      BuildContext context, bool isLoggedIn, String userName) {
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
                child: const Text(
                  'The Union Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4d2963),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Navigation Menu
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
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
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
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
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            const SizedBox(width: 8),
            if (isLoggedIn)
              PopupMenuButton<String>(
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
                  final AuthService authService = AuthService();
                  if (value == 'profile') {
                    Navigator.pushNamed(context, '/profile');
                  } else if (value == 'orders') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order history coming soon!')),
                    );
                  } else if (value == 'logout') {
                    await authService.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }
                },
              )
            else
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
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
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text(
                'The Union Shop',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4d2963),
                ),
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
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String label, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildShopDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: TextButton(
        onPressed: null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Shop',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'all',
          child: Text('All Products'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'print-shack',
          child: Text('Print Shack'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'collections',
          child: Text('Collections'),
        ),
        const PopupMenuItem<String>(
          value: 'clothes',
          child: Text('Clothes'),
        ),
        const PopupMenuItem<String>(
          value: 'merchandise',
          child: Text('Merchandise'),
        ),
        const PopupMenuItem<String>(
          value: 'freshers',
          child: Text('Freshers Sale'),
        ),
      ],
      onSelected: (String value) {
        if (value == 'all') {
          Navigator.pushNamed(context, '/all-products');
        } else if (value == 'print-shack') {
          Navigator.pushNamed(context, '/print-shack');
        } else if (value == 'collections') {
          Navigator.pushNamed(context, '/collections');
        } else {
          Navigator.pushNamed(
            context,
            '/collection-detail',
            arguments: {
              'category': value,
              'title': value == 'clothes'
                  ? 'Clothes'
                  : value == 'merchandise'
                      ? 'Merchandise'
                      : 'Freshers Sale',
            },
          );
        }
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                const Divider(),
                ListTile(
                  title: const Text('  Print Shack'),
                  leading: const Icon(Icons.print, size: 20),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/print-shack');
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('  Collections'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/collections');
                  },
                ),
                ListTile(
                  title: const Text('  Clothes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/collection-detail',
                      arguments: {
                        'category': 'clothes',
                        'title': 'Clothes',
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('  Merchandise'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/collection-detail',
                      arguments: {
                        'category': 'merchandise',
                        'title': 'Merchandise',
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text('  Freshers Sale'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/collection-detail',
                      arguments: {
                        'category': 'freshers',
                        'title': 'Freshers Sale',
                      },
                    );
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
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => const SearchOverlay(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/auth');
              },
            ),
            ListTile(
              leading: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
      ),
    );
  }
}
