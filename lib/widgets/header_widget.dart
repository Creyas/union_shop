import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final bool compact;
  final VoidCallback? onAbout;
  final VoidCallback? onLogoTap;

  const HeaderWidget({
    super.key,
    this.compact = false,
    this.onAbout,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final bannerHeight = compact ? 28.0 : 40.0;
    final logoHeight = compact ? 36.0 : 48.0;
    final verticalPadding = compact ? 8.0 : 12.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // top colored banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: bannerHeight / 8),
          color: const Color(0xFF4d2963),
          child: const Center(
            child: Text(
              'PLACEHOLDER HEADER TEXT',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),

        // main header row
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
          child: Row(
            children: [
              GestureDetector(
                onTap: onLogoTap,
                child: SizedBox(
                  height: logoHeight,
                  child: Image.network(
                    'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      width: 120,
                      height: logoHeight,
                      color: Colors.grey[200],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // action icons + About text link
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),

                  TextButton(
                    onPressed: onAbout,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(32, 32),
                    ),
                    child: const Text('About', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),

                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}