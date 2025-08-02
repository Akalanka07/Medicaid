import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacytrackerapp/pathome.dart';
import 'package:pharmacytrackerapp/pharhome.dart';
import 'package:pharmacytrackerapp/walkthrough.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delay for 2 seconds before navigation
    Future.delayed(Duration(seconds: 2), () {
      // Check user registration status and navigate accordingly
      checkRegistrationAndNavigate(context);
    });

    return Scaffold(
      backgroundColor: Color(0xFF1987FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo and text widgets
          ],
        ),
      ),
    );
  }

  // Method to check user registration status and navigate accordingly
  void checkRegistrationAndNavigate(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Check if user is already signed in
    if (auth.currentUser != null) {
      try {
        final snapshot =
            await FirebaseFirestore.instance.collection("stores").get();
        final phoneNumbers =
            snapshot.docs.map((e) => e.data()["phoneNumber"]).toList();
        log(phoneNumbers.toString());
        log(auth.currentUser!.phoneNumber!);
        log(phoneNumbers.contains(auth.currentUser!.phoneNumber).toString());
        if (phoneNumbers.contains(auth.currentUser!.phoneNumber)) {
          // If user is a pharmacy, navigate to the pharmacy home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PharHomePage()),
          );
          return;
        }
        // If user is not a pharmacy, navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PatHomePage()),
        );
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        return;
      }
      // Retrieve user data from Firestore
    }
    // If user is not signed in, navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WalkthroughPage()),
    );
  }
}
