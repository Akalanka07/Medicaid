import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for LengthLimitingTextInputFormatter
// Import the PhProfilePage

class StoreUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Arrow button to navigate back
        leading: IconButton(
          icon: Icon(Icons
              .arrow_back_ios), // Use arrow_back_ios icon for arrowhead only
          onPressed: () {
            // Navigate back to PhProfilePage when arrow button is clicked
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading:
            false, // Hide the automatically generated leading widget
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            // Contact Number Label
            Text(
              'Contact Number',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC4C4C4), // Text color
              ),
            ),
            SizedBox(height: 10.0),
            // Contact Number Input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number, // Allow only numbers
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10)
                      ], // Limit to 10 characters
                      decoration: InputDecoration(
                        hintText: 'Enter your contact number',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.edit, size: 20.0), // Edit icon
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Address Label
            Text(
              'Address',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC4C4C4), // Text color
              ),
            ),
            SizedBox(height: 10.0),
            // Address Input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 109.0,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.edit, size: 20.0), // Edit icon
                ],
              ),
            ),
            SizedBox(
                height:
                    40.0), // Increased the height of SizedBox for more space
            Spacer(), // Push Submit button to the bottom
            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Add submit logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1987FB),
                minimumSize: Size(330.6, 45),
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StoreUpdatePage(),
  ));
}
