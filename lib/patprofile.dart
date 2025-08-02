// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Patient {
  final String contactNumber;
  final String firstName;
  final String lastName;
  Patient({
    required this.contactNumber,
    required this.firstName,
    required this.lastName,
  });

  Patient copyWith({
    String? contactNumber,
    String? firstName,
    String? lastName,
  }) {
    return Patient(
      contactNumber: contactNumber ?? this.contactNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Contact Number': contactNumber,
      'First Name': firstName,
      'Last Name': lastName,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      contactNumber: map['Contact Number'] as String,
      firstName: map['First Name'] as String,
      lastName: map['Last Name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Patient(contactNumber: $contactNumber, firstName: $firstName, lastName: $lastName)';

  @override
  bool operator ==(covariant Patient other) {
    if (identical(this, other)) return true;

    return other.contactNumber == contactNumber &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode =>
      contactNumber.hashCode ^ firstName.hashCode ^ lastName.hashCode;
}

class PatProfilePage extends StatelessWidget {
  Future<Patient> _loadPatient() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('patient')
        .where("Contact Number",
            isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();
    return snapshot.docs
        .map((doc) => Patient.fromMap(doc.data()))
        .toList()
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _loadPatient(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    snapshot.data.firstName + ' ' + snapshot.data.lastName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hi, Welcome to Medicaid',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text('Update Profile'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ],
              );
            }
            return Text('No data found');
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(25, 135, 251, 0.23),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2, // Index of the Profile icon
        onTap: (index) {
          // Handle navigation to different tabs here
          // Index 0: Home, Index 1: Store, Index 2: Profile
          // Example:
          if (index == 0) {
            // Navigate to Home Page
          } else if (index == 1) {
            // Navigate to Store Page
          } else if (index == 2) {
            // Navigate to PharmacistProfilePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatProfilePage()),
            );
          }
        },
      ),
    );
  }
}
