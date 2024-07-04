// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Drawer/rider_Drawer.dart';

import '../../../Theme/const.dart';

class RiderEarning extends StatefulWidget {
  const RiderEarning({super.key});

  @override
  _RiderEarningState createState() => _RiderEarningState();
}

class _RiderEarningState extends State<RiderEarning> {
  late User _currentUser;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((_) => setState(() {
      _isLoading = false;
    }));
  }

  Future<void> _getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    } else {
      setState(() {
        _errorMessage = 'User not logged in.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "Total Earnings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delivery_dining,
                color: Colors.red,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const RiderDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: FutureBuilder<double>(
          future: _getTotalDeliveryEarnings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No earnings available.'));
            } else {
              final totalEarnings = snapshot.data!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset('assets/images/rider_earning.png'),
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
                              'RM ${totalEarnings.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              'Total Earnings',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue[300]),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: kTextWhiteColor,
                                  size: 32,
                                ),
                                Spacer(),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                      color: kTextWhiteColor,
                                      fontSize: 22),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<double> _getTotalDeliveryEarnings() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Delivered')
        .where('riderUid', isEqualTo: _currentUser.uid)
        .get();

    double totalEarnings = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final deliveryFee = data['deliveryFee'] as double;
      totalEarnings += deliveryFee;
    }

    return totalEarnings;
  }
}
