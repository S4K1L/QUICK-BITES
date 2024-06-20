import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChefForgotScreen extends StatefulWidget {
  const ChefForgotScreen({super.key});

  @override
  State<ChefForgotScreen> createState() => _ChefForgotScreenState();
}

class _ChefForgotScreenState extends State<ChefForgotScreen> {
  final auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  resetPassword(){
    String email = emailController.text.toString();
    auth.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(
        children: [
          Icon(
            Icons.notifications_active_outlined,
            color: Colors.red,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "We have sent you email to recover password, please check email",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3), // Adjust the duration as needed
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
      bottomNavigationBar: Container(
        height: 50,
        decoration: const BoxDecoration(
            color: Colors.green
        ),
        child: Column(
          children: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Return to Login Page',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
              color: Colors.grey[300]
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF079AAC),
                      Color(0xFF6FD062),
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
                          'FORGOT\nPASSWORD',
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
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Image.asset('assets/images/forgot.png'),
                    const SizedBox(height: 20,),
                    const Text('Trouble Logging in?', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 20),
                    const Text("Enter your email and we'll send you", style: TextStyle(fontSize: 16),),
                    const Text("a link to reset your password", style: TextStyle(fontSize: 16),),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.green
                      ),
                      child: TextButton(
                        onPressed: () {
                          resetPassword();
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
