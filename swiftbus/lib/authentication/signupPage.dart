import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiftbus/authentication/widgets/signupWidget.dart';

class Signuppage extends StatelessWidget {
  const Signuppage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Orange header with "Sign In" text
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(
                          MediaQuery.of(context).size.width, 90),
                      bottomRight: Radius.elliptical(
                          MediaQuery.of(context).size.width, 90),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 34,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign up form
                const Signupwidget(),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
