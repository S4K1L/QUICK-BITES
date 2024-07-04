import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Drawer/admin_Drawer.dart';

class ApproveAccountList extends StatefulWidget {
  const ApproveAccountList({super.key});

  @override
  State<ApproveAccountList> createState() => _ApproveAccountListState();
}

class _ApproveAccountListState extends State<ApproveAccountList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Accounts Control",
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
                    .where('type', whereIn: ['chef', 'runner'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No users of type chef or runner.'));
                  } else {
                    final users = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return accountList(user);
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

  Padding accountList(QueryDocumentSnapshot<Object?> user) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.white),
        child: ListTile(
          title: Text(
            user['name'],
            style: TextStyle(color: Colors.purple[300]),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user['email']}'),
              Text('Type: ${user['type']}'),
            ],
          ),
          trailing: DropdownButton<String>(
            value: user['status'],
            items: <String>['Pending', 'Approved'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _updateUserStatus(user.id, newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  void _updateUserStatus(String userId, String newStatus) {
    _firestore.collection('users').doc(userId).update({
      'status': newStatus,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account status updated to $newStatus.'),
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
