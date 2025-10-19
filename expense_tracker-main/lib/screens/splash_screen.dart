import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // ADD THE DELAY RIGHT HERE - 3 seconds for testing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCE4EC), // Light pink
              Color(0xFFE1BEE7), // Light violet
              Color(0xFFD1C4E9), // Light purple
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A1B9A).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo - Inspired by Monet's water lilies
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6A1B9A), // Deep purple
                          Color(0xFFAB47BC), // Violet
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_rupee,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App Name - MONET
                  const Text(
                    'VAULT',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6A1B9A),
                      letterSpacing: 3.0,
                      fontFamily: 'Helvetica', // Clean, modern font
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tagline - Elegant and artistic
                  const Text(
                    'Your Financial Canvas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6A1B9A),
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loading indicator
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A1B9A)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}