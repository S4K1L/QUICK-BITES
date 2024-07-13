// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bites/Presentation/Drawer/admin_Drawer.dart'; // Assuming admin drawer exists

class TotalFinance extends StatefulWidget {
  const TotalFinance({super.key});

  @override
  _TotalFinanceState createState() => _TotalFinanceState();
}

class _TotalFinanceState extends State<TotalFinance> {
  double _totalChefEarnings = 0.0;
  double _totalRiderEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchEarnings();
  }

  Future<void> _fetchEarnings() async {
    double chefEarnings = await _getTotalChefEarnings();
    double riderEarnings = await _getTotalRiderEarnings();
    setState(() {
      _totalChefEarnings = chefEarnings;
      _totalRiderEarnings = riderEarnings;
    });
  }

  Future<double> _getTotalChefEarnings() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += data['subTotal'] ?? 0.0;
    }
    return total;
  }

  Future<double> _getTotalRiderEarnings() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('orders').get();
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += data['deliveryFee'] ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Finance Overview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(), // Assuming admin drawer exists
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Chef Earnings: RM ${_totalChefEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Rider Earnings: RM ${_totalRiderEarnings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
