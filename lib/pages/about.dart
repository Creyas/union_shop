import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          HeaderWidget(compact: true, showBack: true),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Text("""Welcome to the Union Shop!

We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!

All online purchases are available for delivery or instore collection!

We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.

Happy shopping!

The Union Shop & Reception Team​​​​​​​​​"""),
              ),
            ),
          ),
          FooterWidget(compact: true), // reuse footer here
        ],
      ),
    );
  }
}
