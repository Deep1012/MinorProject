import 'package:campuscrave/authentication/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campuscrave/authentication/login_screen.dart'; // Make sure to import your login screen
import 'package:campuscrave/user/user_bottomnav.dart'; // Make sure to import your main screen or home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duration of the entire splash screen
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    // Define the animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller!.forward();

    // Navigate to the next screen after the animation completes
    Future.delayed(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNav()), // Replace with your main screen
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnboardScreen()), // Replace with your login screen
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: FadeTransition(
          opacity: _animation!,
          child: Image.asset(
            'images/SplashLOGO.png', // Path to your image asset
            width: 250, // Set the width of the logo
            height: 250, // Set the height of the logo
          ),
        ),
      ),
    );
  }
}
