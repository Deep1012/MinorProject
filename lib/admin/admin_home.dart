import 'package:flutter/material.dart';
import 'package:campuscrave/admin/admin_addFood.dart';
import 'package:campuscrave/admin/admin_menu.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60.0),
                  const Padding(
                    padding:  EdgeInsets.only(left: 20.0, top: 20),
                    child: Text(
                      "Navrachana Canteen",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 10),
                    child: Image.asset(
                      "images/nuvLogo.png",
                      height: 60,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90.0),
              buildMenuCard(
                image: "images/add_food.jpeg",
                title: "+ Add Food Items",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFood()),
                  );
                },
              ),
              const SizedBox(height: 40.0),
              buildMenuCard(
                image: "images/menu.jpg",
                title: "View Menu Card",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuViewPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard({
    required String image,
    required String title,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: [
              Image.asset(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
