import 'package:campuscrave/database/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // To format dates

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({super.key});

  @override
  _PastOrdersPageState createState() => _PastOrdersPageState();
}

class _PastOrdersPageState extends State<PastOrdersPage> {
  late Stream<QuerySnapshot> completedOrdersStream;
  String? id;

  @override
  void initState() {
    super.initState();
    getthesharedpref(); // Fetch the user ID
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    print("Fetched User ID: $id"); // Debugging line

    if (id != null) {
      setState(() {
        completedOrdersStream = FirebaseFirestore.instance
            .collection("Users")
            .doc(id!) // Use the fetched user ID
            .collection("StoredOrders")
            .orderBy('date', descending: true) // Ensure latest dates come first
            .snapshots();
      });
    } else {
      print("User ID is null"); // Debugging line
      // Handle the case when ID is null if necessary
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Past Orders',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: completedOrdersStream,
        builder: (context, snapshot) {
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

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text('No past orders'),
            );
          }

          // Group orders by date
          Map<String, List<DocumentSnapshot>> groupedOrders = {};
          for (var doc in snapshot.data!.docs) {
            DateTime timestamp = (doc['date'] as Timestamp).toDate();
            String date = formatDate(timestamp);
            if (groupedOrders[date] == null) {
              groupedOrders[date] = [];
            }
            groupedOrders[date]!.add(doc);
          }

          List<String> sortedDates = groupedOrders.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              String date = sortedDates[index];
              List<DocumentSnapshot> orders = groupedOrders[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[700], thickness: 1.0), // Dark grey line above the date
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: const Color.fromARGB(255, 103, 160, 225),
                    child: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Divider(color: Colors.grey[700], thickness: 1.0), // Dark grey line below the date
                  ...orders.map((order) {
                    DateTime timestamp = (order['date'] as Timestamp).toDate();
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order['OrderID']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${order['itemName']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Quantity: ${order['quantity']}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Time: ${formatTime(timestamp)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Amount: ${order['total']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
