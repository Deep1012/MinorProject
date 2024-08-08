import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Image.asset(
          'images/nuvLogo.png', // Path to your image asset
          width: 150, // Set the width of the logo
          height: 150, // Set the height of the logo
        ),
      ),
    );
  }
}
