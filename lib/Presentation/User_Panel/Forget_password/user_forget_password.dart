import 'package:flutter/material.dart';


class UserForgotScreen extends StatelessWidget {
  const UserForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.orange
        ),
        child: Column(
          children: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Return to Login Page',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),))
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
                      Color(0xFFFD6DBD),
                      Color(0xFFFDD461),
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  child: Column(
                    children: [
                      Image.asset('assets/images/forgot.png'),
                      SizedBox(height: 20,),
                      Text('Trouble Logging in?', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20),
                      Text("Enter your email and we'll send you", style: TextStyle(fontSize: 16),),
                      Text("a link to reset your password", style: TextStyle(fontSize: 16),),
                      SizedBox(height: 20),
                      TextField(
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
                      SizedBox(height: 50),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.orange
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Reset Password',
                            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
