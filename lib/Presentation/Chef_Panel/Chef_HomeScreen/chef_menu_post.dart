// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Theme/constant.dart';
import '../../Admin_Panel/Admin_HomePage/Search_button/custom_search.dart';
import '../../User_Panel/User_HomePage/Details_Model/manu_model.dart';
import '../../User_Panel/User_HomePage/post_details/details_screen.dart';
import 'edit_Screen.dart';

class ChefMenuPost extends StatefulWidget {
  const ChefMenuPost({super.key});

  @override
  _ChefMenuPostState createState() => _ChefMenuPostState();
}

class _ChefMenuPostState extends State<ChefMenuPost> {
  Stream<List<MenuModel>>? _menuStream;
  String _searchText = '';
  String? _shopName;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _shopName = await fetchUserShopName();
    if (_shopName != null) {
      setState(() {
        _menuStream = _fetchMenuFromFirebase(_shopName!);
      });
    }
  }

  Future<String?> fetchUserShopName() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      return null; // User not logged in
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc['shopName'];
      } else {
        return null; // User document doesn't exist
      }
    } catch (e) {
      print("Error fetching user shopName: $e");
      return null;
    }
  }

  void _onSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  Stream<List<MenuModel>> _fetchMenuFromFirebase(String shopName) {
    return FirebaseFirestore.instance
        .collection('menu')
        .where('shopName', isEqualTo: shopName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final moreImagesUrl = doc['moreImagesUrl'];
        final imageUrlList = moreImagesUrl is List ? moreImagesUrl : [moreImagesUrl];
        return MenuModel(
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          docId: doc.id,
          moreImagesUrl: imageUrlList.map((url) => url as String).toList(),
          isFav: doc['isFav'],
          details: doc['details'],
          shopName: doc['shopName'],
          shopStatus: doc['shopStatus'],
        );
      }).toList();
    });
  }

  Widget _buildMenu(BuildContext context, MenuModel menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(menu: menu),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      menu.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(0.9),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _deleteMenu(menu.docId);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 60,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(0.9),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMenuScreen(menu: menu),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 3),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'RM ${menu.price}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMenu(String docId) async {
    await FirebaseFirestore.instance.collection('menu').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(onSearch: _onSearch),
        const SizedBox(height: 20),
        flowerBuild(context),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: _menuStream == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : StreamBuilder<List<MenuModel>>(
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
                List<MenuModel>? campaigns = snapshot.data;
                if (campaigns != null && campaigns.isNotEmpty) {
                  List<MenuModel> filteredMenu = campaigns
                      .where((campaign) => _matchesSearchText(campaign))
                      .toList();
                  if (filteredMenu.isNotEmpty) {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of posts per line
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio:
                        0.95, // Adjust the aspect ratio as needed
                      ),
                      itemCount: filteredMenu.length,
                      itemBuilder: (context, index) {
                        return _buildMenu(
                            context, filteredMenu[index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No matching items found.'),
                    );
                  }
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
    );
  }

  Padding flowerBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: sWhiteColor),
        child: Row(
          children: [
            Image.asset(
              'assets/images/flower.png',
              width: 140,
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Free Delivery',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Order!',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _matchesSearchText(MenuModel campaign) {
    String searchText = _searchText.toLowerCase();
    List<String> searchTerms = searchText.split(' ');

    return searchTerms.every((term) =>
    campaign.name.toLowerCase().contains(term) ||
        campaign.price.toString().contains(term));
  }
}
