import 'package:flutter/material.dart';
import 'search_overlay.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: const Color(0xFF2c2c2c),
      padding: EdgeInsets.all(isMobile ? 24.0 : 48.0),
      child: isMobile ? _buildMobileFooter(context) : _buildDesktopFooter(context),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // About Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'The Union Shop offers quality merchandise for Portsmouth University students.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),

            // Quick Links
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Links',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFooterLink(context, 'Search', () {
                    showDialog(
                      context: context,
                      builder: (context) => const SearchOverlay(),
                    );
                  }),
                  _buildFooterLink(
                      context, 'All Products', () => Navigator.pushNamed(context, '/all-products')),
                  _buildFooterLink(
                      context, 'Collections', () => Navigator.pushNamed(context, '/collections')),
                  _buildFooterLink(
                      context, 'Print Shack', () => Navigator.pushNamed(context, '/print-shack')),
                  _buildFooterLink(
                      context, 'About', () => Navigator.pushNamed(context, '/about')),
                ],
              ),
            ),
            const SizedBox(width: 48),

            // Contact Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactInfo(Icons.email, 'shop@union.port.ac.uk'),
                  _buildContactInfo(Icons.phone, '+44 23 9284 3000'),
                  _buildContactInfo(Icons.location_on, 'Portsmouth, UK'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Divider(color: Colors.white24),
        const SizedBox(height: 16),
        Text(
          '© ${DateTime.now().year} The Union Shop. All rights reserved.',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // About Section
        const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'The Union Shop offers quality merchandise for Portsmouth University students.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),

        // Quick Links
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildFooterLink(context, 'Search', () {
          showDialog(
            context: context,
            builder: (context) => const SearchOverlay(),
          );
        }),
        _buildFooterLink(
            context, 'All Products', () => Navigator.pushNamed(context, '/all-products')),
        _buildFooterLink(
            context, 'Collections', () => Navigator.pushNamed(context, '/collections')),
        _buildFooterLink(
            context, 'Print Shack', () => Navigator.pushNamed(context, '/print-shack')),
        _buildFooterLink(context, 'About', () => Navigator.pushNamed(context, '/about')),
        const SizedBox(height: 24),

        // Contact Section
        const Text(
          'Contact',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildContactInfo(Icons.email, 'shop@union.port.ac.uk'),
        _buildContactInfo(Icons.phone, '+44 23 9284 3000'),
        _buildContactInfo(Icons.location_on, 'Portsmouth, UK'),
        const SizedBox(height: 24),
        const Divider(color: Colors.white24),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '© ${DateTime.now().year} The Union Shop. All rights reserved.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
