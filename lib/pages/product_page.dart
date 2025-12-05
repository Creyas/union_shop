import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedColor = 'White';
  String selectedSize = 'M';
  int quantity = 1;
  int selectedImageIndex = 0;

  // Available product images (you can add more variants)
  List<String> getProductImages(String baseImage) {
    // For now, just show the same image twice as placeholders
    // You can add actual variant images later
    return [baseImage, baseImage];
  }

  void addToCart(BuildContext context, String productId, String productTitle,
      String productPrice, String productImage) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final price = double.parse(productPrice.replaceAll('£', ''));

    final cartItem = CartItem(
      id: '$productId-${DateTime.now().millisecondsSinceEpoch}',
      name: productTitle,
      price: price,
      color: selectedColor,
      size: selectedSize,
      quantity: quantity,
      imageUrl: productImage,
    );

    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final productTitle = args?['title'] ?? 'Essential T-Shirt';
    final productPrice = args?['price'] ?? '£6.99';
    final productImage = args?['imageUrl'] ?? 'assets/images/white_shirt1.jpg';
    final productId = args?['id'] ?? 'default';

    final productImages = getProductImages(productImage);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(
              showBack: true,
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: isDesktop
                      ? _buildDesktopLayout(
                          productImages,
                          productTitle,
                          productPrice,
                          productId,
                          productImage,
                          context,
                        )
                      : _buildMobileLayout(
                          productImages,
                          productTitle,
                          productPrice,
                          productId,
                          productImage,
                          context,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    List<String> productImages,
    String productTitle,
    String productPrice,
    String productId,
    String productImage,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Thumbnails
        Column(
          children: List.generate(
            productImages.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedImageIndex = index;
                });
              },
              child: Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedImageIndex == index
                        ? const Color(0xFF4d2963)
                        : Colors.grey[300]!,
                    width: selectedImageIndex == index ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    productImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Center - Main Image
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              productImages[selectedImageIndex],
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 600,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 40),
        // Right side - Product details and buttons
        Expanded(
          flex: 1,
          child: _buildProductDetails(
            productTitle,
            productPrice,
            productId,
            productImage,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    List<String> productImages,
    String productTitle,
    String productPrice,
    String productId,
    String productImage,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            productImages[selectedImageIndex],
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 400,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 50),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Thumbnails
        Row(
          children: List.generate(
            productImages.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedImageIndex = index;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedImageIndex == index
                        ? const Color(0xFF4d2963)
                        : Colors.grey[300]!,
                    width: selectedImageIndex == index ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    productImages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Product details
        _buildProductDetails(
          productTitle,
          productPrice,
          productId,
          productImage,
          context,
        ),
      ],
    );
  }

  Widget _buildProductDetails(
    String productTitle,
    String productPrice,
    String productId,
    String productImage,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          productPrice,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4d2963),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['White', 'Black', 'Grey'].map((color) {
            return ChoiceChip(
              label: Text(color),
              selected: selectedColor == color,
              onSelected: (selected) {
                setState(() {
                  selectedColor = color;
                });
              },
              selectedColor: const Color(0xFF4d2963),
              labelStyle: TextStyle(
                color: selectedColor == color ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['XS', 'S', 'M', 'L', 'XL', 'XXL'].map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: selectedSize == size,
              onSelected: (selected) {
                setState(() {
                  selectedSize = size;
                });
              },
              selectedColor: const Color(0xFF4d2963),
              labelStyle: TextStyle(
                color: selectedSize == size ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => addToCart(
                context, productId, productTitle, productPrice, productImage),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Product Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'High-quality comfortable clothing perfect for everyday wear. Made from premium materials with attention to detail.',
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
