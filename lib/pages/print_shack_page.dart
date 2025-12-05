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

 