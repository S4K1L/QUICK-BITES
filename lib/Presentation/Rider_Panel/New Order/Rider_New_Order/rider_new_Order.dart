// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Drawer/runner_Drawer.dart';
import '../../../../Theme/const.dart';

class RunnerNewOrders extends StatefulWidget {
  const RunnerNewOrders({super.key});

  @override
  _RunnerNewOrdersState createState() => _RunnerNewOrdersState();
}

class _RunnerNewOrdersState extends State<RunnerNewOrders> {
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
              "New Orders",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delivery_dining,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const RunnerDrawer(),
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
        .where('status', whereIn: ['Ready to Delivery','On the Way'])
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>).map((itemData) {
        final item = itemData as Map<String, dynamic>;
        return OrderItem(
          name: item['name'],
          price: item['price'].toDouble(),
          quantity: item['quantity'],
          imageUrl: item['imageUrl'],
        );
      }).toList();

      return Order(
        orderId: data['orderId'],
        userUid: data['userUid'],
        name: data['name'],
        phone: data['phone'],
        deliveryFee: (data['deliveryFee'] as num).toDouble(),
        location: data['location'],
        total: (data['total'] as num).toDouble(),
        status: data['status'],
        riderUid: data['riderUid'],
        items: items,
      );
    }).where((order) => order.status == 'Ready to Delivery' || (order.status == 'On the Way' && order.riderUid == _currentUser.uid)).toList();
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER: ${order.orderId}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(item.name,style: const TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${item.quantity}'),
                      const SizedBox(height: 5),
                      Text(
                        'RM ${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Place: ${order.location}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Delivery Fee: ${order.deliveryFee}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue,
                ),
                child: DropdownButton<String>(
                  value: order.status,
                  items: <String>['Ready to Delivery', 'On the Way', 'Delivered',]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        order.status = newValue;
                      });
                      _updateOrderStatus(order.orderId, newValue, order.riderUid);
                    }
                  },
                  underline: const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String status, String? riderUid) async {
    final updates = <String, dynamic>{'status': status};

    if (status == 'On the Way') {
      updates['riderUid'] = _currentUser.uid;
    } else if (status == 'Delivered') {
      updates['riderUid'] = _currentUser.uid;
      final orderRef = FirebaseFirestore.instance.collection('orders').doc(orderId);
      final snapshot = await orderRef.get();

      if (snapshot.exists) {
        final orderData = snapshot.data() as Map<String, dynamic>;
        final items = (orderData['items'] as List<dynamic>).map((item) {
          final itemData = Map<String, dynamic>.from(item as Map<dynamic, dynamic>);
          itemData['riderUid'] = _currentUser.uid;
          return itemData;
        }).toList();
        updates['items'] = items;
      }
    }

    await FirebaseFirestore.instance.collection('orders').doc(orderId).update(updates);
  }
}

class Order {
  final String orderId;
  final String userUid;
  final String name;
  final String phone;
  final double deliveryFee;
  final String location;
  final double total;
  String status;
  final String? riderUid;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userUid,
    required this.name,
    required this.phone,
    required this.deliveryFee,
    required this.location,
    required this.total,
    required this.status,
    this.riderUid,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}
