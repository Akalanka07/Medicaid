import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pharhome.dart'; // Import PharHomePage

class RegPh extends StatelessWidget {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController storeAddressController = TextEditingController();
  final TextEditingController currentLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Store Name',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: storeNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter store name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Phone Number',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Store Address',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: storeAddressController,
                  decoration: InputDecoration(
                    hintText: 'Enter store address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Current Location',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      // Navigate to Google location page
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: currentLocationController,
                  decoration: InputDecoration(
                    hintText: 'Add current location',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              Center(
                child: SizedBox(
                  width: 330.6,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      submitForm(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1987FB),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm(BuildContext context) async {
    String storeName = storeNameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String storeAddress = storeAddressController.text.trim();
    String currentLocation = currentLocationController.text.trim();

    if (storeName.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        storeAddress.isNotEmpty &&
        currentLocation.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('stores').add({
          'storeName': storeName,
          'phoneNumber': phoneNumber,
          'storeAddress': storeAddress,
          'currentLocation': currentLocation,
        });
        // Store details submitted successfully
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PharHomePage()),
        );
      } catch (e) {
        // Error submitting store details
        print('Error submitting store details: $e');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit store details. Please try again.'),
          ),
        );
      }
    } else {
      // Show error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all the fields before submitting.'),
        ),
      );
    }
  }
}
