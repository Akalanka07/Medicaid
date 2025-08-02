import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pathome.dart'; // Import PharHomePage

class RegPa extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
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
                'First Name',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity, // Adjusted width
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your first name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Last Name',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity, // Adjusted width
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your last name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Contact Number',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity, // Adjusted width
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: contactNumberController,
                  decoration: InputDecoration(
                    hintText: 'Enter contact number',
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
                width: double.infinity, // Adjusted width
                height: 39,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: currentLocationController,
                  decoration: InputDecoration(
                    hintText: 'Add your current location',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Spacer(), // Move the submit button to the bottom
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
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String contactNumber = contactNumberController.text.trim();
    String currentLocation = currentLocationController.text.trim();

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        contactNumber.isNotEmpty &&
        currentLocation.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'firstName': firstName,
          'lastName': lastName,
          'contactNumber': contactNumber,
          'currentLocation': currentLocation,
        });
        // User details submitted successfully
        // Navigate to the PharHomePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatHomePage()),
        );
      } catch (e) {
        // Error submitting user details
        print('Error submitting user details: $e');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit user details. Please try again.'),
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
