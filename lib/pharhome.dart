import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacytrackerapp/pathome.dart';

import 'phfeedback.dart'; // Import PhFeedback page
import 'store.dart'; // Import StorePage
import 'phprofile.dart'; // Import PharmacistProfilePage
import 'blooddetails.dart'; // Import the BloodDetails page

class PharHomePage extends StatefulWidget {
  @override
  _PharHomePageState createState() => _PharHomePageState();
}

class _PharHomePageState extends State<PharHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0:
        // Navigate to Home page
        break;
      case 1:
        // Navigate to Store page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StorePage(),
          ),
        );
        break;
      case 2:
        // Navigate to Feedback page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhFeedback(),
          ),
        );
        break;
      case 3:
        // Navigate to Profile page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhProfilePage(),
          ),
        );
        break;
      default:
    }
  }

  void _navigateToBloodDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BloodDetailsPage(),
      ),
    );
  }

  final TextEditingController _searchController = TextEditingController();

  List<Drug> res = [];

  @override
  void initState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          res.clear();
        });
        return;
      }
      if (_searchController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('drugs')
            .get()
            .then((QuerySnapshot querySnapshot) {
          setState(() {
            res = querySnapshot.docs
                .map((e) => Drug.fromMap(e.data() as Map<String, dynamic>))
                .toList()
                .where((element) => element.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                .toList();
          });
        });
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            backgroundColor: Color(0xFF1987FB), // Change the app bar color here
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Please bring prescription with you while visiting',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'store for medicine',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 350, // Adjust the width of the search bar
                          height: 44.89,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(Icons.search,
                                    color: Color(0xFF090F47), size: 18),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search Medicine & Healthcare products',
                                    hintStyle: TextStyle(
                                        fontSize: 13, color: Color(0xFF090F47)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(Icons.filter_alt,
                                    color: Color(0xFF090F47), size: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: res.isNotEmpty
            ? ListView.builder(
                itemCount: res.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(res[index].imageUrl),
                      title: Text(res[index].name),
                      subtitle: Text(res[index].description),
                      trailing: Text('₹${res[index].price}'),
                    ),
                  );
                })
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blood Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToBloodDetailsPage();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue, // Example color, you can change it
                      ),
                      child: Image.asset(
                        'assets/blood.jpg', // Path to your blood image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Add your body content widgets here
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Color for the selected item
        unselectedItemColor: Colors.black, // Color for the unselected items
        backgroundColor:
            Color(0xFF1987FB), // Background color of the BottomNavigationBar
        onTap: _onItemTapped,
      ),
    );
  }
}
