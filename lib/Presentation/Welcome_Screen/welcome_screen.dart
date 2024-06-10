import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/custom_button.dart';
import '../Chef_Panel/Chef_login/chef_login.dart';
import '../Delivery_Panel/Delivery_Login/delivery_login.dart';
import '../User_Panel/Login_Screen/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Find your unlimited one-\nstop Food in UiTM area',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.adamina(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  OptionButton(text: 'CONNECT AS CUSTOMER', onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserLoginScreen()),
                    );
                  },),
                  OptionButton(text: 'CONNECT AS CHEF', onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChefLoginScreen()),
                    );
                  },),
                  OptionButton(text: 'CONNECT AS RIDER', onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeliveryLoginScreen()),
                    );
                  },),
                ],
              ),
            ),
          ),
          Positioned(
              top: 290,
              left: 300,
              child: Image.asset(
                'assets/images/love.png',
                width: 30,
                height: 30,
              )),
          Positioned(
              top: 390,
              left: 300,
              child: Image.asset(
                'assets/images/love.png',
                width: 30,
                height: 30,
              )),
          Positioned(
              top: 490,
              left: 300,
              child: Image.asset(
                'assets/images/love.png',
                width: 30,
                height: 30,
              )),
        ],
      ),
    );
  }
}
