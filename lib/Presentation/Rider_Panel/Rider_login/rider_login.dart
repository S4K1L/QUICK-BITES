// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bites/Presentation/Rider_Panel/Rider_HomeScreen/rider_homescreen.dart';
import '../../../Core/Firebase/Authentication.dart';
import '../../../Theme/const.dart';
import '../../Admin_Panel/Admin_HomePage/Admin_Home_Screen.dart';
import '../../Welcome_Screen/welcome_screen.dart';
import '../Rider_ForgotPassword/rider_forgotPassword.dart';
import '../Rider_signUp/rider_signUp.dart';

class RunnerLoginScreen extends StatefulWidget {
  const RunnerLoginScreen({super.key});

  @override
  _RunnerLoginScreenState createState() => _RunnerLoginScreenState();
}

class _RunnerLoginScreenState extends State<RunnerLoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginSelected = true;
  bool _passwordVisible = false;

  void toggleTab(bool isLogin) {
    setState(() {
      isLoginSelected = isLogin;
    });
  }

  void _signIn() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (_formKey.currentState!.validate()) {
        User? user = await _auth.signInWithEmailAndPassword(email, password);

        if (user != null) {
          route();
          print("User is successfully SignIn");
        } else {
          _showErrorSnackbar("Email or Password Incorrect");
          print("Unexpected error: User is null");
        }
      }
    } catch (e) {
      print("Sign-up failed: $e");
      _showErrorSnackbar("Sign-up failed: $e");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 6,
    ));
  }

  void route() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('type') == "runner" && documentSnapshot.get('status') == "Approved") {
          _showSuccessSnackbar("Welcome to QUICK BITES");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiderHomeScreen()),
          );
        }else if(documentSnapshot.get('type') == "runner" && documentSnapshot.get('status') == "Pending") {
          _showErrorSnackbar("Account not Approved");
        }
        else if (documentSnapshot.get('type') == "admin") {
          _showSuccessSnackbar("Welcome Sir");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else {
          _showErrorSnackbar("Some error in logging in!");
        }
      } else {
        _showErrorSnackbar("Some error in logging in!");
      }
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 6,
      margin: const EdgeInsets.all(20),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFC7F8DB),
                Color(0xFF94BAFD),
              ],
            ),
          ),
          child: Column(
            children: [
              topContainer(context),
              Image.asset('assets/images/delivery.png'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: buildLoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container topContainer(BuildContext context) {
    return Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF8563FB),
                        Color(0xFF61D2E7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WelcomeScreen()),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: kTextWhiteColor,
                              )),
                          const SizedBox(
                            width: 50,
                          ),
                          Text(
                            'QUICK BITES',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'DELIVERY APP',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.lock_outline, color: Colors.white, size: 30),
                              TextButton(
                                onPressed: () => toggleTab(true),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom bar indicator for Login
                              Container(
                                height: 4,
                                width: 180,
                                color: isLoginSelected ? Colors.blue : Colors.transparent,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RiderSignUpScreen()),
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom bar indicator for Register
                              Container(
                                height: 4,
                                width: 180,
                                color: isLoginSelected ? Colors.transparent : Colors.yellow,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
  }

  Widget buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email, color: Colors.blue),
              hintText: 'Email',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              prefixIcon: const Icon(Icons.lock, color: Colors.blue),
              hintText: 'Password',
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RiderForgotScreen()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                _signIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiderSignUpScreen()),
                  );
                },
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
