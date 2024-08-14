import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campuscrave/constants/colors.dart';
import 'package:campuscrave/database/firebase_options.dart';
import 'package:campuscrave/authentication/authentication_repository.dart';
import 'package:campuscrave/authentication/splash_screen.dart'; // Import your splash screen
import 'package:campuscrave/authentication/onboarding.dart';
import 'package:campuscrave/user/user_bottomnav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  Get.put(AuthenticationRepository());

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
    // Wait for 5 seconds before navigating
    await Future.delayed(Duration(seconds: 3));

    // Navigate to the authentication wrapper after the delay
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AuthenticationWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(); // Display the splash screen
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceStorage = GetStorage();
    bool isFirstTime = deviceStorage.read('helo') ?? true;

    if (isFirstTime) {
      return OnboardScreen();
    } else {
      return BottomNav();
    }
  }
}
