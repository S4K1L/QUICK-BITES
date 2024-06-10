import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Chef_Panel/Chef_ForgotPassword/chef_forgotPassword.dart';
import '../../Chef_Panel/Chef_SignUp/chef_signUp.dart';
import '../Delivery_ForgotPassword/delivery_forgotPassword.dart';
import '../Delivery_signUp/delivery_signUp.dart';

class DeliveryLoginScreen extends StatefulWidget {
  const DeliveryLoginScreen({super.key});

  @override
  _DeliveryLoginScreenState createState() => _DeliveryLoginScreenState();
}

class _DeliveryLoginScreenState extends State<DeliveryLoginScreen> {
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
                Color(0xFFC7F8DB),
                Color(0xFF94BAFD),
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
                          Color(0xFF8563FB),
                          Color(0xFF61D2E7),
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
                                      MaterialPageRoute(builder: (context) => const DeliverySignUpScreen()),
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
                                  color: isLoginSelected ? Colors.transparent : Colors.yellow,
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
                  Image.asset('assets/images/delivery.png'),
                  const SizedBox(height: 20),
                  // Form fields based on the selected tab
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: buildLoginForm(),
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
            prefixIcon: Icon(Icons.email, color: Colors.blue),
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
            prefixIcon: Icon(Icons.lock, color: Colors.blue),
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
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeliveryForgotScreen()),
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
              backgroundColor: Color(0xFF3684CC),
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
                  fontSize: 12,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeliverySignUpScreen()),
                );
              },
              child: Text(
                'Create an account',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
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
