import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/product_card.dart';
import '../data/products_data.dart';

class FreshersSalePage extends StatelessWidget {
  const FreshersSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get only products with discounts
    final saleProducts = ProductsData.allProducts
        .where((product) => product.hasDiscount)
        .toList();

    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: Column(
        children: [
          const HeaderWidget(showBack: true),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red.shade700,
                          Colors.orange.shade600,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          size: 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Freshers Sale',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Exclusive discounts for new students!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Up to ${_getMaxDiscount(saleProducts)}% OFF',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Products Grid
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (saleProducts.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No sale items at the moment',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check back soon for amazing deals!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${saleProducts.length} items on sale',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  int crossAxisCount =
                                      constraints.maxWidth > 1200
                                          ? 4
                                          : constraints.maxWidth > 800
                                              ? 3
                                              : constraints.maxWidth > 600
                                                  ? 2
                                                  : 1;

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: saleProducts.length,
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                        product: saleProducts[index],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getMaxDiscount(List<Product> products) {
    if (products.isEmpty) return 0;
    return products
        .map((p) => p.discountPercentage ?? 0)
        .reduce((a, b) => a > b ? a : b)
        .toInt();
  }
}
