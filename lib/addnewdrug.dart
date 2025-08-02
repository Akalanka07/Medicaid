import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddNewDrugPage extends StatefulWidget {
  @override
  _AddNewDrugPageState createState() => _AddNewDrugPageState();
}

class _AddNewDrugPageState extends State<AddNewDrugPage> {
  final TextEditingController drugNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drug'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveDrugData(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Drug Name', drugNameController),
              SizedBox(height: 16),
              _buildImageUploadSection(),
              SizedBox(height: 16),
              _buildTextField('Quantity', quantityController),
              SizedBox(height: 16),
              _buildTextField('Price', priceController),
              SizedBox(height: 16),
              _buildTextField('Description', descriptionController,
                  maxLines: 4),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveDrugData(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1987FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _takePicture(context);
          },
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.add_a_photo, color: Colors.grey[600]),
                ),
        ),
      ],
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveDrugData(BuildContext context) async {
    final String drugName = drugNameController.text.trim();
    final String quantity = quantityController.text.trim();
    final String price = priceController.text.trim();
    final String description = descriptionController.text.trim();

    if (drugName.isNotEmpty &&
        quantity.isNotEmpty &&
        price.isNotEmpty &&
        description.isNotEmpty) {
      try {
        String imageUrl = '';
        if (_imageFile != null) {
          imageUrl = await _uploadImageToFirebaseStorage(_imageFile!);
        }

        await FirebaseFirestore.instance.collection('drugs').add({
          'name': drugName,
          'quantity': quantity,
          'price': price,
          'description': description,
          'imageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Drug added successfully!')),
        );

        _clearFields();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add drug. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in all the fields before submitting.')),
      );
    }
  }

  Future<String> _uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Failed to upload image to Firebase Storage: $e');
      return '';
    }
  }

  void _clearFields() {
    drugNameController.clear();
    quantityController.clear();
    priceController.clear();
    descriptionController.clear();
    setState(() {
      _imageFile = null;
    });
  }
}
