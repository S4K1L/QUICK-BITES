// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Drawer/user_Drawer.dart';
import 'Favorites_Manu/favorite_menu.dart';
import 'menu_post.dart';

class UserHomeScreen extends StatefulWidget {
  final String shopName;
   const UserHomeScreen({required this.shopName, super.key});

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
            TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteMenuPage(),
                    ),
                  );
                },
                child: const Icon(Icons.shopping_cart,color: Colors.red,)),
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
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
             Expanded(
              child: MenuPost(shopName: widget.shopName,),
            ),
          ],
        ),
      ),
    );
  }
}
