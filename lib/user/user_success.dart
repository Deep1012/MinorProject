import 'package:campuscrave/user/user_bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Success extends StatefulWidget {
  final String userId;
  final String orderCode; // Receive the user ID as a parameter

  const Success({super.key, required this.userId, required this.orderCode});

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  late Stream<QuerySnapshot> ordersStream;
  late String orderCode;

  @override
  void initState() {
    super.initState();
    // Query the FinalOrders collection based on the user's ID
    ordersStream = FirebaseFirestore.instance.collection("FinalOrders").where('userId', isEqualTo: widget.userId).snapshots();
    orderCode = widget.orderCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: ordersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders available.'),
            );
          }

          // Only one order is expected, so no need for ListView.builder
          DocumentSnapshot order = snapshot.data!.docs[0];

          //String orderCode = order['OrderID'];

          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Section 1

            const Image(image: AssetImage("images/successful.gif"), width: 300, height: 350),

            //sectiion 2
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Order Placed!",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 0),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Order ID: $orderCode',
                style: const TextStyle(fontSize: 35),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "\t\t\tYour order is being prepared!!! \n\t\t\t\tShow your OrderID at counter",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                },
                child: const Text(
                  "Return to Home Page",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
