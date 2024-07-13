// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Theme/constant.dart';
import '../../../../Theme/const.dart';
import '../../../Drawer/user_Drawer.dart';
import '../Details_Model/manu_model.dart';
import 'chekout.dart';

class FavoriteMenuPage extends StatefulWidget {
  const FavoriteMenuPage({super.key});

  @override
  _FavoriteMenuPageState createState() => _FavoriteMenuPageState();
}

class _FavoriteMenuPageState extends State<FavoriteMenuPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late Stream<List<MenuModel>> _menuStream;
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _menuStream = _fetchMenuFromFirebase();
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOut(quantities: _quantities),
      ),
    );
  }

  Stream<List<MenuModel>> _fetchMenuFromFirebase() {
    if (_user == null) {
      // User not logged in, handle appropriately
      return const Stream.empty();
    }
    final userUid = _user!.uid;
    return FirebaseFirestore.instance
        .collection('favorite')
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
          isFav: true,
          details: doc['details'],
          shopName: doc['shopName'],
          shopStatus: doc['shopStatus'],
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

  void _addToCheckout(MenuModel menu) {
    setState(() {
      if (_quantities[menu.docId] != null && _quantities[menu.docId]! > 0) {
        // Item has been added to the cart with a positive quantity
        _storeCheckoutData(menu, _quantities[menu.docId]!);
      } else {
        // Ensure that an item added to the cart has a quantity of at least 1
        _quantities[menu.docId] = 1;
        _storeCheckoutData(menu, 1);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text('${menu.name} added to checkout!',style: const TextStyle(color: Colors.red),),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _storeCheckoutData(MenuModel menu, int quantity) async {
    if (_user != null) {
      final userUid = _user!.uid;
      final docId = FirebaseFirestore.instance.collection('checkout').doc().id;
      await FirebaseFirestore.instance.collection('checkout').doc(docId).set({
        'userUid': userUid,
        'menuId': menu.docId,
        'name': menu.name,
        'price': menu.price,
        'details': menu.details,
        'shopStatus': menu.shopStatus,
        'shopName': menu.shopName,
        'quantity': quantity,
        'imageUrl': menu.imageUrl,
        'moreImagesUrl': menu.moreImagesUrl,
      });
    }
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  menu.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.purpleAccent,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.remove, size: 16, color: sWhiteColor),
                              onPressed: () => _decrement(menu),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.purpleAccent,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.add, size: 16, color: sWhiteColor),
                              onPressed: () => _increment(menu),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Add some spacing between the row and the button
                  ElevatedButton(
                    onPressed: () => _addToCheckout(menu),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
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
                  const SizedBox(height: 10), // Add some spacing between the row and the button
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            Text(
              'Favorite List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.red[500],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                _navigateToCart();
              },
              icon: Icon(Icons.shopping_cart, color: Colors.red[500], size: 28),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: const UserDrawer(),
      bottomNavigationBar: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.purpleAccent),
        child: TextButton(
            onPressed: () {
              _navigateToCart();
            },
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Icon(
                  Icons.shopping_cart,
                  color: kTextWhiteColor,
                  size: 32,
                ),
                SizedBox(width: 10,),
                Text(
                  'Checkout',
                  style: TextStyle(
                      color: kTextWhiteColor,
                      fontSize: 22),
                ),
                Spacer(),
              ],
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              flowerBuild(context),
              Expanded(
                child: StreamBuilder<List<MenuModel>>(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding flowerBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        height: MediaQuery.of(context).size.height / 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: sWhiteColor,
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/flower.png',
              width: MediaQuery.of(context).size.width/5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
