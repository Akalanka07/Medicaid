import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacytrackerapp/loginsuccess.dart';
import 'package:pharmacytrackerapp/splash.dart'; // Import FirebaseAuth

class VerifyOtpPage extends StatefulWidget {
  final String verificationId;

  const VerifyOtpPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  // Controllers for each digit of the OTP
  final TextEditingController digit1Controller = TextEditingController();
  final TextEditingController digit2Controller = TextEditingController();
  final TextEditingController digit3Controller = TextEditingController();
  final TextEditingController digit4Controller = TextEditingController();
  final TextEditingController digit5Controller = TextEditingController();
  final TextEditingController digit6Controller = TextEditingController();

  // Focus nodes for each digit text field
  late FocusNode digit1FocusNode;
  late FocusNode digit2FocusNode;
  late FocusNode digit3FocusNode;
  late FocusNode digit4FocusNode;
  late FocusNode digit5FocusNode;
  late FocusNode digit6FocusNode;

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes
    digit1FocusNode = FocusNode();
    digit2FocusNode = FocusNode();
    digit3FocusNode = FocusNode();
    digit4FocusNode = FocusNode();
    digit5FocusNode = FocusNode();
    digit6FocusNode = FocusNode();
    // Add listeners to move focus to the next field automatically after each input
    digit1Controller
        .addListener(() => _moveToNextField(digit1Controller, digit2FocusNode));
    digit2Controller
        .addListener(() => _moveToNextField(digit2Controller, digit3FocusNode));
    digit3Controller
        .addListener(() => _moveToNextField(digit3Controller, digit4FocusNode));
    digit4Controller
        .addListener(() => _moveToNextField(digit4Controller, digit5FocusNode));
    digit5Controller
        .addListener(() => _moveToNextField(digit5Controller, digit6FocusNode));
    digit6Controller
        .addListener(() => _moveToNextField(digit6Controller, null));
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    digit1Controller.dispose();
    digit2Controller.dispose();
    digit3Controller.dispose();
    digit4Controller.dispose();
    digit5Controller.dispose();
    digit6Controller.dispose();
    digit1FocusNode.dispose();
    digit2FocusNode.dispose();
    digit3FocusNode.dispose();
    digit4FocusNode.dispose();
    digit5FocusNode.dispose();
    digit6FocusNode.dispose();
    super.dispose();
  }

  // Function to move focus to the next field
  void _moveToNextField(
      TextEditingController controller, FocusNode? nextFocusNode) {
    if (controller.text.length == 1) {
      if (nextFocusNode != null) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      } else {
        // Submit OTP or perform any action when the last digit is entered
        // For example: verify OTP
        _verifyOtp();
      }
    }
  }

  // Function to verify OTP (You can replace this with your own logic)
  void _verifyOtp() async {
    // Combine all OTP digits
    String otp = digit1Controller.text +
        digit2Controller.text +
        digit3Controller.text +
        digit4Controller.text +
        digit5Controller.text +
        digit6Controller.text;

    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // ... (Navigate to home screen if successful)
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginSuccessPage(),
          ));
    } on FirebaseAuthException catch (e) {
      // Handle OTP verification failures
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the verification code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            const Text(
              'We just sent you a verification code',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF090F47),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Widget for each digit of the OTP
                _buildDigitInputField(digit1Controller, digit1FocusNode),
                _buildDigitInputField(digit2Controller, digit2FocusNode),
                _buildDigitInputField(digit3Controller, digit3FocusNode),
                _buildDigitInputField(digit4Controller, digit4FocusNode),
                _buildDigitInputField(digit5Controller, digit5FocusNode),
                _buildDigitInputField(digit6Controller, digit6FocusNode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a text field for a single digit of the OTP
  Widget _buildDigitInputField(
      TextEditingController controller, FocusNode focusNode) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
