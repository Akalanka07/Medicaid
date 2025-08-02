import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatFeedback extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1987FB),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: feedbackController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write your feedback text here...',
                      hintStyle: TextStyle(
                        color: Color(0xFF090F47).withOpacity(0.45),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 330.6,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        submitFeedback(context);
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
      ),
    );
  }

  Future<void> submitFeedback(BuildContext context) async {
    String feedbackText = feedbackController.text.trim();

    if (feedbackText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'text': feedbackText,
          'timestamp': Timestamp.now(),
        });
        // Feedback submitted successfully
        Navigator.pop(context);
      } catch (e) {
        // Error submitting feedback
        print('Error submitting feedback: $e');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback. Please try again.'),
          ),
        );
      }
    } else {
      // Show error message if feedback text is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your feedback before submitting.'),
        ),
      );
    }
  }
}
