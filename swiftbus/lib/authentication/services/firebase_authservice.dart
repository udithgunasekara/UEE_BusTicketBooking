import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in with email and password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email' : return "The email address is not valid.";
        case 'user-disabled' : return "The user account has been disabled by an administrator.";
        case 'invalid-credential' : return "There is no user record corresponding to this credentials.Plese sign up.";
        case 'wrong-password' : return "The password is invalid for the given email.";
        case 'operation-not-allowed' : return "This operation is not allowed. You must enable this service in the console.";
        case 'too-many-requests' : return "Too many attempts. Try again later.";
        default : return e.code;
      }
    }catch (e) {
      return 'An unknown error has occurred. Please try again';
    }
  }

  //register user with email and password
  Future<String?> registerWithEmailAndPassword(
    String email, 
    String password,
    String firstname,
    String lastname,
    bool isPassenger,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if(user != null){
        await _firestore.collection('users').doc(user.uid).set({
          'firstname' : firstname,
          'lastname' : lastname,
          'email' : email,
          'uid' : user.uid,
          'isPassenger' : isPassenger,
        });
      }
      return null;
    }on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email': return 'Invalid email address.';
        case 'email-already-in-use': return 'This email is already in use.';
        case 'weak-password': return 'Password is too weak.';
        case 'operation-not-allowed': return 'Email/password accounts are not enabled.';
        case 'user-disabled': return 'This user account has been disabled.';
        case 'too-many-requests': return 'Too many attempts, try again later.';
        case 'network-request-failed': return 'Network error, please try again.';
        case 'internal-error': return 'Internal error, please try again.';
        default: return 'An unknown error occurred.';
      }

    }catch (e) {
      return 'An unknown error has occurred. Please try again.';
    }
    
  }

  Future <void> signOut() async {
    await _auth.signOut();
  }
}