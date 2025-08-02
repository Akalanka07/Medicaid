import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestPage extends StatefulWidget {
  @override
  _BloodRequestPageState createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  String? selectedBloodGroup;
  String message = '';

  void _postBloodRequest() {
    if (selectedBloodGroup != null && message.isNotEmpty) {
      // Construct the data to be uploaded to Firestore
      Map<String, dynamic> requestData = {
        'bloodGroup': selectedBloodGroup,
        'message': message,
        'timestamp': DateTime.now(), // Add timestamp for ordering
      };

      // Add the data to Firestore
      FirebaseFirestore.instance
          .collection('blood_requests')
          .add(requestData)
          .then((value) {
        // Show a success message or perform any other action
        print('Blood request posted successfully');
        // Navigate back to previous page
        Navigator.pop(context);
      }).catchError((error) {
        // Handle errors
        print('Failed to post blood request: $error');
        // Show an error dialog or message to the user
      });
    } else {
      // Show an error message if required fields are not filled
      print('Please select blood group and enter message');
      // Optionally, show an error dialog or message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 40.0,
            left: 20.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 40.0,
                left: 20.0,
                right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Select your blood group',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Color(0xFFEEEEEE),
                          value: selectedBloodGroup,
                          onChanged: (value) {
                            setState(() {
                              selectedBloodGroup = value!;
                            });
                          },
                          items: bloodGroups.map((String bloodGroup) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                bloodGroup,
                                style: TextStyle(color: Colors.black),
                              ),
                              value: bloodGroup,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      if (selectedBloodGroup == null)
                        Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Write your message here',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your message here...',
                      hintStyle: TextStyle(color: Color(0xFFC4C4C4)),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _postBloodRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1987FB),
                      minimumSize: Size(330.6, 45),
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BloodRequestPage(),
  ));
}
