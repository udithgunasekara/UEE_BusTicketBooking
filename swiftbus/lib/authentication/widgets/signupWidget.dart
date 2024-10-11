import 'package:flutter/material.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';

class Signupwidget extends StatefulWidget {
  const Signupwidget({super.key});
  @override
  State<Signupwidget> createState() => _SignupwidgetState();
}

class _SignupwidgetState extends State<Signupwidget> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool isPassenger = true;
  String? _errormessage;

  //booleans to track if field is empty
  bool _isFirstNameEmpty = false;
  bool _isLastNameEmpty = false;
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _isConPasswordEmpty = false;
  bool _isPasswordVisible = false;


  Future<void> _signup() async {
    setState(() {
      _isFirstNameEmpty = _firstnameController.text.isEmpty;
      _isLastNameEmpty = _lastnameController.text.isEmpty;
      _isEmailEmpty = _emailController.text.isEmpty;
      _isPasswordEmpty = _passwordController.text.isEmpty;
      _isConPasswordEmpty = _conPasswordController.text.isEmpty;
    });

    if(_isFirstNameEmpty ||_isLastNameEmpty ||_isEmailEmpty ||_isPasswordEmpty || _isConPasswordEmpty){
      setState(() {
          _errormessage = "Please fill in all fields";
      });
      return;
    }

    if(_passwordController.text == _conPasswordController.text){
        var error = await _auth.registerWithEmailAndPassword(_emailController.text, _passwordController.text,_firstnameController.text, _lastnameController.text, isPassenger);
        if(error != null){
          setState(() {
            _errormessage = error;
          });
        }else{
          Navigator.pushReplacementNamed(context, '/login');
        }
      }else{
        setState(() {
          _errormessage = "Passwords do not match. Re-enter password";
        });
      }
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 3, color: const Color.fromARGB(255, 71, 145, 2)),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Colors.green[200],
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 80, 80, 80)
                            .withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset:
                            const Offset(0, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Toggle Buttons for Passenger/Conductor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPassenger = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: isPassenger
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(26),
                                    ),
                                    boxShadow: [
                                      isPassenger
                                          ? BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 10,
                                              offset: const Offset(-2, 4),
                                            )
                                          : const BoxShadow(
                                              color: Colors.transparent),
                                    ]),
                                child: Center(
                                  child: Text(
                                    "Passenger",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isPassenger
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPassenger = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: !isPassenger
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(26),
                                    ),
                                    boxShadow: [
                                      !isPassenger
                                          ? BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 10,
                                              offset: const Offset(2, 4),
                                            )
                                          : const BoxShadow(
                                              color: Colors.transparent),
                                    ]),
                                child: Center(
                                  child: Text(
                                    "Conductor",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: !isPassenger
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Sign-in form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            
                            Text(
                              "You are signing up as a ${isPassenger ? 'Passenger' : 'Conductor'}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.orange[800],
                              ),
                            ),

                            const SizedBox(height: 10),


                            // FirstName
                            TextField(
                                decoration: InputDecoration(
                                  labelText: "First Name",
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
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  filled: true,

                                  //border when field if focused
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.orange, width: 4.0)
                                  ),

                                  //border when ther is no input and its not foucesed
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: _isFirstNameEmpty 
                                      ? Colors.red
                                      :const Color.fromARGB(255, 33, 116, 1),
                                      width: 3.0)
                                  ),
                                ),
                                controller: _firstnameController,
                              ),

                            const SizedBox(height: 20),
                            // LastName
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Last Name",
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
                                fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                                filled: true,

                                //border when field if focused
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: Colors.orange, width: 4.0)),

                                //border when ther is no input and its not foucesed
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:  BorderSide(
                                    color: _isLastNameEmpty 
                                      ? Colors.red
                                      :const Color.fromARGB(255, 33, 116, 1),
                                    width: 3.0)),
                              ),
                              controller: _lastnameController,
                            ),
                            const SizedBox(height: 20),
                            // Email
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
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,

                              //border when field if focused
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 4.0)),

                              //border when ther is no input and its not foucesed
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:  BorderSide(
                                      color: _isEmailEmpty 
                                      ? Colors.red
                                      :const Color.fromARGB(255, 33, 116, 1),
                                      width: 3.0)),
                            ),
                            controller: _emailController,
                            ),

                            const SizedBox(height: 10),

                            //Password
                            TextField(
                              obscureText: _isPasswordVisible,
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
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 4.0)),

                                //border when ther is no input and its not foucesed
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:  BorderSide(
                                        color: _isPasswordEmpty 
                                      ? Colors.red
                                      :const Color.fromARGB(255, 33, 116, 1),
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

                            const SizedBox(height: 20),

                            // Confirm Password

                            TextField(
                              obscureText: _isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
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
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 4.0)),

                                //border when ther is no input and its not foucesed
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:  BorderSide(
                                        color: _isConPasswordEmpty 
                                      ? Colors.red
                                      :const Color.fromARGB(255, 33, 116, 1),
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
                              controller: _conPasswordController,
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

                            const SizedBox(height: 20),

                            ElevatedButton(
                                onPressed: _signup,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ),

                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                child: Text(
                                  "Already have an account? Log in",
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