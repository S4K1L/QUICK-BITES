// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Drawer/rider_Drawer.dart';

class RiderOrdersHistory extends StatefulWidget {
  const RiderOrdersHistory({super.key});

  @override
  _RiderOrdersHistoryState createState() => _RiderOrdersHistoryState();
}

class _RiderOrdersHistoryState extends State<RiderOrdersHistory> {
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
              "Orders History",
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
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/welcome.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: FutureBuilder<List<Order>>(
                future: _getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No orders available.'));
                  } else {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderItem(order);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Order>> _getOrders() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Delivered')
        .where('riderUid', isEqualTo: _currentUser.uid)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>).map((itemData) {
        final item = itemData as Map<String, dynamic>;
        return OrderItem(
          name: item['name'],
          price: item['price'],
          quantity: item['quantity'],
          imageUrl: item['imageUrl'],
        );
      }).toList();

      return Order(
        orderId: data['orderId'],
        userUid: data['userUid'],
        name: data['name'],
        deliveryFee: data['deliveryFee'],
        phone: data['phone'],
        location: data['location'],
        total: data['total'].toDouble(),
        status: data['status'],
        items: items,
      );
    }).toList();
  }

  Widget _buildOrderItem(Order order) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ORDER: ${order.orderId}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'RM ${order.deliveryFee}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String orderId;
  final String userUid;
  final String name;
  final double deliveryFee;
  final String phone;
  final String location;
  final double total;
  String status;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userUid,
    required this.name,
    required this.deliveryFee,
    required this.phone,
    required this.location,
    required this.total,
    required this.status,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
