import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Drawer/admin_Drawer.dart';

class ApproveChef extends StatefulWidget {
  const ApproveChef({super.key});

  @override
  State<ApproveChef> createState() => _ApproveChefState();
}

class _ApproveChefState extends State<ApproveChef> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Approve Chef",style: TextStyle(color: Colors.red),),
      ),
      drawer: AdminDrawer(),
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
                    opacity: 0.3
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').where('status', isEqualTo: 'Pending').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No pending chef requests.'));
                  } else {
                    final chefs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: chefs.length,
                      itemBuilder: (context, index) {
                        final chef = chefs[index];
                        return chefList(chef);
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

  Padding chefList(QueryDocumentSnapshot<Object?> chef) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white
        ),
        child: ListTile(
                    title: Text('Name: ${chef['name']}',style: TextStyle(color: Colors.purple[300]),),
                    subtitle: Text('Email: ${chef['email']}'),
                    trailing: DropdownButton<String>(
                      value: chef['status'],
                      items: <String>['Pending', 'Approved'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _updateChefStatus(chef.id, newValue);
                        }
                      },
                    ),
                  ),
      ),
    );
  }

  void _updateChefStatus(String chefId, String newStatus) {
    _firestore.collection('users').doc(chefId).update({
      'status': newStatus,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chef status updated to $newStatus.'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
