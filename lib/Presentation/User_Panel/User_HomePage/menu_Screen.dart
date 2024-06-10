import 'package:flutter/material.dart';
import 'package:quick_bites/Theme/constant.dart';
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
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/3,
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
                    child: CircleAvatar(
                      minRadius: 60,
                      maxRadius: 80,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/logo.png',width: 160,height: 160,),
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text('My Profile',style: TextStyle(fontSize: 24,color: sBlackColor),)
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.home_outlined,color: sBlackColor,size: 42,),
                  const SizedBox(width: 20,),
                  TextButton(onPressed: (){}, child: Text('Home',style: TextStyle(fontSize: 22,color: sBlackColor,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.edit_note_outlined,color: sBlackColor,size: 42,),
                  const SizedBox(width: 20,),
                  TextButton(onPressed: (){}, child: Text('My Orders',style: TextStyle(fontSize: 22,color: sBlackColor,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.checklist_outlined,color: sBlackColor,size: 42,),
                  const SizedBox(width: 20,),
                  TextButton(onPressed: (){}, child: const Text('Order History',style: TextStyle(fontSize: 22,color: sBlackColor,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.logout,color: sBlackColor,size: 42,),
                  const SizedBox(width: 20,),
                  TextButton(onPressed: (){}, child: Text('Logout',style: TextStyle(fontSize: 22,color: sBlackColor,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
          ],
        ),
      ),
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
            Expanded(
              child: MenuPost(),
            ),
          ],
        ),
      ),
    );
  }
}
