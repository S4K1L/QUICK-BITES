import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Drawer/admin_Drawer.dart';

class RunnerListPage extends StatefulWidget {
  const RunnerListPage({super.key});

  @override
  State<RunnerListPage> createState() => _RunnerListPageState();
}

class _RunnerListPageState extends State<RunnerListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Runner List",
          style: TextStyle(color: Colors.green),
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
                    ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .where('type', isEqualTo: 'runner')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No runner found.'));
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
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.white),
        child: ListTile(
          title: Text(
            'Name: ${chef['name']}',
            style: TextStyle(color: Colors.green),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${chef['email']}'),
            ],
          ),
        ),
      ),
    );
  }
}
