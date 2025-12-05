import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/mobile_drawer.dart';
import '../data/products_data.dart';
import '../providers/cart_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectedSize;
  String? selectedColor;
  int quantity = 1;
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Get the product from arguments
    final Product? product = args?['product'] as Product?;

    // If no product is passed, show error or navigate back
    if (product == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found')),
        );
        Navigator.pop(context);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      endDrawer: const MobileDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),
            Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: isMobile
                  ? _buildMobileLayout(product, cartProvider)
                  : _buildDesktopLayout(product, cartProvider),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(Product product, CartProvider cartProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Gallery
        Expanded(
          flex: 1,
          child: _buildImageGallery(product),
        ),
        const SizedBox(width: 48),
        // Product Details
        Expanded(
          flex: 1,
          child: _buildProductDetails(product, cartProvider),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Product product, CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageGallery(product),
        const SizedBox(height: 24),
        _buildProductDetails(product, cartProvider),
      ],
    );
  }

  Widget _buildImageGallery(Product product) {
    // Get all available images for this product
    final images = [
      product.defaultImageUrl,
      if (product.additionalImages.isNotEmpty) ...product.additionalImages,
    ];

    return Column(
      children: [
        // Main Image
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              images[selectedImageIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 16),
          // Thumbnail Images
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 80,
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
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 30,
                            color: Colors.grey[400],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductDetails(Product product, CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          children: [
            if (product.hasDiscount) ...[
              Text(
                product.price,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ] else
              Text(
                product.price,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4d2963),
                ),
              ),
          ],
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        // Description
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        // Size Selection (if applicable)
        if (product.hasSize) ...[
          const Text(
            'Select Size',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: product.availableSizes.map((size) {
              return ChoiceChip(
                label: Text(size),
                selected: selectedSize == size,
                onSelected: (selected) {
                  setState(() {
                    selectedSize = selected ? size : null;
                  });
                },
                selectedColor: const Color(0xFF4d2963),
                labelStyle: TextStyle(
                  color: selectedSize == size ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Color Selection (if applicable)
        if (product.availableColors.isNotEmpty) ...[
          const Text(
            'Select Color',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: product.availableColors.map((color) {
              return ChoiceChip(
                label: Text(color),
                selected: selectedColor == color,
                onSelected: (selected) {
                  setState(() {
                    selectedColor = selected ? color : null;
                  });
                },
                selectedColor: const Color(0xFF4d2963),
                labelStyle: TextStyle(
                  color: selectedColor == color ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Quantity Selection
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: quantity > 1
                  ? () {
                      setState(() {
                        quantity--;
                      });
                    }
                  : null,
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[200],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Validate size selection if required
              if (product.hasSize && selectedSize == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a size')),
                );
                return;
              }

              // Add to cart
              cartProvider.addItem(
                product.id,
                product.title,
                product.price,
                product.defaultImageUrl,
                quantity,
                selectedSize,
                selectedColor,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} added to cart!'),
                  action: SnackBarAction(
                    label: 'View Cart',
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4d2963),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Add to Cart'),
          ),
        ),
      ],
    );
  }
}
