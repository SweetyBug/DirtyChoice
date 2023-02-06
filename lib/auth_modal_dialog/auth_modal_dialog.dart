import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_services/firestore.dart';
import '../main.dart';

class AuthModalDialog extends StatefulWidget {
  const AuthModalDialog({Key? key}) : super(key: key);

  @override
  State<AuthModalDialog> createState() => _AuthModalDialogState();
}

class _AuthModalDialogState extends State<AuthModalDialog> {
  var isLoading = false;
  var statusPhrase = 'Loading...';

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    await loginProcess();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loginProcess() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      setState(() {
        statusPhrase = 'Google sign in was aborted';
      });
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // If isNewUser create Firestore document for user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        if (userCredential.user == null) {
          setState(() {
            statusPhrase = 'Unexpected sign in error';
          });
          return;
        }
        await Firestore.createNewUser(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        statusPhrase = '${e.message ?? ''}\nError code: ${e.code}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Войдите с помощью Google',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (isLoading) Center(child: Text(statusPhrase)),
                  const Divider(),
                  Center(
                    child: ElevatedButton(
                      onPressed: (){
                        if(!isLoading){
                          login().then((value) {
                            RestartWidget.restartApp(context);
                          });
                        }
                      },
                      child: const Text('Войти'),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
