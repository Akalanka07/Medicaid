// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacytrackerapp/map.dart';

import 'patfeedback.dart'; // Import PhFeedback page
import 'patprofile.dart'; // Import PatProfilePage page

class Drug {
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String quantity;
  Drug({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  Drug copyWith({
    String? name,
    String? description,
    String? imageUrl,
    String? price,
    String? quantity,
  }) {
    return Drug(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      price: map['price'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Drug(name: $name, description: $description, imageUrl: $imageUrl, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant Drug other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}

class PatHomePage extends StatefulWidget {
  @override
  _PatHomePageState createState() => _PatHomePageState();
}

class _PatHomePageState extends State<PatHomePage> {
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
        // Navigate to Feedback page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatFeedback()),
        );
        break;
      case 2:
        // Navigate to Profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatProfilePage()),
        );
        break;
      default:
    }
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
          log(querySnapshot.docs.length.toString());
          querySnapshot.docs.map((e) {
            log(e.toString());
          });
          setState(() {
            res = querySnapshot.docs
                .map((e) => Drug.fromMap(e.data() as Map<String, dynamic>))
                .toList()
                .where((element) => element.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
                .toList();
          });
        }).catchError(
          (error) => log('Error: $error'),
        );
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
                        IconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Mappage())),
                            icon: Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                            ))
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
                  // Add your body content widgets here

                  SizedBox(height: 10),
                  Image.asset(
                    'assets/blood.jpg', // Add the path to your image asset
                    width: MediaQuery.of(context)
                        .size
                        .width, // Adjust the width as needed
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
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
