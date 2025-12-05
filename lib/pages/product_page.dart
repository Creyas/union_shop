import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/products_data.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedColor = 'White';
  String selectedSize = 'M';
  int quantity = 1;

  String getCurrentImage(Product product) {
    return product.colorImages[selectedColor] ??
        product.colorImages['White'] ??
        product.defaultImageUrl;
  }

  void addToCart(BuildContext context, Product product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Use discounted price if available
    final priceString =
        product.hasDiscount ? product.discountedPrice : product.price;
    final price = double.parse(priceString.replaceAll('£', ''));
    final currentImage = getCurrentImage(product);

    final cartItem = CartItem(
      id: '${product.id}-${DateTime.now().millisecondsSinceEpoch}',
      name: product.title,
      price: price,
      color: selectedColor,
      size: product.hasSize ? selectedSize : 'One Size',
      quantity: quantity,
      imageUrl: currentImage,
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

    final productId = args?['id'] ?? 'white-shirt';
    final product = ProductsData.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Not Found')),
        body: const Center(child: Text('Product not found')),
      );
    }

    final isDesktop = MediaQuery.of(context).size.width > 900;
    final currentImage = getCurrentImage(product);

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
                      ? _buildDesktopLayout(currentImage, product, context)
                      : _buildMobileLayout(currentImage, product, context),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    String currentImage,
    Product product,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Center - Main Image
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: Image.asset(
                currentImage,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 500,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        // Right side - Product details and buttons
        Expanded(
          flex: 1,
          child: _buildProductDetails(product, context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    String currentImage,
    Product product,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Image.asset(
              currentImage,
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
        ),
        const SizedBox(height: 24),
        // Product details
        _buildProductDetails(product, context),
      ],
    );
  }

  Widget _buildProductDetails(Product product, BuildContext context) {
    // Check if product has multiple colors
    final hasMultipleColors = product.colorImages.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Price with discount
        if (product.hasDiscount) ...[
          Row(
            children: [
              Text(
                product.price,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                product.discountedPrice,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage!.toInt()}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ] else
          Text(
            product.price,
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
          children: product.colorImages.keys.map((color) {
            final isSelected = selectedColor == color;
            final isEnabled = hasMultipleColors;

            return ChoiceChip(
              label: Text(color),
              selected: isSelected,
              onSelected: isEnabled
                  ? (selected) {
                      setState(() {
                        selectedColor = color;
                      });
                    }
                  : null,
              selectedColor:
                  isEnabled ? const Color(0xFF4d2963) : Colors.grey[400],
              backgroundColor: isEnabled ? null : Colors.grey[300],
              disabledColor: Colors.grey[300],
              labelStyle: TextStyle(
                color: isEnabled
                    ? (isSelected ? Colors.white : Colors.black)
                    : Colors.grey[600],
              ),
            );
          }).toList(),
        ),
        if (product.hasSize) ...[
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
        ],
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
            onPressed: () => addToCart(context, product),
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
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
