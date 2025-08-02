import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage

class WalkthroughPage extends StatelessWidget {
  const WalkthroughPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 200), // Add space from the top

                // Image with specified size
                Image.asset(
                  'assets/maskgroup.jpg', // Replace with your image asset path
                  width: 338,
                  height: 345,
                ),

                SizedBox(height: 50), // Add space below the image

                // Text with rectangular background
                Container(
                  width: 400, // Adjust width as needed
                  padding:
                      EdgeInsets.all(16), // Add padding inside the container
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9), // Set background color to D9D9D9
                    borderRadius:
                        BorderRadius.circular(28), // Set edge radius to 28
                  ),
                  child: const Text(
                    '“MEDIC AID” assists user to search by the medicine name to get the nearest pharmacy store where the medicine is available.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87, // Set text color to black
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), // Navigate to LoginPage
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue, // Set background color to blue
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
