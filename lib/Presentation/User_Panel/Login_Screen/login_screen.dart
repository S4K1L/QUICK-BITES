import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bites/Presentation/User_Panel/Forget_password/user_forget_password.dart';

import '../SignUp_Screen/signUp_screen.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool isLoginSelected = true;

  void toggleTab(bool isLogin) {
    setState(() {
      isLoginSelected = isLogin;
    });
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
                Color(0xFFE7D481),
                Color(0xFFE09BF6),
              ],
            ),
          ),
          child: Column(
            children: [
              // Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title and Top Bar
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF676FF7),
                          Color(0xFFE767CB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'QUICK BITES',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'DELIVERY APP',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                                      textStyle: TextStyle(
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
                                  color: isLoginSelected ? Colors.pink : Colors.transparent,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const UserSignUpScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Register',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
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
                                  color: isLoginSelected ? Colors.transparent : Colors.pink,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Food Image
                  Image.asset('assets/images/login.png'),
                  const SizedBox(height: 20),
                  // Form fields based on the selected tab
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: isLoginSelected ? buildLoginForm() : buildRegisterForm(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.purple),
            hintText: 'Email',
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.purple),
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserForgotScreen()),
              );
            },
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Login',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7F39FB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserSignUpScreen()),
                );
              },
              child: Text(
                'Register',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
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
    );
  }

  Widget buildRegisterForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.purple),
            hintText: 'Full Name',
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.purple),
            hintText: 'Email',
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.purple),
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Register',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7F39FB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () => toggleTab(true),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
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
    );
  }
}
