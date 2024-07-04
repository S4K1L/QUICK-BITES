// ignore_for_file: unnecessary_const, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../Theme/const.dart';
import '../../../../../Widgets/styles.dart';
import '../../Details_Model/manu_model.dart';

class MenuDetails extends StatefulWidget {
  final MenuModel menu;

  const MenuDetails(this.menu, {super.key});

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  int _itemCount = 0;
  final Map<String, int> _quantities = {};
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    _user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void _increment(MenuModel menu) {
    setState(() {
      _itemCount++;
      _quantities[menu.docId] = _itemCount;
    });
  }

  void _decrement(MenuModel menu) {
    setState(() {
      if (_itemCount > 0) {
        _itemCount--;
        _quantities[menu.docId] = _itemCount;
      }
    });
  }

  void _addToCart(MenuModel menu) {
    setState(() {
      if (_quantities[menu.docId] != null && _quantities[menu.docId]! > 0) {
        _storeCheckoutData(menu, _quantities[menu.docId]!);
      } else {
        _quantities[menu.docId] = 1;
        _storeCheckoutData(menu, 1);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${menu.name} added to checkout!'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _storeCheckoutData(MenuModel menu, int quantity) async {
    if (_user != null) {
      final userUid = _user!.uid;
      try {
        await FirebaseFirestore.instance.collection('checkout').doc(userUid).set({
          'userUid': userUid,
          'menuId': menu.docId,
          'name': menu.name,
          'price': menu.price,
          'details': menu.details,
          'shopName': menu.shopName,
          'quantity': quantity,
          'imageUrl': menu.imageUrl,
          'moreImagesUrl': menu.moreImagesUrl,
        });
      } catch (e) {
        print('Error saving to Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding ${menu.name} to checkout.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _addToCart(menu),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[600],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.grey[200],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            menu.name,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Container(
                              width: 60,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.lightGreen,
                              ),
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      menu.shopStatus,
                                      style:  const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'RM ${menu.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreen[600],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline, color: Colors.lightGreen[600],),
                                onPressed: () => _decrement(menu),
                              ),
                              Text(
                                _itemCount.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[600],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline, color: Colors.lightGreen[600],),
                                onPressed: () => _increment(menu),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Details',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Shop Name: ${menu.shopName}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: kTextBlackColor.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        menu.details,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: kTextBlackColor.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
