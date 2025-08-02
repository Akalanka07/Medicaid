import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bloodrequest.dart'; // Import the BloodRequestPage

class BloodDetailsPage extends StatefulWidget {
  @override
  _BloodDetailsPageState createState() => _BloodDetailsPageState();
}

class _BloodDetailsPageState extends State<BloodDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('blood_requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bloodRequests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bloodRequests.length,
            itemBuilder: (context, index) {
              final bloodRequest = bloodRequests[index];
              final bloodGroup = bloodRequest['bloodGroup'];
              final message = bloodRequest['message'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        index % 2 == 0 ? Colors.blue[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blood Group: $bloodGroup',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Message: $message',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BloodRequestPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BloodDetailsPage(),
  ));
}
