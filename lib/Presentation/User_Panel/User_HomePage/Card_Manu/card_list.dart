import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Theme/constant.dart';
import '../../../Admin_Panel/Admin_HomePage/manu_model.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late Stream<List<MenuModel>> _menuStream;
  Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _menuStream = _fetchMenuFromFirebase();
  }

  Stream<List<MenuModel>> _fetchMenuFromFirebase() {
    if (_user == null) {
      // User not logged in, handle appropriately
      return Stream.empty();
    }
    final userUid = _user!.uid;
    return FirebaseFirestore.instance
        .collection('card')
        .where('userUid', isEqualTo: userUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final moreImagesUrl = doc['moreImagesUrl'];
        final imageUrlList = moreImagesUrl is List
            ? moreImagesUrl
            : [moreImagesUrl]; // Ensure it's always a list

        return MenuModel(
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          docId: doc.id,
          moreImagesUrl: imageUrlList.map((url) => url as String).toList(),
          isFav: true, // Since it's already in the card collection
        );
      }).toList();
    });
  }

  void _increment(MenuModel menu) {
    setState(() {
      _quantities[menu.docId] = (_quantities[menu.docId] ?? 0) + 1;
    });
  }

  void _decrement(MenuModel menu) {
    setState(() {
      if ((_quantities[menu.docId] ?? 0) > 0) {
        _quantities[menu.docId] = (_quantities[menu.docId]! - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MenuModel>>(
      stream: _menuStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<MenuModel>? menuItems = snapshot.data;
          if (menuItems != null && menuItems.isNotEmpty) {
            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(context, menuItems[index]);
              },
            );
          } else {
            return const Center(
              child: Text('No items available.'),
            );
          }
        }
      },
    );
  }
  Widget _buildMenuItem(BuildContext context, MenuModel menu) {
    int quantity = _quantities[menu.docId] ?? 0;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                menu.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'RM ${menu.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple[300],
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.remove, size: 16),
                            onPressed: () => _decrement(menu),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('$quantity'),
                      const SizedBox(width: 10),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple[300],
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.add, size: 16),
                            onPressed: () => _increment(menu),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Add some spacing between the row and the button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: sWhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
