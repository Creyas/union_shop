import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/products_data.dart';
import 'collections.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/product_card.dart'; 
class CollectionDetailPage extends StatelessWidget {
  const CollectionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final category = args?['category'] ?? 'all';
    final title = args?['title'] ?? 'Collection';

    final isMobile = MediaQuery.of(context).size.width < 600;

    List<Product> products = [];
    switch (category) {
      case 'clothes':
        products = CollectionsPage.getClothesProducts();
        break;
      case 'merchandise':
        products = CollectionsPage.getMerchandiseProducts();
        break;
      case 'freshers':
        products = CollectionsPage.getFreshersSaleProducts();
        break;
      default:
        products = ProductsData.allProducts;
    }

    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),

            // Page Title
            Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 24.0 : 40.0,
                bottom: isMobile ? 16.0 : 32.0,
                left: isMobile ? 16.0 : 24.0,
                right: isMobile ? 16.0 : 24.0,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${products.length} ${products.length == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Products Grid
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 24.0,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double childAspectRatio = 0.75;

                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 3;
                    childAspectRatio = 0.75;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                    childAspectRatio = 0.75;
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: childAspectRatio,
                    children: products.map((product) {
                      return ProductCard(
                        product: product,
                      );
                    }).toList(),
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
}
