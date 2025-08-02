// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'storeupdate.dart'; // Import the StoreUpdatePage

class Store {
  final String storeName;
  final String storeAddress;
  final String phoneNumber;
  final String currentLocation;

  Store({
    required this.storeName,
    required this.storeAddress,
    required this.phoneNumber,
    required this.currentLocation,
  });

  Store copyWith({
    String? storeName,
    String? storeAddress,
    String? phoneNumber,
    String? currentLocation,
  }) {
    return Store(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'storeName': storeName,
      'storeAddress': storeAddress,
      'phoneNumber': phoneNumber,
      'currentLocation': currentLocation,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      storeName: map['storeName'] as String,
      storeAddress: map['storeAddress'] as String,
      phoneNumber: map['phoneNumber'] as String,
      currentLocation: map['currentLocation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) =>
      Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(storeName: $storeName, storeAddress: $storeAddress, phoneNumber: $phoneNumber, currentLocation: $currentLocation)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;

    return other.storeName == storeName &&
        other.storeAddress == storeAddress &&
        other.phoneNumber == phoneNumber &&
        other.currentLocation == currentLocation;
  }

  @override
  int get hashCode {
    return storeName.hashCode ^
        storeAddress.hashCode ^
        phoneNumber.hashCode ^
        currentLocation.hashCode;
  }
}

class PhProfilePage extends StatefulWidget {
  @override
  _PhProfilePageState createState() => _PhProfilePageState();
}

class _PhProfilePageState extends State<PhProfilePage> {
  late File _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    // Load the user's image from Firebase Storage
    _loadUserImage();
  }

  Future<Store> _loadStore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('stores')
        .where("phoneNumber",
            isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();
    return snapshot.docs.map((doc) => Store.fromMap(doc.data())).toList().first;
  }

  Future<void> _loadUserImage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref('pharmacist_images/user_image.jpg');
      final url = await ref.getDownloadURL();
      setState(() {
        _imageUrl = url;
      });
    } catch (error) {
      print('Error loading user image: $error');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    // ignore: unnecessary_null_comparison
    if (_imageFile == null) return;

    final Reference storageReference =
        FirebaseStorage.instance.ref('pharmacist_images/user_image.jpg');
    final UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() => null);

    // Update Firestore with the new image URL
    final url = await storageReference.getDownloadURL();
    FirebaseFirestore.instance
        .collection('users')
        .doc('pharmacist')
        .update({'image': url});
  }

  Future<void> _deleteImage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref('pharmacist_images/user_image.jpg');
      await ref.delete();
      setState(() {
        _imageUrl = null;
      });
      // Update Firestore to remove the image URL
      FirebaseFirestore.instance
          .collection('users')
          .doc('pharmacist')
          .update({'image': null});
    } catch (error) {
      print('Error deleting image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: _loadStore(),
            builder: (BuildContext context, AsyncSnapshot<Store> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose an option'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text('Take a picture'),
                                      onTap: () {
                                        _getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                    GestureDetector(
                                      child: Text('Select from gallery'),
                                      onTap: () {
                                        _getImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      snapshot.data!.storeName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hi, Welcome to Medicaid',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _uploadImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload),
                          SizedBox(width: 10),
                          Text('Upload Image'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_imageUrl != null)
                      GestureDetector(
                        onTap: () {
                          _deleteImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 10),
                            Text('Delete Image'),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navigate to StoreUpdatePage when "Update Profile" is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoreUpdatePage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text('Update Profile'),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Text('No data found');
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color.fromRGBO(25, 135, 251, 0.23),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 2, // Index of the Profile icon
            onTap: (index) {
              // Handle navigation to different tabs here
              // Index 0: Home, Index 1: Store, Index 2: Profile
              // Example:
              if (index == 0) {
                // Navigate to Home Page
              } else if (index == 1) {
                // Navigate to Store Page
              } else if (index == 2) {
                // Navigate to Pharm
              }
            }));
  }
}
