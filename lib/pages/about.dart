import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: const Column(
        children: [
          HeaderWidget(compact: true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Text('Your about content here.'),
              ),
            ),
          ),
          FooterWidget(compact: true), // reuse footer here
        ],
      ),
    );
  }
}
