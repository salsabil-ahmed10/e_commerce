import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_screen.dart';
import '../../data/products.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  static const _brown = Color(0xFF5C453D);
  static const _fieldPink = Color(0xFFEFCFCB);
  static const _hintColor = Color(0xFF8A7068);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _onLogin() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  debugPrint('Login: $email / $password');

  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('isLoggedIn', true);

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(
        products: products,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/تنزيل (3).jpeg', fit: BoxFit.cover),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Transform.translate(
                    offset: const Offset(0, 50),
                    child: const Text(
                      'rhode',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                        color: Color(0xFFF3E6E1),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, 50),
                    child: const Text(
                      'Skincare. Makeup. Everyday.',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: height * 0.41),

                  _buildField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: _hintColor,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brown,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Text(
                    'Better Products. Brighter You.',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _hintColor),
        prefixIcon: Icon(icon, color: _hintColor),
        suffixIcon: suffix,
        filled: true,
        fillColor: _fieldPink.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
