import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Drawer/admin_Drawer.dart';

class ChefListPage extends StatefulWidget {
  const ChefListPage({super.key});

  @override
  State<ChefListPage> createState() => _ChefListPageState();
}

class _ChefListPageState extends State<ChefListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chef List",
          style: TextStyle(color: Colors.red),
        ),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/welcome.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.3),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .where('type', isEqualTo: 'chef')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No chefs found.'));
                  } else {
                    final chefs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: chefs.length,
                      itemBuilder: (context, index) {
                        final chef = chefs[index];
                        return chefListTile(chef);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding chefListTile(QueryDocumentSnapshot<Object?> chef) {
    return Padding(
      padding: const EdgeInsets.only(left:  20,right: 20,bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.white),
        child: ListTile(
          title: Text(
            chef['shopName'],
            style: TextStyle(color: Colors.green[300]),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chef Name: ${chef['name']}'),
              Text('Email: ${chef['email']}'),
            ],
          ),
        ),
      ),
    );
  }
}
