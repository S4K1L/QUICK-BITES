// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Theme/const.dart';
import '../../Theme/constant.dart';
import '../User_Panel/User_HomePage/Favorites_Manu/chekout.dart';
import '../User_Panel/User_HomePage/Favorites_Manu/favorite_menu.dart';
import '../User_Panel/User_HomePage/My_Order/my_order.dart';
import '../User_Panel/User_HomePage/Order_History/order_history.dart';
import '../User_Panel/User_HomePage/shop_select/shop_select.dart';
import '../User_Panel/User_Login/user_login.dart';
import 'edit_profile.dart';


class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final Map<String, int> _quantities = {};
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
                    Color(0xFFFD6FBB),
                    Color(0xFFFDD064),
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
                            builder: (context) => EditUserProfile(name: _name!, email: _email!),
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
                        builder: (context) => const ShopSelectionPopup(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.edit_note,
                  label: 'My Order',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyOrders(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.checklist,
                  label: 'Checkout',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckOut(quantities: _quantities),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.history,
                  label: 'Order History',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderHistory(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerButton(
                  context,
                  icon: Icons.favorite_border_sharp,
                  label: 'My Favorite',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteMenuPage(),
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
                        builder: (context) => const UserLoginScreen(),
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
