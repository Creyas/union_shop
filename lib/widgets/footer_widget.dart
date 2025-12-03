import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final bool compact;
  const FooterWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final padding = compact ? 12.0 : 24.0;
    final fontSize = compact ? 14.0 : 16.0;

    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Placeholder Footer',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} Union Shop — All rights reserved.',
            style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9),
          ),
        ],
      ),
    );
  }
}
