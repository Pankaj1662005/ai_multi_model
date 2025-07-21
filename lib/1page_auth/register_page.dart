import 'package:emessage/1page_auth/login_page.dart';
import 'package:emessage/1page_auth/verfiy_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../0main_themes/light_mode.dart';
import 'auth_service.dart';
class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  final UserAuthService _authService = UserAuthService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final res = await _authService.signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _fullNameController.text.trim(),
    );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));

    if (res.startsWith("A verification email")) {
      // Navigate to verification screen here if needed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            name: _fullNameController.text, // We don't have the full name here
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  void _goToSignIn() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Lottie.asset(
                    'assets/welcome.json',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Let's create your account!",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                ),

                const SizedBox(height: 22),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter your full name'
                      : null,
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'College Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Enter your college email';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6)
                      ? 'Min 6 characters'
                      : null,
                ),

                const SizedBox(height: 24),

                // Button
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _signup,
                        style: AppButtonStyles.primaryButton,
                        child: const Text('Sign Up'),
                      ),

                const SizedBox(height: 16),

                // Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: AppTextStyles.body),
                    GestureDetector(
                      onTap: _goToSignIn,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
