import 'package:flutter/material.dart';
import 'package:quick_bites/Theme/const.dart';
import '../../../Core/Repository_and_Authentication/profile_image_picker.dart';
import '../../Drawer/user_Drawer.dart';
import 'menu_post.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "QUICKBITE FOOD",
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
        backgroundColor: Colors.transparent,
      ),
      drawer: const UserDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/welcome.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3),
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
}
