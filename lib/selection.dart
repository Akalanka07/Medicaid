import 'package:flutter/material.dart';
import 'package:pharmacytrackerapp/regph.dart';
import 'package:pharmacytrackerapp/regpa.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Select your account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegPh()), // Replace with your pharmacist registration page
                      );
                    },
                    child: Container(
                      width: 327,
                      height: 115,
                      color: Color(0xFFB1C9F5),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Image.asset(
                              'assets/unnamed.jpg',
                              width: 115,
                              height: 158,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'I am a pharmacist',
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Register as a pharmacy so you can sell and',
                                ),
                                Text(
                                  'manage your drugs on the app',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegPa()), // Replace with your patient registration page
                      );
                    },
                    child: Container(
                      width: 327,
                      height: 115,
                      color: Color(0xFFB1C9F5),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Image.asset(
                              'assets/patient.jpg',
                              width: 115,
                              height: 158,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'I am a patient',
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Register as a patient so you can find',
                                ),
                                Text(
                                  'pharmacies and drugs',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
