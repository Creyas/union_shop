import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // STATIC behavior: pretend to sign in / sign up, show a SnackBar.
    await Future.delayed(const Duration(milliseconds: 700));
    final msg = _isSignUp ? 'Account created (static)' : 'Signed in (static)';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() => _loading = false);

    // Optional: navigate to home after "auth"
    // Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 520.0;
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            compact: true,
            showBack: true,
            onBack: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                child: Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isSignUp ? 'Create an account' : 'Sign in',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          if (_isSignUp)
                            TextFormField(
                              controller: _nameCtrl,
                              decoration:
                                  const InputDecoration(labelText: 'Full name'),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Enter your name';
                                return null;
                              },
                            ),
                          if (_isSignUp) const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || !v.contains('@'))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.length < 6)
                                return 'Minimum 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CircularProgressIndicator(),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _submit,
                                child: Text(
                                    _isSignUp ? 'Create account' : 'Sign in'),
                              ),
                            ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => setState(() {
                              _isSignUp = !_isSignUp;
                            }),
                            child: Text(_isSignUp
                                ? 'Have an account? Sign in'
                                : 'Create an account'),
                          ),
                        ],
                      ),
                    ),
                  ),
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
