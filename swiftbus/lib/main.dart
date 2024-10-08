import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/authentication/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftbus/authentication/signupPage.dart';
import 'package:swiftbus/common/Home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/signup',
      routes: {
        '/home': (context) => const Home(),
        '/login' : (context) => const LoginPage(),
        '/signup' : (context) => const Signuppage(),
      }
    );
  }
}
