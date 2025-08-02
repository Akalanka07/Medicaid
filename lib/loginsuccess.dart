import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacytrackerapp/selection.dart';
import 'package:pharmacytrackerapp/splash.dart';

class LoginSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login.jpg',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20.0),
            Text(
              'Phone number Verified',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Navigate to SelectionPage when the button is pressed
                final isPat = await FirebaseFirestore.instance
                    .collection("patient")
                    .where("Contact Number",
                        isEqualTo:
                            FirebaseAuth.instance.currentUser!.phoneNumber)
                    .get()
                    .then((value) => value.docs.isNotEmpty);
                final isPhar = await FirebaseFirestore.instance
                    .collection("stores")
                    .where("phoneNumber",
                        isEqualTo:
                            FirebaseAuth.instance.currentUser!.phoneNumber)
                    .get()
                    .then((value) => value.docs.isNotEmpty);
                if (isPat || isPhar) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(330.6, 45), // Set button size
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 0.0), // Add more additional space below the button
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginSuccessPage(),
    debugShowCheckedModeBanner: false, // Hide debug banner
  ));
}
