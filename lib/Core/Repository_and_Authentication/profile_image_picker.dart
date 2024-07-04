// ignore_for_file: empty_catches

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bites/Core/Repository_and_Authentication/pickImage.dart';



class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({
    super.key,
  });


  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  Uint8List? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? userUID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userUID = _auth.currentUser?.uid;
    });
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    // Upload the image to Firebase Storage and update the user's profile picture
    uploadImageAndUpdateProfile(img);
  }

  Future<void> uploadImageAndUpdateProfile(Uint8List? image) async {
    if (image == null) return;

    try {
      // Create a unique filename for the image
      String fileName = '${_auth.currentUser!.uid}.png';

      // Upload the image to Firebase Storage
      Reference storageReference = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageReference.putData(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the user's profile picture URL in Firestore
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'profile_image': imageUrl,
      });
    } catch (error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectImage,
      child: Stack(
        children: [
          _image != null
              ? CircleAvatar(
            minRadius: 40.0,
            maxRadius: 40.0,
            backgroundImage: MemoryImage(_image!),
          )
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: _firestore.collection('users').doc(userUID).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else {
                if (snapshot.data!.exists && snapshot.data!.data()!.containsKey('profile_image')) {
                  String? imageUrl = snapshot.data!.data()!['profile_image'];
                  return CircleAvatar(
                    minRadius: 40.0,
                    maxRadius: 40.0,
                    backgroundColor: Colors.white,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl)
                        : const NetworkImage(
                        'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp'),
                  );
                } else {
                  // Handle the case when 'profile_image' field doesn't exist or is null
                  return const CircleAvatar(
                    minRadius: 40.0,
                    maxRadius: 40.0,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp',
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
