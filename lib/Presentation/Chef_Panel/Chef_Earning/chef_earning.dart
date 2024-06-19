import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Drawer/chef_Drawer.dart';
import 'package:quick_bites/Theme/const.dart';

class ChefEarnings extends StatefulWidget {
  const ChefEarnings({super.key});

  @override
  _ChefEarningsState createState() => _ChefEarningsState();
}

class _ChefEarningsState extends State<ChefEarnings> {
  double _totalEarnings = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((_) => _fetchChefEarnings());
  }

  Future<void> _getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      _listenForDeliveredOrders();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in.';
      });
    }
  }

  Future<void> _fetchChefEarnings() async {
    if (_currentUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in.';
      });
      return;
    }

    try {
      final earningsRef = FirebaseFirestore.instance.collection('chefEarnings').doc(_currentUser.uid);
      final snapshot = await earningsRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _totalEarnings = data['total'] ?? 0.0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No earnings data found.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching earnings: $e';
      });
    }
  }

  void _listenForDeliveredOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Delivered')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        _updateChefEarnings(doc);
      }
    });
  }

  Future<void> _updateChefEarnings(DocumentSnapshot orderDoc) async {
    final orderData = orderDoc.data() as Map<String, dynamic>;
    final chefId = orderData['chefId'];
    if (chefId == _currentUser.uid) {
      double orderTotal = 0.0;
      final items = (orderData['items'] as List<dynamic>).map((itemData) {
        final item = itemData as Map<String, dynamic>;
        return {
          'price': item['price'],
          'quantity': item['quantity'],
        };
      }).toList();

      for (var item in items) {
        orderTotal += item['price'] * item['quantity'];
      }

      try {
        final earningsRef = FirebaseFirestore.instance.collection('chefEarnings').doc(_currentUser.uid);
        final snapshot = await earningsRef.get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final currentEarnings = data['total'] ?? 0.0;
          final newEarnings = currentEarnings + orderTotal;
          await earningsRef.update({'total': newEarnings});
          setState(() {
            _totalEarnings = newEarnings;
          });
        } else {
          await earningsRef.set({'total': orderTotal});
          setState(() {
            _totalEarnings = orderTotal;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error updating earnings: $e';
        });
      }
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
              "Chef Earnings",
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
                Icons.fastfood_sharp,
                color: Colors.red,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const ChefDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/chef_earning.png'),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    )
                  else
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
                            'RM ${_totalEarnings.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'Total Earnings',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                  Container(
                    width: 140,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green[300]),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back, color: kTextWhiteColor, size: 32,),
                            Spacer(),
                            Text('Back', style: TextStyle(color: kTextWhiteColor, fontSize: 22),),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
