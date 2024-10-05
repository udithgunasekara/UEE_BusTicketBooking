import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/common/testpage.dart';

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
      initialRoute: '/home',
      routes: {'/home': (context) => const testPage()},
    );
  }
}
