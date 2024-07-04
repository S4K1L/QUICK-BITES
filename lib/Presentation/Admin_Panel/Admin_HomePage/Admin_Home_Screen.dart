// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Drawer/admin_Drawer.dart';
import 'admin_menu_post.dart';

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
      drawer: const AdminDrawer(),
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
            const Expanded(
              child: AdminMenuPost(),
            ),
          ],
        ),
      ),
    );
  }

}
