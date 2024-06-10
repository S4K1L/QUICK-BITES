import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Theme/constant.dart';
import 'Details_Model/details_Screen.dart';
import 'manu_model.dart';

class MenuPost extends StatefulWidget {
  const MenuPost({super.key});

  @override
  _MenuPostState createState() => _MenuPostState();
}

class _MenuPostState extends State<MenuPost> {
  late StreamSubscription<List<MenuModel>> _subscription;
  late Stream<List<MenuModel>> _menuStream;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _menuStream = _fetchCampaignsFromFirebase();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Stream<List<MenuModel>> _fetchCampaignsFromFirebase() {
    return FirebaseFirestore.instance.collection('food').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final moreImagesUrl = doc['moreImagesUrl'];
        final imageUrlList = moreImagesUrl is List ? moreImagesUrl : [moreImagesUrl]; // Ensure it's always a list

        return MenuModel(
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          calories: doc['calories'],
          sugar: doc['sugar'],
          details: doc['details'],
          docId: doc.id,
          moreImagesUrl: imageUrlList.map((url) => url as String).toList(),
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
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: sSecondaryColor
                ),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,top: 3),
                    child: Text(
                      menu.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: sOrangeColor
                  ),
                  child: Center(
                    child: Expanded(
                      child: Text(
                        '${menu.calories} Calories',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  List<MenuModel> filteredCampaigns = campaigns.where((campaign) => _matchesSearchText(campaign)).toList();
                  if (filteredCampaigns.isNotEmpty) {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of posts per line
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 0.9, // Adjust the aspect ratio as needed
                      ),
                      itemCount: filteredCampaigns.length,
                      itemBuilder: (context, index) {
                        return _buildMenu(context, filteredCampaigns[index]);
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

  bool _matchesSearchText(MenuModel campaign) {
    String searchText = _searchText.toLowerCase();
    List<String> searchTerms = searchText.split(' ');

    return searchTerms.every((term) =>
    campaign.name.toLowerCase().contains(term) ||
        campaign.calories.toLowerCase().contains(term)
    );
  }
}
