import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool value = false;

class Firestore {
  static Future<void> createNewUser(User user) async {
    final newUserDoc = {
      'admin': false,
      'name': user.displayName,
      'email': user.email,
      'userID': user.uid.toString(),
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(newUserDoc);
  }
}