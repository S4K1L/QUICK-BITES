import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bites/Presentation/Chef_Panel/Chef_Earning/chef_earning.dart';
import 'package:quick_bites/Presentation/Chef_Panel/Chef_login/chef_login.dart';
import '../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Theme/const.dart';
import '../../Theme/constant.dart';
import '../Chef_Panel/Add_Delivery_Zone/add_delivery_zone.dart';
import '../Chef_Panel/Add_Menu/Add_menu.dart';
import '../Chef_Panel/Chef_HomeScreen/chef_homescreen.dart';
import '../Chef_Panel/New_Order/new_order.dart';
import '../Chef_Panel/Order_History/order_history.dart';


class ChefDrawer extends StatelessWidget {
  const ChefDrawer({super.key});

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
                  Color(0xFF1EC1D4),
                  Color(0xFFEADB64),
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
                  'Chef Profile',
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
                      builder: (context) => const ChefHomeScreen(),
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
                    MaterialPageRoute(builder: (context) => const AddMenu()),
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
                      builder: (context) => const ChefEarnings(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.edit_note,
                label: 'New Orders',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChefNewOrders(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDrawerButton(
                context,
                icon: Icons.checklist,
                label: 'Orders - History',
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
                icon: Icons.delivery_dining_outlined,
                label: 'Add Delivery Zone',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddDeliveryZone()),
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
                      builder: (context) => const ChefLoginScreen(),
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
