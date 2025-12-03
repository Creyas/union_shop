import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding =
        MediaQuery.of(context).size.width > 900 ? 120.0 : 24.0;

    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(compact: true, showBack: true),

          // Title
          Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
            child: Center(
              child: Text(
                'About us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // Body content (preserves your original string)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Text(
                  """Welcome to the Union Shop!

We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!

All online purchases are available for delivery or instore collection!

We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.

Happy shopping!

The Union Shop & Reception Team​​​​​​​​​""",
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),

          const FooterWidget(compact: true),
        ],
      ),
    );
  }
}
