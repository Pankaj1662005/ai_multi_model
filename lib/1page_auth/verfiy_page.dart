import 'dart:async';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'login_page.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String name;
  final String email;

  const VerifyEmailScreen({
    required this.name,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final UserAuthService _authService = UserAuthService();
  Timer? _timer;
  bool _loading = false;
  bool _emailVerified = false;
  bool _canResend = true;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _checkVerificationPeriodically();
  }

  void _checkVerificationPeriodically() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _checkVerification());
  }

  Future<void> _checkVerification() async {
    if (_emailVerified) return;

    try {
      final result = await _authService.completeSignUpIfEmailVerified(
        name: widget.name,
      );

      if (result == 'Success') {
        _timer?.cancel();
        _cooldownTimer?.cancel();

        setState(() => _emailVerified = true);

        _showSuccessDialog();
      } else if (result.contains('No user is signed in')) {
        // User might have been signed out, redirect to login
        _timer?.cancel();
        _showErrorAndRedirect(
          'Session Expired',
          'Please login to complete verification.',
        );
      }
    } catch (e) {
      // Silent fail for periodic checks to avoid spamming user
      debugPrint('Verification check error: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('Email Verified!'),
        content: const Text('Your email has been successfully verified. You can now login to your account.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('Continue to Login'),
          ),
        ],
      ),
    );
  }

  void _showErrorAndRedirect(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red, size: 48),
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;

    setState(() => _loading = true);

    final res = await _authService.resendVerificationEmail();

    setState(() => _loading = false);

    if (res.contains('resent') || res.contains('sent')) {
      _startResendCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _startResendCooldown() {
    setState(() {
      _canResend = false;
      _resendCooldown = 60; // 60 seconds cooldown
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCooldown--;
      });

      if (_resendCooldown <= 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation, show dialog instead
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _showExitDialog,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email animation or icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread,
                  size: 80,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Check Your Email',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a verification email to\n'),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(text: '\n\nClick the link in the email to verify your account.'),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Verification status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Waiting for email verification...',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Resend button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                  onPressed: _canResend ? _resendEmail : null,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    _canResend
                        ? 'Resend Email'
                        : 'Resend in ${_resendCooldown}s',
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _goToLogin,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Login'),
                ),
              ),

              const SizedBox(height: 32),

              // Help text
              Text(
                'Check your spam folder if you don\'t see the email.\nThe verification link will expire in 24 hours.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Verification?'),
        content: const Text(
          'If you exit now, you\'ll need to verify your email later to complete your account setup. You can always come back and login once verified.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay Here'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _goToLogin();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}