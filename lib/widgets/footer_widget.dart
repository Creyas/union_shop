import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final bool compact;
  const FooterWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final padding = compact ? 16.0 : 32.0;
    final headingSize = compact ? 14.0 : 16.0;
    final bodySize = compact ? 12.0 : 14.0;
    final accent = const Color(0xFF4d2963);

    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          Widget openingHours = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Opening Hours',
                  style: TextStyle(
                      fontSize: headingSize, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text('❄️ Winter Break Closure Dates ❄️',
                  style: TextStyle(
                      fontSize: bodySize, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text('Closing 4pm 19/12/2025',
                  style: TextStyle(fontSize: bodySize)),
              Text('Reopening 10am 05/01/2026',
                  style: TextStyle(fontSize: bodySize)),
              Text('Last post date: 12pm on 18/12/2025',
                  style: TextStyle(fontSize: bodySize)),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text('(Term Time)',
                  style: TextStyle(
                      fontSize: bodySize, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Monday - Friday 10am - 4pm',
                  style: TextStyle(fontSize: bodySize)),
              const SizedBox(height: 8),
              Text('(Outside of Term Time / Consolidation Weeks)',
                  style: TextStyle(
                      fontSize: bodySize, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Monday - Friday 10am - 3pm',
                  style: TextStyle(fontSize: bodySize)),
              const SizedBox(height: 8),
              Text('Purchase online 24/7',
                  style: TextStyle(fontSize: bodySize)),
            ],
          );

          Widget helpInfo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Help and Information',
                  style: TextStyle(
                      fontSize: headingSize, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: const Size(0, 24)),
                child: Text('Search',
                    style:
                        TextStyle(fontSize: bodySize, color: Colors.grey[800])),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: const Size(0, 24)),
                child: Text('Terms & Conditions of Sale',
                    style:
                        TextStyle(fontSize: bodySize, color: Colors.grey[800])),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: const Size(0, 24)),
                child: Text('Policy',
                    style:
                        TextStyle(fontSize: bodySize, color: Colors.grey[800])),
              ),
            ],
          );

          Widget latestOffers = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latest Offers',
                  style: TextStyle(
                      fontSize: headingSize, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Email address',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subscribed (static)')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                      child: const Text('SUBSCRIBE'),
                    ),
                  ),
                ],
              ),
            ],
          );

          Widget content;
          if (isWide) {
            content = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: openingHours),
                const SizedBox(width: 40),
                Expanded(flex: 3, child: helpInfo),
                const SizedBox(width: 40),
                Expanded(flex: 4, child: latestOffers),
              ],
            );
          } else {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                openingHours,
                const SizedBox(height: 24),
                helpInfo,
                const SizedBox(height: 24),
                latestOffers,
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              const SizedBox(height: 24),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('© ${DateTime.now().year} Union Shop',
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: bodySize * 0.95)),
                  Text('All rights reserved',
                      style: TextStyle(
                          color: Colors.grey[700], fontSize: bodySize * 0.95)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
