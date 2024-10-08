import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:swiftbus/common/testpage.dart';
import 'package:google_fonts/google_fonts.dart';
=======
import 'package:swiftbus/common/Home.dart';
>>>>>>> 1e4b4d3a717964530de31605ee9a5697a838f1ca

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
      initialRoute: '/home',
      routes: {'/home': (context) => const Home()},
    );
  }
}
