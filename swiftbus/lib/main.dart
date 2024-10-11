import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/busSearch/search_buses_screen.dart';
import 'package:swiftbus/authentication/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swiftbus/authentication/signupPage.dart';
import 'package:swiftbus/busRegistration/busRegistrationPage.dart';
import 'package:swiftbus/busRegistration/conducterHome.dart';
import 'package:swiftbus/common/Home.dart';
import 'package:swiftbus/common/onboarding_page.dart';

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
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return const OnboardingPage(); // Redirect to OnboardingPage when user is signed in
            } else {
              return const LoginPage();
            }
          },
        ), // Set the initial screen
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          // primaryColor: Color(0xFFFD6905), // Primary color (Orange)
          //accentColor: Color(0xFF129C38) // Accent color (Green)
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const Home(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const Signuppage(),
          '/busregistration': (context) => const Busregistration(),
          '/chome': (context) =>
              Conducterhome(user: FirebaseAuth.instance.currentUser),
          '/bustest': (context) => SearchBusesScreen(),
          '/onboarding': (context) => const OnboardingPage(),
        });
  }
}
