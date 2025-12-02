import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Column(
        children: [
          HeaderWidget(
            compact: true,
            onLogoTap: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
            // onAbout can be null here or navigate back to same page
            onAbout: () => Navigator.pushNamed(context, '/about'),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Text('Your about content here.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
