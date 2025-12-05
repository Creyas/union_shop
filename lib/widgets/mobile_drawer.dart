import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF4d2963),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false); // Changed from '/' to '/home'
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.shop),
                    title: const Text('Shop'),
                    children: [
                      ListTile(
                        title: const Text('  All Products'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/all-products');
                        },
                      ),
                      ListTile(
                        title: const Text('  Collections'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/collections');
                        },
                      ),
                      ListTile(
                        title: const Text('  Print Shack'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/print-shack');
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Stack(
                      children: [
                        const Icon(Icons.shopping_cart),
                        if (cartProvider.itemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${cartProvider.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: const Text('Cart'),
                    trailing: cartProvider.itemCount > 0
                        ? Text(
                            '${cartProvider.itemCount} items',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  const Divider(),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final isLoggedIn =
                          snapshot.hasData && snapshot.data != null;
                      final userName = snapshot.data?.displayName ?? 'Guest';

                      if (isLoggedIn) {
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF4d2963),
                                child: Text(
                                  userName.isNotEmpty
                                      ? userName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(userName),
                              subtitle: const Text('View Profile'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/profile');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.shopping_bag),
                              title: const Text('My Orders'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Order history coming soon!')),
                                );
                              },
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.red),
                              title: const Text('Sign Out',
                                  style: TextStyle(color: Colors.red)),
                              onTap: () async {
                                final AuthService authService = AuthService();
                                await authService.signOut();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/');
                                }
                              },
                            ),
                          ],
                        );
                      } else {
                        return ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Login / Sign Up'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/auth');
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
