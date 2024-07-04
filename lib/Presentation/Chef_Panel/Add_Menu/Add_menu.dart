// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quick_bites/Presentation/Drawer/chef_Drawer.dart';
import '../../../Theme/constant.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  static String routeName = 'CreateMenu';

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _shopName = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      setState(() {
        _shopName = userDoc['shopName'] ?? '';
      });
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 85,
    );
    setState(() {
      _images.addAll(pickedFiles.map((file) => File(file.path)));
    });
  }

  Future<void> _uploadAllData() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_formKey.currentState!.validate() && _images.isNotEmpty) {
        User? firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser != null) {
          String name = _nameController.text;
          String details = _detailsController.text;
          String price = _priceController.text;

          int price2 = int.parse(price); // Convert price to integer

          List<String> imageUrl = [];
          double totalProgress = 0.0;

          for (var imageFile in _images) {
            Reference ref = FirebaseStorage.instance.ref().child(
                'food_images/${DateTime.now().millisecondsSinceEpoch}_${_images.indexOf(imageFile)}.jpg');

            UploadTask uploadTask = ref.putFile(imageFile);
            TaskSnapshot snapshot = await uploadTask;
            String imageURL = await snapshot.ref.getDownloadURL();
            imageUrl.add(imageURL);

            totalProgress += 1 / _images.length;
            setState(() {
              _uploadProgress = totalProgress;
            });
          }

          await FirebaseFirestore.instance.collection("menu").add({
            "name": name,
            "price": price2, // Store price as integer
            "details": details,
            "chefUid": firebaseUser.uid,
            "shopName": _shopName,
            "shopStatus": 'OPEN',
            "isFav": false,
            "imageUrl": imageUrl[0],
            "moreImagesUrl": imageUrl,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "New Food Added",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: sPrimaryColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
            ),
          );
          Navigator.pop(context);

          print("Data upload successful.");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.nearby_error,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Error found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
            ),
          );

          print("User is null. Unable to upload data.");
        }
      }
    } catch (e) {
      print("Error uploading user data: $e");
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sWhiteColor,
        centerTitle: true,
        title: const Text(
          'Add Menu',
          style: TextStyle(color: Colors.deepPurpleAccent),
        ),
      ),
      drawer: const ChefDrawer(),
      body: _isUploading
          ? Center(
        child: CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 16.0,
          percent: _uploadProgress,
          center: Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
          progressColor: Colors.blue,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Shop Name: $_shopName",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.deepPurpleAccent),),
              const SizedBox(height: 16.0),
              _buildInputField(_nameController, 'Food Name'),
              const SizedBox(height: 16.0),
              _buildInputField(_detailsController, 'Details'),
              const SizedBox(height: 16.0),
               _buildInputField(_priceController, 'Price'),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: ElevatedButton(
                      onPressed: () {
                        _uploadAllData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F39FB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Publish Now',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _getImage();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.deepPurpleAccent,
                      size: 36,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _images.isEmpty
                  ? Container()
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _images.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText,
      {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}
