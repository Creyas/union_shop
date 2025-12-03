import 'package:flutter/material.dart';
import 'search_overlay.dart';

class HeaderWidget extends StatelessWidget {
  final bool compact;
  final VoidCallback? onAbout;
  final VoidCallback? onLogoTap;
  final bool showBack;
  final VoidCallback? onBack;

  const HeaderWidget({
    super.key,
    this.compact = false,
    this.onAbout,
    this.onLogoTap,
    this.showBack = false,
    this.onBack,
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
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold, // ← make text bold
              ),
            ),
          ),
        ),

        // main header row
        Container(
          color: Colors.white,
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding),
          child: Row(
            children: [
              // optional back button (left of the logo)
              if (showBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey),
                  padding: const EdgeInsets.all(8),
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                  onPressed: onBack ??
                      () {
                        // default behavior: pop if possible
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                ),
              GestureDetector(
                onTap: onLogoTap,
                child: SizedBox(
                  height: logoHeight,
                  child: Image.network(
                    'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
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
                    icon:
                        const Icon(Icons.search, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      SearchOverlay.show(
                        context,
                        onSelect: (query) {
                          // Example: send to product page with query as argument.
                          // Update your '/product' route to accept arguments or handle as you prefer.
                          Navigator.pushNamed(context, '/product',
                              arguments: {'query': query});
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline,
                        size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),
                  TextButton(
                    onPressed: onAbout,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: const Size(32, 32),
                    ),
                    child: const Text('About',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined,
                        size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 18, color: Colors.grey),
                    padding: const EdgeInsets.all(8),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
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
