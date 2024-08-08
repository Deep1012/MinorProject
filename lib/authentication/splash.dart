import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/authentication/welcome.dart';
import 'package:campuscrave/user/user_bottomnav.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      bool loggedIn = await SharedPreferenceHelper.isLoggedIn();
      print("logged in? $loggedIn");
      if (loggedIn) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNav()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
