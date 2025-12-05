import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'search_overlay.dart';

class HeaderWidget extends StatelessWidget {
  final bool compact;
  final bool showBack;

  const HeaderWidget({
    super.key,
    this.compact = false,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isWideScreen = MediaQuery.of(context).size.width > 800;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        // Sale Banner
        if (!compact)
          Container(
            width: double.infinity,
            color: const Color(0xFF2C1654),
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 8 : 12,
              horizontal: isMobile ? 12 : 24,
            ),
            child: Text(
              isMobile
                  ? 'BIG SALE! 20% OFF!'
                  : 'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10 : 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: isMobile ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Main Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 24,
            vertical: isMobile ? 8 : 16,
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
          child: Row(
            children: [
              // Back Button or Menu
              if (showBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  iconSize: isMobile ? 20 : 24,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _showMobileMenu(context);
                  },
                  iconSize: 24,
                  padding: const EdgeInsets.all(8),
                ),

              SizedBox(width: isMobile ? 8 : 16),

              // Logo
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ),
                  child: Image.asset(
                    'assets/images/union_logo.jpg',
                    height: isMobile ? 28 : 40,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),

              // Desktop Navigation
              if (isWideScreen && !compact)
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavButton(context, 'Home', '/'),
                      const SizedBox(width: 24),
                      _buildNavButton(context, 'Shop', '/collections'),
                      const SizedBox(width: 24),
                      _buildNavButton(context, 'About', '/about'),
                    ],
                  ),
                ),

              // Right side icons - Only show on desktop
              if (!isMobile)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const SearchOverlay(),
                        );
                      },
                      iconSize: 24,
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () => Navigator.pushNamed(context, '/auth'),
                      iconSize: 24,
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_bag_outlined),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/cart'),
                          iconSize: 24,
                        ),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            right: 4,
                            top: 4,
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Mobile Navigation (below header)
        if (!isWideScreen && !compact && !isMobile)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton(context, 'Home', '/'),
                const SizedBox(width: 24),
                _buildNavButton(context, 'Shop', '/collections'),
                const SizedBox(width: 24),
                _buildNavButton(context, 'About', '/about'),
              ],
            ),
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
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Shop'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/collections');
              },
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
