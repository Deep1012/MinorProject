import 'package:campuscrave/admin/Adminside.dart';
import 'package:campuscrave/admin/add_food.dart';
import 'package:campuscrave/admin/admin_bottomnav.dart';

import 'package:campuscrave/admin/display.dart';
import 'package:campuscrave/admin/display.dart';
import 'package:campuscrave/admin/home_admin.dart';
import 'package:campuscrave/admin/menu_view.dart';
import 'package:campuscrave/admin/temp.dart';
import 'package:campuscrave/firebase_options.dart';
import 'package:campuscrave/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Side',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 199, 71, 71)),
        useMaterial3: true,
      ),
      home: AdminBottomNav(),
    );
  }
}
