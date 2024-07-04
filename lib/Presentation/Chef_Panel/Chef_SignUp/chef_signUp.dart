// ignore_for_file: file_names, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Core/Firebase/Authentication.dart';


class ChefSignUpScreen extends StatefulWidget {
  const ChefSignUpScreen({super.key});

  @override
  State<ChefSignUpScreen> createState() => _ChefSignUpScreenState();
}

class _ChefSignUpScreenState extends State<ChefSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;

  void _uploadData() {
    ChefDataUploader.uploadChefData(
      name: _nameController.text,
      shopName: _shopNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.done_all_sharp, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Account Request has been send",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green[300],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 6,
          ),
        );
        _uploadData();
        print("Data uploaded successfully");
        print("User successfully created");
      } else {
        _showErrorSnackbar("Some error found!");
      }
    } catch (e) {
      _showErrorSnackbar("Sign-up failed: $e");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5DC5E),Color(0xFF18C0D7)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Column(
            children: [
              topContainer(context),
              const SizedBox(height: 60),
              formContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding formContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 30),
            _buildTextField(_nameController, 'Full Name'),
            const SizedBox(height: 30),
            _buildTextField(_shopNameController, 'Shop Name'),
            const SizedBox(height: 30),
            _buildPasswordField(_passwordController, 'Password', _passwordVisible, () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }),
            const SizedBox(height: 30),
            _buildPasswordField(_repeatPasswordController, 'Repeat Password', _repeatPasswordVisible, () {
              setState(() {
                _repeatPasswordVisible = !_repeatPasswordVisible;
              });
            }),
            const SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.green,
              ),
              child: TextButton(
                onPressed: _signUp,
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextFormField _buildPasswordField(TextEditingController controller, String hintText, bool isVisible, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (hintText == 'Repeat Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }


  Container topContainer(BuildContext context) {
    return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xFF74D35E),
                    Color(0xFF089AAC),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30,left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back_ios_new,size: 32,color: Colors.white,)),
                    const SizedBox(height: 10,),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'REGISTER YOUR ACCOUNT',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
  }
}
