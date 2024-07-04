// ignore_for_file: file_names, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
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
        DocumentReference docRef = collRef.doc(firebaseUser.uid);

        await docRef.set({
          "name": name,
          "userName": userName,
          "email": email,
          "password": password,
          "type": 'user',
          "uid": firebaseUser.uid,
        });

      } else {
      }
    } catch (e) {
    }
  }
}

class ChefDataUploader {
  static Future<void> uploadChefData({
    required String name,
    required String shopName,
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
          "shopStatus": 'OPEN',
          "shopName": shopName,
          "uid": firebaseUser.uid,
        });

      } else {
      }
    } catch (e) {
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

      } else {
      }
    } catch (e) {
    }
  }
}

