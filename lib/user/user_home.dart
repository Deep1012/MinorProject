import 'package:campuscrave/user/user_foodDetail.dart';
import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;

  Stream? fooditemStream;
  String? name;

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
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        image: ds["Image"],
                        name: ds["Name"],
                        price: ds["Price"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20.0, bottom: 20),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds["Image"],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ds["Detail"],
                                  style: AppWidget.LightTextFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "\₹${ds["Price"]}",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        image: ds["Image"],
                        name: ds["Name"],
                        price: ds["Price"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds["Image"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            ds["Detail"],
                            style: AppWidget.LightTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "\₹${ds["Price"]}",
                            style: AppWidget.semiBoldTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                            "Welcome $name!!",
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
              const SizedBox(height: 20.0),
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
              Container(margin: const EdgeInsets.only(right: 20.0), child: showItem()),
              const SizedBox(height: 30.0),
              SizedBox(height: 270, child: allItems()),
              const SizedBox(height: 20.0),
              allItemsVertically(),
            ],
          ),
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
