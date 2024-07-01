import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bites/Presentation/Drawer/admin_Drawer.dart';

class AddDeliveryZone extends StatefulWidget {
  const AddDeliveryZone({super.key});

  @override
  _AddDeliveryZoneState createState() => _AddDeliveryZoneState();
}

class _AddDeliveryZoneState extends State<AddDeliveryZone> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _zoneNameController = TextEditingController();
  final TextEditingController _deliveryFeeController = TextEditingController();

  Future<void> _addDeliveryZone() async {
    if (_formKey.currentState?.validate() ?? false) {
      final zoneName = _zoneNameController.text;
      final deliveryFee = double.tryParse(_deliveryFeeController.text) ?? 0.0;

      final zoneData = {
        'zoneName': zoneName,
        'deliveryFee': deliveryFee,
      };

      await FirebaseFirestore.instance.collection('zones').add(zoneData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delivery zone added successfully!')),
      );

      _zoneNameController.clear();
      _deliveryFeeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            const Text(
              "Add Delivery Zone",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_location,
                  color: Colors.red,
                ))
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/welcome.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _zoneNameController,
                      decoration: InputDecoration(
                        labelText: 'Zone Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a zone name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _deliveryFeeController,
                      decoration: InputDecoration(
                        labelText: 'Delivery Fee',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a delivery fee';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addDeliveryZone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Add Zone',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
