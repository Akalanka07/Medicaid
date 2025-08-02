import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import your Firebase options here
import 'login.dart';
import 'splash.dart'; // Import the SplashScreen
import 'verifyotp.dart';
import 'walkthrough.dart';
import 'loginsuccess.dart'; // Import the LoginSuccessPage
import 'regph.dart'; // Import the RegistrationPharmacist page
import 'regpa.dart'; // Import the RegistrationPatient page
import 'store.dart'; // Import the Store page
import 'addnewdrug.dart'; // Import the AddDrugPage
import 'pharhome.dart'; // Import the PharHomePage
import 'pathome.dart'; // Import the PatHomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splash', // Set initial route to splash screen
      routes: {
        '/splash': (context) =>
            SplashScreen(), // Define route for splash screen
        '/walkthrough': (context) =>
            const WalkthroughPage(), // Define route for walkthrough page
        '/login': (context) => LoginPage(), // Define route for login page
        '/verifyotp': (context) => VerifyOtpPage(
              verificationId:
                  ModalRoute.of(context)!.settings.arguments as String,
            ), // Pass verificationId argument
        '/loginsuccess': (context) =>
            LoginSuccessPage(), // Define route for login success page
        '/regph': (context) =>
            RegPh(), // Define route for pharmacist registration page
        '/regpa': (context) =>
            RegPa(), // Define route for patient registration page
        '/store': (context) => StorePage(), // Define route for the store page
        '/addnewdrug': (context) =>
            AddNewDrugPage(), // Define route for the add new drug page
        '/pharhome': (context) =>
            PharHomePage(), // Define route for pharmacist home screen
        '/pathome': (context) =>
            PatHomePage(), // Define route for patient home screen
        // Add other routes for your pages here
        // '/home': (context) => HomePage(),
        // '/other_page': (context) => OtherPage(),
      },
    );
  }
}
