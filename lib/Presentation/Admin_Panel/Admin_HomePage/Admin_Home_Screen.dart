import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_bites/Presentation/Welcome_Screen/welcome_screen.dart';
import 'package:quick_bites/Theme/constant.dart';
import '../../Chef_Panel/Chef_login/chef_login.dart';
import '../Create_Menu/create_menu.dart';
import 'menu_post.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
         "QUICKBITE FOOD",
         style: TextStyle(
           fontSize: 22,
           fontWeight: FontWeight.bold,
           color: Colors.red,
         ),
                    ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: adminDrawer(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.jpg'),
            fit: BoxFit.cover,
            opacity: 0.1
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Expanded(
              child: MenuPost(),
            ),
          ],
        ),
      ),
    );
  }


  Drawer adminDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFD6FBB),
                  Color(0xFFFDD064),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CircleAvatar(
                    minRadius: 60,
                    maxRadius: 80,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 160,
                      height: 160,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Admin Profile',
                  style: TextStyle(fontSize: 24, color: sBlackColor),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              _buildDrawerButton(
                context,
                icon: Icons.home_outlined,
                label: 'Home',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminHomeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.add_business_outlined,
                label: 'Add Menu',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateMenu()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.library_add_check_outlined,
                label: 'Approve Chef',
                onPressed: () {
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.attach_money,
                label: 'Finance Status',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.logout,
                label: 'Logout',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: sBlackColor),
          const SizedBox(width: 30),
          Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              color: sBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


}
