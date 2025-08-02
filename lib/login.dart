import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacytrackerapp/verifyotp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _bypass() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpPage(verificationId: "verificationId"),
        ));
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic handling of SMS (instant verification) - rare case
        await FirebaseAuth.instance.signInWithCredential(credential);
        // ... (Navigate to home screen if successful)
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to the OTP confirmation page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/logo.jpg',
              height: 100,
            ),
            SizedBox(height: 5),
            const Text(
              'MEDICAID',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 48.0,
                fontFamily: 'Overpass',
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Phone number cannot be empty' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCode,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
