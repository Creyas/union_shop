import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/products_data.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),

            // Page Title
            Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 24.0 : 32.0,
                bottom: isMobile ? 16.0 : 24.0,
              ),
              child: Center(
                child: Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),

            // Collections Categories
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
                vertical: isMobile ? 16.0 : 32.0,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.2,
                    children: [
                      _buildCollectionCategory(
                        context,
                        title: 'Clothes',
                        description: 'T-Shirts & Hoodies',
                        imageUrl: 'assets/images/white_hoodie1.jpg',
                        category: 'clothes',
                        itemCount: _getClothesProducts().length,
                      ),
                      _buildCollectionCategory(
                        context,
                        title: 'Merchandise',
                        description: 'Accessories & More',
                        imageUrl: 'assets/images/backpack.jpg',
                        category: 'merchandise',
                        itemCount: _getMerchandiseProducts().length,
                      ),
                      _buildCollectionCategory(
                        context,
                        title: 'Freshers Sale',
                        description: 'Special Offers',
                        imageUrl: 'assets/images/white_shirt1.jpg',
                        category: 'freshers',
                        itemCount: _getFreshersSaleProducts().length,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 48),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCategory(
    BuildContext context, {
    required String title,
    required String description,
    required String imageUrl,
    required String category,
    required int itemCount,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/collection-detail',
            arguments: {
              'category': category,
              'title': title,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Text Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods to filter products - make them public (remove underscore)
  static List<Product> getClothesProducts() {
    return ProductsData.allProducts
        .where((p) => ['white-shirt', 'white-hoodie'].contains(p.id))
        .toList();
  }

  static List<Product> getMerchandiseProducts() {
    return ProductsData.allProducts
        .where((p) =>
            ['calculator', 'backpack', 'flask', 'lanyard'].contains(p.id))
        .toList();
  }

  static List<Product> getFreshersSaleProducts() {
    return ProductsData.allProducts
        .where((p) => ['beerpong', 'football', 'dartset'].contains(p.id))
        .toList();
  }
}
