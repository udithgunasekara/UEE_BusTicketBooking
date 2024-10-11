import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/common/onboarding_page.dart';

class Loginwidget extends StatefulWidget {
  const Loginwidget({super.key});

  @override
  State<Loginwidget> createState() => _LoginwidgetState();
}

class _LoginwidgetState extends State<Loginwidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String? _errormessage;
  // ignore: prefer_typing_uninitialized_variables
  var error;

  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    setState(() {
      _isEmailEmpty = _emailController.text.isEmpty;
      _isPasswordEmpty = _passwordController.text.isEmpty;
    });

    if (_isEmailEmpty || _isPasswordEmpty) {
      setState(() {
        _errormessage = "Please fill in all fields";
      });
      return;
    } else {
      error = await _auth.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (error != null) {
        setState(() {
          _errormessage = error;
        });
      } else {
        User? user = FirebaseAuth.instance.currentUser;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Adjust the collection path if needed
            .doc(user!.uid)
            .get();
        bool role = userDoc.get('isPassenger');
        
        _setUserIDInPreferences(user!.uid, role);
        Navigator.of(context).pushAndRemoveUntil(
          /* MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false, */
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> _setUserIDInPreferences(String userId, bool role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', userId);
    await prefs.setBool('role', role);
    if(!role){
      await prefs.setBool('temprole', true);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errormessage = "Please enter your email address to reset password";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent. Please check your inbox.')),
      );
    } catch (e) {
      setState(() {
        _errormessage = "Failed to send password reset email. Please try again.";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border:
            Border.all(width: 3, color: const Color.fromARGB(255, 71, 145, 2)),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: Colors.green[200],
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 80, 80, 80).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 8), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          //sign in form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                //email or username
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    //default label style
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(169, 34, 116, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    //floating label style
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,

                    //border when field if focused
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 4.0)),

                    //border when ther is no input and its not foucesed
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isEmailEmpty
                                ? Colors.red
                                : const Color.fromARGB(255, 33, 116, 1),
                            width: 3.0)),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(
                  height: 30,
                ),

                //password
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    //default label style
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(169, 34, 116, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    //floating label style
                    floatingLabelStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    fillColor: Colors.white,
                    filled: true,
                    //border when field if focused
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 4.0)),

                    //border when ther is no input and its not foucesed
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isEmailEmpty
                                ? Colors.red
                                : const Color.fromARGB(255, 33, 116, 1),
                            width: 3.0)),

                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  controller: _passwordController,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _errormessage != null
                      ? Text(
                          _errormessage!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      : const SizedBox.shrink(),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: _resetPassword,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue[700]),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                //Sign in button
                ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 15,
                ),
                //other login methods
                const Text(
                  "Other Login Methods",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata_outlined,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // New User? Register
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      "Don't have an account? Register here",
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
