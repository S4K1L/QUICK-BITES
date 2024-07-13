// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Rider_Panel/Rider_HomeScreen/rider_homescreen.dart';
import 'package:quick_bites/Presentation/Rider_Panel/Rider_Order_history/rider_order_history.dart';
import 'package:quick_bites/Presentation/Rider_Panel/Rider_login/rider_login.dart';
import '../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Theme/const.dart';
import '../../Theme/constant.dart';
import '../Rider_Panel/New Order/Rider_New_Order/rider_new_Order.dart';
import '../Rider_Panel/Rider_Earning/rider_earning.dart';
import 'Edit_Profile/runner_edit_profile.dart';


class RunnerDrawer extends StatefulWidget {
  const RunnerDrawer({super.key});

  @override
  State<RunnerDrawer> createState() => _RunnerDrawerState();
}

class _RunnerDrawerState extends State<RunnerDrawer> {
  String? _name = '';
  String? _email = '';

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
                    Color(0xFF875EFC),
                    Color(0xFF5ED9E6),
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
                            builder: (context) => RunnerEditUserProfile(name: _name!, email: _email!),
                          ),
                        );
                      }, icon: const Icon(Icons.edit,color: Colors.red,))),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: kTextWhiteColor,
                    ),
                    child: const Center(child: ProfileImagePicker()),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    style: const TextStyle(fontSize: 20, color: sBlackColor),
                    _name!,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    style: const TextStyle(fontSize: 16, color: sBlackColor),
                    'Email : ${_email!}',
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
                        builder: (context) => const RunnerHomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'My Earning',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RunnerEarning(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.delivery_dining,
                  label: 'New Orders',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RunnerNewOrders(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.checklist,
                  label: 'Orders History',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RunnerOrdersHistory(),
                      ),
                    );
                  },
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
                        builder: (context) => const RunnerLoginScreen(),
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
