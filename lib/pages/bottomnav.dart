import 'package:campuscrave/pages/home.dart';
import 'package:campuscrave/pages/order.dart';
import 'package:campuscrave/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;

  @override
  void initState() {
    homepage = Home();
    order = Order();
    profile = Profile();

    pages = [homepage, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
            height: 65,
            backgroundColor: Colors.white,
            color: Colors.black,
            animationDuration: const Duration(milliseconds: 500),
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: const [
              Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              Icon(
                Icons.person_outline,
                color: Colors.white,
              )
            ]),
        body: pages[currentTabIndex],
      ),
    );
  }
}
