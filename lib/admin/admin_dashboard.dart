import 'package:campuscrave/admin/admin_completedOrders.dart';
import 'package:campuscrave/authentication/welcome.dart';
import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalFoodItems = 0;
  int totalUsers = 0;

  @override
  void initState() {
    super.initState();
    // Call methods to fetch data
    _calculateTotalFoodItems();
    _fetchTotalUsers();
  }

Future<void> _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> _calculateTotalFoodItems() async {
    int count = 0;
    // Fetch food items from each category and sum up the counts
    for (String category in ['Pizza', 'Burger', 'Ice-cream', 'Salad']) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Food").doc("Category").collection(category).get();
      count += snapshot.size;
    }
    setState(() {
      totalFoodItems = count;
    });
  }

    void _logout() async {
    await SharedPreferenceHelper.setAdminLoggedIn(false); // Set login state to false
    Get.offAll(() => const WelcomeScreen()); // Navigate to LoginScreen
  }

  Future<void> _fetchTotalUsers() async {
    int count = await DatabaseMethods().getTotalUsers();
    setState(() {
      totalUsers = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
         Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
            automaticallyImplyLeading: false,

            actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showConfirmationDialog(
                context,
                'Log Out',
                'Are you sure you want to log out?',
                _logout,
              );
              
            },
          ),
        ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.only(top: 12.0),
                    itemCount: _dashboardItem.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 230,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return _buildGridItem(
                        title: _dashboardItem[index]['title'],
                        subtitle: _dashboardItem[index]['subtitle'],
                        icon: _dashboardItem[index]['icon'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildGridItem({required String title, required String subtitle, required IconData icon}) {
    if (title == "Products") {
      return _buildProductsGridItem(title, subtitle, icon);
    } else if (title == "Users") {
      return _buildUsersGridItem(title, subtitle, icon);
    } else {
      return _buildDefaultGridItem(title, subtitle, icon);
    }
  }

  Widget _buildProductsGridItem(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 10.0,
      child: Material(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Handle the tap event here
            print('Tapped item: $title');
            // You can navigate to a new screen or perform any other action
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height:20.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total: $totalFoodItems",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsersGridItem(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 10.0,
      child: Material(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Handle the tap event here
            print('Tapped item: $title');
            // You can navigate to a new screen or perform any other action
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 20.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total: $totalUsers",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultGridItem(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 10.0,
      child: Material(
        
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (title == "Completed") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CompletedOrdersPage()));
            }

            // Handle the tap event here
            print('Tapped item: $title');
            // You can navigate to a new screen or perform any other action
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 20.0),
                Text(
                  title,
                  
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _dashboardItem = [
    {
      "title": "Users",
      "subtitle": "Total Users",
      "icon": Icons.people,
    },
    {
      "title": "Categories",
      "subtitle": "4",
      "icon": Icons.category,
    },
    {
      "title": "Products",
      "subtitle": "Total Food Items",
      "icon": Icons.shopping_cart,
    },
    {
      "title": "Earnings",
      "subtitle": "\$600",
      "icon": Icons.attach_money,
    },
    {
      "title": "Completed",
      "subtitle": "",
      "icon": Icons.food_bank,
    },
  ];
}
