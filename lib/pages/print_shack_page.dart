import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  String selectedColor = 'White';
  String selectedSize = 'M';
  String selectedLineOption = 'One Line of Text';
  int quantity = 1;
  
  final TextEditingController _line1Controller = TextEditingController();
  final TextEditingController _line2Controller = TextEditingController();
  final TextEditingController _line3Controller = TextEditingController();
  
  final Map<String, String> colorImages = {
    'White': 'assets/images/white_hoodie1.jpg',
    'Black': 'assets/images/black_hoodie1.jpg',
  };

  final double basePrice = 25.00;
  final double personalizationPrice = 3.00;

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _line3Controller.dispose();
    super.dispose();
  }

  double get totalPrice {
    return basePrice + personalizationPrice;
  }

  int get maxLines {
    switch (selectedLineOption) {
      case 'One Line of Text':
        return 1;
      case 'Two Lines of Text':
        return 2;
      case 'Three Lines of Text':
        return 3;
      default:
        return 1;
    }
  }

  void addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Build personalization text
    List<String> lines = [];
    if (_line1Controller.text.isNotEmpty) lines.add(_line1Controller.text);
    if (maxLines >= 2 && _line2Controller.text.isNotEmpty) {
      lines.add(_line2Controller.text);
    }
    if (maxLines >= 3 && _line3Controller.text.isNotEmpty) {
      lines.add(_line3Controller.text);
    }
    
    if (lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter personalization text'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final personalizationText = lines.join(' | ');
    
    final cartItem = CartItem(
      id: 'print-shack-${DateTime.now().millisecondsSinceEpoch}',
      name: 'Personalized Hoodie - $personalizationText',
      price: totalPrice,
      color: selectedColor,
      size: selectedSize,
      quantity: quantity,
      imageUrl: colorImages[selectedColor]!,
    );

    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Personalized hoodie added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(showBack: true),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: isDesktop
                      ? _buildDesktopLayout(isMobile)
                      : _buildMobileLayout(isMobile),
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

  Widget _buildDesktopLayout(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildProductImage(),
        ),
        const SizedBox(width: 48),
        Expanded(
          child: _buildCustomizationPanel(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      children: [
        _buildProductImage(),
        const SizedBox(height: 24),
        _buildCustomizationPanel(),
      ],
    );
  }

  Widget _buildProductImage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            colorImages[selectedColor]!,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 400,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image, size: 100),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Color thumbnails
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: colorImages.keys.map((color) {
            final isSelected = selectedColor == color;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4d2963)
                          : Colors.grey[300]!,
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      colorImages[color]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomizationPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personalisation',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '£${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4d2963),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Base: £${basePrice.toStringAsFixed(2)} + Print: £${personalizationPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Tax included.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),

        // Color Selection
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
          children: colorImages.keys.map((color) {
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

        // Size Selection
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

        // Per Line Selection
        const Text(
          'Per Line: Number of Lines',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedLineOption,
            isExpanded: true,
            underline: const SizedBox(),
            items: [
              'One Line of Text',
              'Two Lines of Text',
              'Three Lines of Text'
            ].map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLineOption = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 24),

        // Personalization Text Fields
        const Text(
          'Personalisation Line 1:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _line1Controller,
          decoration: InputDecoration(
            hintText: 'Enter text for line 1',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          maxLength: 20,
        ),
        const SizedBox(height: 16),

        if (maxLines >= 2) ...[
          const Text(
            'Personalisation Line 2:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _line2Controller,
            decoration: InputDecoration(
              hintText: 'Enter text for line 2',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLength: 20,
          ),
          const SizedBox(height: 16),
        ],

        if (maxLines >= 3) ...[
          const Text(
            'Personalisation Line 3:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _line3Controller,
            decoration: InputDecoration(
              hintText: 'Enter text for line 3',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLength: 20,
          ),
          const SizedBox(height: 16),
        ],

        // Quantity
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

        // Add to Cart Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => addToCart(context),
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
        const SizedBox(height: 24),

        // Product Description
        const Text(
          'Product Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Create your own personalized hoodie! Add up to 3 lines of custom text. Perfect for teams, events, or personal style. High-quality printing ensures your design looks great wash after wash.',
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

