// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Theme/constant.dart';
import '../../Admin_Panel/Admin_HomePage/Search_button/custom_search.dart';
import '../../User_Panel/User_HomePage/Details_Model/manu_model.dart';
import '../../User_Panel/User_HomePage/post_details/details_screen.dart';

class AdminMenuPost extends StatefulWidget {
  const AdminMenuPost({super.key});

  @override
  _AdminMenuPostState createState() => _AdminMenuPostState();
}

class _AdminMenuPostState extends State<AdminMenuPost> {
  late StreamSubscription<List<MenuModel>> _subscription;
  late Stream<List<MenuModel>> _menuStream;
  String _searchText = '';
  final Map<String, bool> _favorites = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _menuStream = _fetchMenuFromFirebase();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  Stream<List<MenuModel>> _fetchMenuFromFirebase() {
    return FirebaseFirestore.instance.collection('menu').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final moreImagesUrl = doc['moreImagesUrl'];
        final imageUrlList = moreImagesUrl is List ? moreImagesUrl : [moreImagesUrl];

        bool isFav = false;
        if (_user != null) {
          FirebaseFirestore.instance.collection('card').where('userUid', isEqualTo: _user!.uid).where('docId', isEqualTo: doc.id).get().then((value) {
            if (value.docs.isNotEmpty) {
              setState(() {
                _favorites[doc.id] = true;
              });
            }
          });
        }

        return MenuModel(
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          docId: doc.id,
          moreImagesUrl: imageUrlList.map((url) => url as String).toList(),
          isFav: isFav,
          details: doc['details'],
          shopName: doc['shopName'],
          shopStatus: doc['shopStatus'],
        );
      }).toList();
    });
  }

  Widget _buildMenu(BuildContext context, MenuModel menu) {
    bool isFavorite = _favorites[menu.docId] ?? false;
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
                        color: Colors.purple.withOpacity(0.9),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          _toggleFavorite(menu);
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

  void _toggleFavorite(MenuModel menu) {
    if (_user == null) {
      // User not logged in, handle appropriately
      return;
    }
    final userUid = _user!.uid;

    setState(() {
      _favorites[menu.docId] = !(_favorites[menu.docId] ?? false);
    });

    if (_favorites[menu.docId]!) {
      FirebaseFirestore.instance.collection('cart').add({
        'imageUrl': menu.imageUrl,
        'name': menu.name,
        'price': menu.price,
        'docId': menu.docId,
        'moreImagesUrl': menu.moreImagesUrl,
        'userUid': userUid,
      });
    } else {
      FirebaseFirestore.instance
          .collection('cart')
          .where('docId', isEqualTo: menu.docId)
          .where('userUid', isEqualTo: userUid)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
    }
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
                        return _buildMenu(context, filteredMenu[index]);
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

