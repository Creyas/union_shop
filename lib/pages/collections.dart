import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(compact: true, showBack: true),
            
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
            
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}