import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/bus_details_screen.dart';
import 'package:swiftbus/BusSearch/screen/busSearch/search_buses_screen.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/show_bus_details_screen.dart';
import 'package:swiftbus/authentication/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftbus/authentication/signupPage.dart';
import 'package:swiftbus/busRegistration/busRegistrationPage.dart';
import 'package:swiftbus/busRegistration/conducterHome.dart';
import 'package:swiftbus/common/Home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      navigatorKey: navigatorKey, // Attach the global key to the MaterialApp
      home: const Home(), // Set the initial screen
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: '/busregistration',
      routes: {
        '/home': (context) => const Home(),
        '/login' : (context) => const LoginPage(),
        '/signup' : (context) => const Signuppage(),
        '/busregistration' : (context) => const Busregistration(),
        '/chome': (context) => const Conducterhome(),
        '/bustest': (context) => SearchBusesScreen(),
      }
    );
  }
}