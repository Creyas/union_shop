import 'package:flutter/material.dart';

class CarouselSlide extends StatelessWidget {
  final String type;

  const CarouselSlide({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String imagePath;
    String title;
    String subtitle;
    String buttonText;
    String route;

    if (type == 'carousel1') {
      imagePath = 'images/white_hoodie1.jpg';
      title = 'New Hoodies Collection';
      subtitle = 'Stay warm and stylish this season';
      buttonText = 'Shop Hoodies';
      route = '/all-products';
    } else if (type == 'carousel2') {
      imagePath = 'images/white_lanyard.jpg';
      title = 'Accessories & More';
      subtitle = 'Complete your look with our accessories';
      buttonText = 'View Accessories';
      route = '/all-products';
    } else {
      imagePath = 'images/backpack.jpg';
      title = 'University Merchandise';
      subtitle = 'Show your Portsmouth pride';
      buttonText = 'Shop Merchandise';
      route = '/all-products';
    }

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
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
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 24,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4d2963),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 32 : 48,
                    vertical: isMobile ? 12 : 16,
                  ),
                  textStyle: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
