import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/mobile_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(
              showBack: true,
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Union Shop',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to the University of Portsmouth Students\' Union Shop!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'We provide high-quality merchandise for students, featuring comfortable clothing and accessories that represent our vibrant student community.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To offer affordable, quality products that help students show their university pride while supporting student services and activities.',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Email: shop@upsu.net\nPhone: 023 9284 3000\nLocation: Student Union Building, Cambridge Road, Portsmouth',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
      endDrawer: const MobileDrawer(),
    );
  }
}
