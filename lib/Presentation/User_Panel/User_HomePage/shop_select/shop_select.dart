// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user_Home_Screen.dart';

class ShopSelectionPopup extends StatefulWidget {
  const ShopSelectionPopup({super.key});

  @override
  _ShopSelectionPopupState createState() => _ShopSelectionPopupState();
}

class _ShopSelectionPopupState extends State<ShopSelectionPopup> {
  String _selectedShop = '';
  List<String> _shopNames = [];

  @override
  void initState() {
    super.initState();
    _fetchShopsFromFirebase();
  }

  void _fetchShopsFromFirebase() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('menu').get();
    setState(() {
      _shopNames = querySnapshot.docs.map((doc) => doc['shopName'] as String).toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/welcome.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: const Text('Select a Shop'),
              content: DropdownButton<String>(
                value: _selectedShop.isEmpty ? null : _selectedShop,
                items: _shopNames.map((String shopName) {
                  return DropdownMenuItem<String>(
                    value: shopName,
                    child: Text(shopName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedShop = newValue!;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Select'),
                  onPressed: () {
                    if (_selectedShop.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserHomeScreen(shopName: _selectedShop)),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
