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

  