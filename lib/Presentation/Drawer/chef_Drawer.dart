// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'Edit_Profile/chef_edit_profile.dart';

class ChefDrawer extends StatefulWidget {
  const ChefDrawer({super.key});

  @override
  _ChefDrawerState createState() => _ChefDrawerState();
}

class _ChefDrawerState extends State<ChefDrawer> {
  bool _storeStatus = false;
  String _shopName = "";
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
        _shopName = userDoc['shopName'] ?? '';
        _name = userDoc['name'] ?? '';
        _email = userDoc['email'] ?? '';
      });
      _fetchStoreStatus();
    }
  }

  Future<void> _fetchStoreStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null && _shopName.isNotEmpty) {
      QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
          .collection('menu')
          .where('shopName', isEqualTo: _shopName)
          .get();

      if (menuSnapshot.docs.isNotEmpty) {
        setState(() {
          _storeStatus = menuSnapshot.docs.first['shopStatus'] == 'OPEN';
        });
      }
    }
  }

  Future<void> _updateStoreStatus(bool status) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String storeStatus = status ? 'OPEN' : 'CLOSED';

    if (user != null) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
          .collection('menu')
          .where('shopName', isEqualTo: _shopName)
          .get();
      for (DocumentSnapshot doc in menuSnapshot.docs) {
        batch.update(doc.reference, {'shopStatus': storeStatus});
      }
      await batch.commit();
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
                            builder: (context) => ChefEditUserProfile(name: _name, email: _email),
                          ),
                        );
                      }, icon: const Icon(Icons.edit,color: Colors.green,))),
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
                ListTile(
                  leading: const Icon(Icons.store, color: sBlackColor),
                  title: const Text(
                    'Shop Status',
                    style: TextStyle(
                      fontSize: 16,
                      color: sBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Switch(
                    value: _storeStatus,
                    onChanged: (value) {
                      setState(() {
                        _storeStatus = value;
                      });
                      _updateStoreStatus(value);
                    },
                    activeColor: Colors.green,
                  ),
                ),
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
