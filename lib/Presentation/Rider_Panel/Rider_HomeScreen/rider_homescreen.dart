import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_bites/Presentation/Drawer/rider_Drawer.dart';
import 'package:quick_bites/Presentation/Rider_Panel/Rider_Earning/rider_earning.dart';
import '../../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../../Theme/const.dart';
import '../New Order/Rider_New_Order/rider_new_Order.dart';
import '../Rider_Order_history/rider_order_history.dart';
import '../Rider_login/rider_login.dart';

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "QUICKBITE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: kTextWhiteColor
                  ),
                  child: const ProfileImagePicker()),
            ),
          ],
        ),
        centerTitle: true,
        // Removed backgroundColor: Colors.transparent,
      ),
      drawer: const RiderDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: <Widget>[
                DashboardItem(
                  title: 'New Available Order',
                  icon: Icons.assignment,
                  color: Colors.grey,
                  iconColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiderNewOrders(),
                      ),
                    );
                  },
                ),
                DashboardItem(
                  title: 'History',
                  icon: Icons.history,
                  color: Colors.blue,
                  iconColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiderOrdersHistory(),
                      ),
                    );
                  },
                ),
                DashboardItem(
                  title: 'Total Earnings',
                  icon: Icons.attach_money,
                  color: Colors.blue,
                  iconColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiderEarning(),
                      ),
                    );
                  },
                ),
                DashboardItem(
                  title: 'Log Out',
                  icon: Icons.logout,
                  color: Colors.grey,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiderLoginScreen(),
                      ),
                    );
                  },
                  iconColor: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 200,
            child: Image.asset(
              'assets/images/bike.png',
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const DashboardItem({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.purple
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
