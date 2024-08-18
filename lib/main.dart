import 'package:campuscrave/user/user_bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campuscrave/database/firebase_options.dart';
import 'package:campuscrave/authentication/splash_screen.dart'; // Import your splash screen
import 'package:campuscrave/authentication/onboarding.dart';
import 'package:campuscrave/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Wait for 3 seconds before navigating
    await Future.delayed(Duration(seconds: 3));

    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    // Navigate to the appropriate screen
    if (user != null) {
      // User is logged in
      Get.off(() => BottomNav()); // Change this to your main screen if needed
    } else {
      // User is not logged in
      Get.off(() => OnboardScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(); // Display the splash screen
  }
}
