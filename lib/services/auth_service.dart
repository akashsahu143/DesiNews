import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Create or update user profile in Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'last_login': FieldValue.serverTimestamp(),
            'created_at': FieldValue.serverTimestamp(), // Set only on creation
          }, SetOptions(merge: true));
        }
        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}




  // Phone Number (OTP) Authentication
  Future<void> verifyPhoneNumber(String phoneNumber, Function(PhoneAuthCredential) verificationCompleted, Function(FirebaseAuthException) verificationFailed, Function(String, int?) codeSent, Function(String) codeAutoRetrievalTimeout) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<User?> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Create or update user profile in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "phone": user.phoneNumber,
          "last_login": FieldValue.serverTimestamp(),
          "created_at": FieldValue.serverTimestamp(), // Set only on creation
        }, SetOptions(merge: true));
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


