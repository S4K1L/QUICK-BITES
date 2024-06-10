import 'package:flutter/material.dart';
import 'menu_post.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
         "Meal Menu",
         style: TextStyle(
           fontSize: 24,
           fontWeight: FontWeight.bold,
           color: Colors.black,
         ),
                    ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
