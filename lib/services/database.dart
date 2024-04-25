import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

   Future<List<DocumentSnapshot>> getAllUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getFoodOrders() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('foodOrders').get();
    return querySnapshot.docs;
  }


  Future<void> addUserDetail(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .set(userInfoMap);
    } catch (e) {
      print("Error adding user details: $e");
    }
  }

  Future<void> addFoodItem(
      Map<String, dynamic> userInfoMap, String name) async {
    try {
      await FirebaseFirestore.instance.collection(name).add(userInfoMap);
    } catch (e) {
      print("Error adding food item: $e");
    }
  }

  Future<Stream<QuerySnapshot>?> getFoodItem(String name) async {
    try {
      return FirebaseFirestore.instance.collection(name).snapshots();
    } catch (e) {
      print("Error fetching food items: $e");
      return null;
    }
  }

  Future<void> addFoodToCart(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('Cart')
          .add(userInfoMap);
    } catch (e) {
      print("Error adding food to cart: $e");
    }
  }

  Future<Stream<QuerySnapshot>?> getFoodCart(String id) async {
    try {
      return FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .collection("Cart")
          .snapshots();
    } catch (e) {
      print("Error fetching food cart: $e");
      return null;
    }
  }

  Future<int> getTotalUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      return querySnapshot.size;
    } catch (e) {
      print("Error fetching total users: $e");
      return 0;
    }
  }

  Future<void> placeOrder(String userId, String orderNumber, int totalAmount,
      List<Map<String, dynamic>> items) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderNumber)
          .set({
        'userId': userId,
        'totalAmount': totalAmount,
        'items': items, // Add items array to the order document
        // Add more order details as needed
      });
    } catch (e) {
      print('Error placing order: $e');
      // Handle error accordingly
    }
  }
}