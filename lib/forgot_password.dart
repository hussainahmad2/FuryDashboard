// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _success;
  bool _emailSent = false;
  int _resendCooldown = 0;

  Future<void> _sendResetEmail() async {
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });
    final email = _emailController.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _success = 'A password reset link has been sent to your email.';
        _emailSent = true;
        _resendCooldown = 10; // 10 seconds cooldown
      });
      // Optionally auto-navigate to login after 5 seconds:
      // Future.delayed(Duration(seconds: 5), () {
      //   if (mounted) {
      //     Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => const LoginScreen()),
      //     );
      //   }
      // });
      // Start cooldown timer
      Future.doWhile(() async {
        if (_resendCooldown > 0) {
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) setState(() => _resendCooldown--);
          return true;
        }
        return false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _error = 'No user found for that email.';
        } else {
          _error = e.message;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final cardWidth = isSmall ? double.infinity : 350.0;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/login.png', fit: BoxFit.cover),
          ),
          SizedBox.expand(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: cardWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 16 : 28,
                    vertical: isSmall ? 22 : 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: Colors.white10, width: 1.2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
                        style: GoogleFonts.montserrat(
                          fontSize: isSmall ? 26 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Icon(
                        Icons.lock_reset,
                        size: isSmall ? 60 : 72,
                        color: Colors.blue[300],
                      ),
                      const SizedBox(height: 28),
                      _DarkTextField(
                        controller: _emailController,
                        hint: 'Enter your email address',
                        icon: Icons.email_outlined,
                        obscure: false,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Colors.red[200],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (_success != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _success!,
                          style: TextStyle(
                            color: Colors.green[200],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          onPressed:
                              _loading || _resendCooldown > 0
                                  ? null
                                  : _sendResetEmail,
                          child:
                              _loading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Text(
                                    _emailSent
                                        ? (_resendCooldown > 0
                                            ? 'Resend Email ($_resendCooldown)'
                                            : 'Resend Email')
                                        : 'Send Reset Link',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmall ? 16 : 18,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                        ),
                      ),
                      if (_emailSent) ...[
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Back to Sign In',
                            style: GoogleFonts.montserrat(
                              color: Colors.blue[200],
                              fontSize: isSmall ? 14 : 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;
  const _DarkTextField({
    required this.hint,
    required this.icon,
    required this.obscure,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[900]?.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue[200]),
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            color: Colors.blueGrey[200],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon:
              obscure
                  ? Icon(Icons.visibility, color: Colors.blueGrey[400])
                  : null,
        ),
      ),
    );
  }
}
