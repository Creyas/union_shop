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

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildHeader(context, isMobile, false, 'Guest');
        }

        final isLoggedIn = snapshot.hasData && snapshot.data != null;
        final userName = snapshot.data?.displayName ?? 'Guest';

        return _buildHeader(context, isMobile, isLoggedIn, userName);
      },
    );
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
                  'assets/union_logo.jpg', // Changed from .png to .jpg
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image fails to load
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
                'assets/union_logo.jpg', // Changed from .png to .jpg
                height: 32,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image fails to load
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
