import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  static Future<void> logout() async {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  static Future<bool> currentUserIsAdmin() async {
    var a = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
   return a.get('admin') as bool;
  }
}