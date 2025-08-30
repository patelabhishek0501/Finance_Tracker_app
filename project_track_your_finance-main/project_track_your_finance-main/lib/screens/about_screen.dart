import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extends UI behind AppBar
      appBar: AppBar(
        title: const Text('About Finance Tracker'),
        backgroundColor: Colors.transparent, // Transparent AppBar for premium look
        foregroundColor: Colors.black, // Black text color
        elevation: 0, // No shadow for sleek look
        toolbarHeight: 100, // Taller AppBar for better design
      ),
      body: Stack(
        children: [
          // 🔹 Background with pure white color and soft gradient effect
          Container(
            decoration: const BoxDecoration(
              color: Colors.white, // Premium white color background
            ),
          ),

          // 🔹 Content with padding
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 120), // Space for AppBar

                // 🔹 App Info Card with sleek design
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title of the Card with Premium typography
                        Text(
                          'Track Your Finance',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Version info with a soft, modern font
                        Text(
                          'Version: 1.0.0',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description text with refined, readable style
                        Text(
                          'This app helps you track your financial activities and manage your budget effectively. '
                          'You can add your income and expenses, categorize them, and get detailed reports to understand your financial status.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Developer Info with italics and stylish color
                        Text(
                          'Developed by: Abhishek & Team',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(), // Pushes animated text to the bottom

                // 🔹 Animated "A B H I S H E K" at the bottom
                Center(
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value * 0.5,
                        child: Text(
                          "A B H I S H E K".toLowerCase(),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: Colors.black,
                            fontFamily: 'Blueberry', // Use custom font
                            shadows: [
                              Shadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 20 * _fadeAnimation.value,
                              ),
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 25 * _fadeAnimation.value,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40), // Extra spacing at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
