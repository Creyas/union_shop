import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/products_data.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),

            // Page Title
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
              child: Center(
                child: Text(
                  'Collections',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),

            // Collections Grid
            Container(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 1200) {
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
                    childAspectRatio: 0.85,
                    children: [
                      _buildCollectionCard(
                        context,
                        title: 'Essential Range',
                        itemCount: 4,
                        imageUrl: 'assets/images/white_shirt1.jpg',
                        collectionId: 'essentials',
                      ),
                      _buildCollectionCard(
                        context,
                        title: 'Hoodies',
                        itemCount: 2,
                        imageUrl: 'assets/images/white_hoodie1.jpg',
                        collectionId: 'hoodies',
                      ),
                      _buildCollectionCard(
                        context,
                        title: 'T-Shirts',
                        itemCount: 2,
                        imageUrl: 'assets/images/black_shirt1.jpg',
                        collectionId: 'tshirts',
                      ),
                      _buildCollectionCard(
                        context,
                        title: 'Sale Items',
                        itemCount: 3,
                        imageUrl: 'assets/images/black_hoodie1.jpg',
                        collectionId: 'sale',
                      ),
                      _buildCollectionCard(
                        context,
                        title: 'New Arrivals',
                        itemCount: 4,
                        imageUrl: 'assets/images/white_shirt1.jpg',
                        collectionId: 'new-arrivals',
                      ),
                      _buildCollectionCard(
                        context,
                        title: 'Winter Collection',
                        itemCount: 2,
                        imageUrl: 'assets/images/white_hoodie1.jpg',
                        collectionId: 'winter',
                      ),
                    ],
                  );
                },
              ),
            ),

            // Products Grid
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                    childAspectRatio: 0.75,
                    children: ProductsData.allProducts.map((product) {
                      return ProductCard(
                        id: product.id,
                        title: product.title,
                        price: product.price,
                        imageUrl: product.defaultImageUrl,
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(
    BuildContext context, {
    required String title,
    required int itemCount,
    required String imageUrl,
    required String collectionId,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to collection detail page
          // You can implement this later to show products in this collection
          Navigator.pushNamed(
            context,
            '/collection',
            arguments: {
              'id': collectionId,
              'title': title,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Collection Image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Collection Info
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
