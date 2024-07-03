import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some Error Found");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class UserDataUploader {
  static Future<void> uploadUserData({
    required String? name,
    required String? userName,
    required String? email,
    required String password,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");
        // Explicitly set the document ID to be the same as the user's UID
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "name": name,
          "userName": userName,
          "email": email,
          "password": password,
          "type": 'user',
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}

class ChefDataUploader {
  static Future<void> uploadChefData({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");
        DocumentReference docRef = collRef.doc(firebaseUser.uid);
        await docRef.set({
          "email": email,
          "name": name,
          "password": password,
          "type": 'chef',
          "status": 'Pending',
          "userName": userName,
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}

class RunnerDataUploader {
  static Future<void> uploadRunnerData({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        CollectionReference collRef =
        FirebaseFirestore.instance.collection("users");
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "email": email,
          "name": name,
          "password": password,
          "type": 'runner',
          "status": 'Pending',
          "userName": userName,
          "uid": firebaseUser.uid,
        });

        print("Data upload successful. Document ID (UID): ${docRef.id}");
      } else {
        print("User is null. Unable to upload data.");
      }
    } catch (e) {
      print("Error uploading user data: $e");
    }
  }
}

