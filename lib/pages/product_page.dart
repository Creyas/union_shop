import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedColor = 'Purple';
  String selectedSize = 'XS';
  int quantity = 1;

  final List<String> colors = ['Purple', 'Grey', 'Black', 'Blue'];
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL', '2XL'];

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final cartItem = CartItem(
      id: 'classic-hoodie-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Classic Hoodies',
      price: 25.00,
      color: selectedColor,
      size: selectedSize,
      quantity: quantity,
      imageUrl: 'assets/images/purple_hoodie.jpg',
    );

    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(),

            // Product details container
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main product image
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/purple_hoodie.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 100),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Product name
                  const Text(
                    'Placeholder Product Name',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Product price
                  const Text(
                    '£15.00',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4d2963),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
