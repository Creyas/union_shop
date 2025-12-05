import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'search_overlay.dart';
import '../pages/login_signup.dart';

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
            horizontal: isMobile ? 12 : 24,
            vertical: isMobile ? 12 : 16,
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
                )
              else if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _showMobileMenu(context);
                  },
                  iconSize: 24,
                ),

              if (!isMobile || !showBack)
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
                    'assets/images/union_logo.png',
                    height: isMobile ? 30 : 40,
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

              // Right side icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      SearchOverlay.show(
                        context,
                        onSelect: (query) {
                          // Example: send to product page with query as argument.
                          // Update your '/product' route to accept arguments or handle as you prefer.
                          Navigator.pushNamed(context, '/product',
                              arguments: {'query': query});
                        },
                    },
                    iconSize: isMobile ? 20 : 24,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => Navigator.pushNamed(context, '/auth'),
                    iconSize: isMobile ? 20 : 24,
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                        iconSize: isMobile ? 20 : 24,
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 8 : 10,
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
    showModalBottomSheet(
      context: context,
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
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
          ],
        ),
      ),
    );
  }
}
