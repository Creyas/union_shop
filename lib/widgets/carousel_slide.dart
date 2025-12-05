import 'package:flutter/material.dart';

class CarouselSlide extends StatelessWidget {
  final String type;

  const CarouselSlide({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String title;
    String subtitle;

    if (type == 'carousel1') {
      backgroundColor = const Color(0xFF4d2963); // Purple
      title = 'Welcome to Union Shop';
      subtitle = 'Quality merchandise for Portsmouth students';
    } else if (type == 'carousel2') {
      backgroundColor = const Color(0xFF2c5f7d); // Blue
      title = 'New Arrivals';
      subtitle = 'Check out our latest collection';
    } else {
      backgroundColor = const Color(0xFF1a4d2e); // Green
      title = 'Student Discounts';
      subtitle = 'Great prices on all items';
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 24,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/all-products');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: backgroundColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 32 : 48,
                    vertical: isMobile ? 12 : 16,
                  ),
                  textStyle: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Shop Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
