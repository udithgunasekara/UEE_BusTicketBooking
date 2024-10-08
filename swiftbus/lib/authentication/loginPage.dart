import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiftbus/authentication/widgets/LoginWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        //top arc
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(
                                    (MediaQuery.of(context).size.width), 90),
                                bottomRight: Radius.elliptical(
                                    (MediaQuery.of(context).size.width), 90)),
                          ),
                          child: const Center(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                  fontSize: 44,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        const Text(
                          "Log inot your account ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.orange,
                              ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //container for login
                        const Loginwidget(),
                      ],
                    ),
                    //png image
                    const SizedBox(height: 13),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: Image.asset(
                        'assets/bus_queue.png',
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
            )
        )
      );
  }
}
