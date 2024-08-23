import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/widgets/userhome_vertical.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;
  bool? isOpen; // Changed to nullable to handle loading state
  Stream? fooditemStream;
  String? name;

  @override
  void initState() {
    super.initState();
    checkCanteenStatus();
    ontheload();
  }

  Future<void> checkCanteenStatus() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('canteen').doc('status').get();
    setState(() {
      isOpen = snapshot['isOpen'];
    });
  }

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    fooditemStream = await DatabaseMethods().getDisplayedFoodItems("Pizza");
    getthesharedpref();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isOpen == null
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching `isOpen`
          : isOpen!
              ? SingleChildScrollView(
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    margin: const EdgeInsets.only(top: 50.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            name == null
                                ? const Center(child: CircularProgressIndicator())
                                : Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Text(
                                      "Welcome!!",
                                      style: AppWidget.boldTextFieldStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                            Container(
                              margin: const EdgeInsets.only(right: 30.0, top: 20),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                "images/nuvLogo.png",
                                height: 60,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          "NUV Canteen",
                          style: AppWidget.HeadTextFieldStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Order beforehand to skip the wait!!",
                          style: AppWidget.LightTextFieldStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20.0),
                        showItem(),
                        const SizedBox(height: 20.0),
                        Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                            child: Image.asset("images/home_ordernow.png"),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: userhome_vertical(fooditemStream: fooditemStream),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Image.asset(
                        "images/sorry.gif",
                        height: 300,
                        width: 300,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(height: 20.0), // Add spacing between the image and the text
                      const Text(
                        "Sorry, Canteen is closed.",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center, // Center the text within its own box
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        foodCategoryItem("Burger", "images/burger.png", burger),
        foodCategoryItem("Salad", "images/salad.png", salad),
        foodCategoryItem("Ice-cream", "images/ice-cream.png", icecream),
        foodCategoryItem("Pizza", "images/pizza.png", pizza),
      ],
    );
  }

  Widget foodCategoryItem(String category, String asset, bool isSelected) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          icecream = category == "Ice-cream";
          pizza = category == "Pizza";
          salad = category == "Salad";
          burger = category == "Burger";
        });
        fooditemStream = await DatabaseMethods().getDisplayedFoodItems(category);
        setState(() {});
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            asset,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
