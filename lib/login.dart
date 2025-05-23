// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Fury/fury_main_home.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required.';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+ ?$');
    if (!emailRegex.hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  Future<void> _signIn() async {
    setState(() {
      _error = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    if (emailError != null) {
      setState(() {
        _error = emailError;
      });
      return;
    }
    if (passwordError != null) {
      setState(() {
        _error = passwordError;
      });
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FuryHome()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
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
          // Blurred dark background image
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
                        'Sign In',
                        style: GoogleFonts.montserrat(
                          fontSize: isSmall ? 28 : 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueGrey.shade900,
                              Colors.blueGrey.shade700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Icon(
                          Icons.account_circle,
                          size: isSmall ? 64 : 80,
                          color: Colors.blue[300],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _DarkTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.email_outlined,
                        obscure: false,
                      ),
                      const SizedBox(height: 16),
                      _DarkTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscure: true,
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
                          onPressed: _loading ? null : _signIn,
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
                                    'Sign In',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmall ? 18 : 20,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.montserrat(
                            color: Colors.blue[200],
                            fontSize: isSmall ? 14 : 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: GoogleFonts.montserrat(
                            color: Colors.blue[200],
                            fontSize: isSmall ? 14 : 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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
