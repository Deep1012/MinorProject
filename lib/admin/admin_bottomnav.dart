
import 'package:campuscrave/admin/admin_dashboard.dart';
import 'package:campuscrave/admin/admin_order.dart';
import 'package:campuscrave/admin/admin_home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';



class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late HomeAdmin adminHome;
  late AdminDashboard profile;
  late AdminOrders order;


  @override
  void initState() {
    adminHome = const HomeAdmin();
    order = const AdminOrders();
    profile = const AdminDashboard();
   
    pages = [adminHome, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
            items:const  [
              Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.list_alt_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.dashboard_rounded,
                color: Colors.white,
              ),
            
            ]),
        body: pages[currentTabIndex],
      ),
    );
  }
}
