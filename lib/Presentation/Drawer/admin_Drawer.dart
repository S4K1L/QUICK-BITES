// ignore_for_file: file_names, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Admin_Panel/Approve/account_control.dart';
import 'package:quick_bites/Presentation/Admin_Panel/Finance/total_finance.dart';
import 'package:quick_bites/Presentation/Chef_Panel/Chef_login/chef_login.dart';
import 'package:quick_bites/Presentation/Welcome_Screen/welcome_screen.dart';
import '../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Theme/const.dart';
import '../../Theme/constant.dart';
import '../Admin_Panel/Admin_HomePage/Admin_Home_Screen.dart';
import '../Admin_Panel/List/chef_list.dart';
import '../Admin_Panel/List/runner_list.dart';
import 'edit_profile.dart';


class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      setState(() {
        _name = userDoc['name'] ?? '';
        _email = userDoc['email'] ?? '';
      });
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF1EC1D4),
                    Color(0xFFEADB64),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserProfile(name: _name, email: _email),
                          ),
                        );
                      }, icon: const Icon(Icons.edit,color: Colors.lightGreen,))),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: kTextWhiteColor,
                    ),
                    child: const Center(child: ProfileImagePicker()),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    style: const TextStyle(fontSize: 20, color: sBlackColor),
                    _name,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    style: const TextStyle(fontSize: 16, color: sBlackColor),
                    'Email : $_email',
                  ),
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
                  icon: Icons.restaurant,
                  label: 'Chef List',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChefListPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.directions_bike_rounded,
                  label: 'Runner List',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RunnerListPage()),
                    );
                  },
                ),

                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.attach_money,
                  label: 'Finance Status',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TotalFinance()),
                    );
                  },
                ),

                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Account Control',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ApproveAccountList()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  onPressed: (){
                    _signOut();
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
