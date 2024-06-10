import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../Theme/constant.dart';
import '../manu_model.dart';
import 'carousel_images.dart';
import 'menu_details.dart';

class DetailsScreen extends StatefulWidget {
  final MenuModel menu;

  const DetailsScreen({super.key, required this.menu});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? selectedMeal;

  void _openMealSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text('Breakfast'),
                onTap: () {
                  setState(() {
                    selectedMeal = 'Breakfast';
                  });
                  _uploadData(selectedMeal);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Lunch'),
                onTap: () {
                  setState(() {
                    selectedMeal = 'Lunch';
                  });
                  _uploadData(selectedMeal);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dinner'),
                onTap: () {
                  setState(() {
                    selectedMeal = 'Dinner';
                  });
                  _uploadData(selectedMeal);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadData(String? mealType) async {
    try {
      // Accessing the Firebase Authentication instance
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        // Accessing the Firebase Firestore instance
        final firestoreInstance = FirebaseFirestore.instance;

        // Adding data to the meal time collection under the user's UID
        await firestoreInstance
            .collection('meal_time')
            .doc(user.uid)
            .collection(mealType!)
            .add({
          'food_name': widget.menu.name,
          'calories': widget.menu.calories,
          'sugar': widget.menu.sugar,
        });
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data uploaded successfully to $mealType meal time!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error uploading data: $e');
      // Show an error message if data upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: sBlackColor,
          iconSize: 12,
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              CarouselImages(widget.menu.moreImagesUrl),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          MenuDetails(widget.menu),
          Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: sSecondaryColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        _openMealSelectionBottomSheet(context); // Pass context here
                      },
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          fontSize: 16,
                          color: sBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 80,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: sSecondaryColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                      },
                      child: const Text(
                        'ORDER',
                        style: TextStyle(
                          fontSize: 16,
                          color: sBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
