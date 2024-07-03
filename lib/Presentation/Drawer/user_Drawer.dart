import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Theme/const.dart';
import '../../Theme/constant.dart';
import '../User_Panel/User_HomePage/Cart_Manu/cart_menu.dart';
import '../User_Panel/User_HomePage/Cart_Manu/chekout.dart';
import '../User_Panel/User_HomePage/My_Order/my_order.dart';
import '../User_Panel/User_HomePage/Order_History/order_history.dart';
import '../User_Panel/User_HomePage/user_Home_Screen.dart';
import '../User_Panel/User_Login/user_login.dart';


class UserDrawer extends StatefulWidget {
  const UserDrawer({super.key});

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final Map<String, int> _quantities = {};

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: kTextWhiteColor,
                    ),
                    child: const Center(child: ProfileImagePicker()),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 20, color: sBlackColor),
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
                      builder: (context) => const UserHomeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.shopping_cart_outlined,
                label: 'My Cart',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartMenuPage(),
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
