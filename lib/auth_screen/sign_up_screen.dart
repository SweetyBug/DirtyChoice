import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dirtychoice/auth_screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_modal_dialog/auth_modal_dialog.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "sign_up_screen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _username = "";

  late final FocusNode _focusNodePassword;
  late final FocusNode _focusNodeUsername;

  @override
  void initState() {
    _focusNodePassword = FocusNode();
    _focusNodeUsername = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _focusNodeUsername.dispose();
    super.dispose();
  }

  _showSimpleModalDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AuthModalDialog();
        });
  }

  Future<void> signUp({required String email,
    required String username,
  required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid).set({
      'admin': false,
      "userID" : userCredential.user!.uid,
      "name" : username,
      "email" : email,
    });
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()) {
      return;
    }

    signUp(email: _email, username: _username, password: _password);

    _formKey.currentState!.save();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBFC4AA),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Color(0xFFEFF5F5), width: 4)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(

                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: "Enter Your Email",
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusNodeUsername);
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      onChanged: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Color(0xFFEFF5F5), width: 4)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      focusNode: _focusNodeUsername,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: "Enter Your Username",
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusNodePassword);
                      },
                      onSaved: (value) {
                        _username = value!.trim();
                      },
                      onChanged: (value) {
                        _username = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your username";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Color(0xFFEFF5F5), width: 4)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      focusNode: _focusNodePassword,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: "Enter Your password",
                      ),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      onFieldSubmitted: (_) {
                        _submit(context);
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value!.length < 6) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(SignInScreen.id);
                      },
                      child: Text("Sign In", style: TextStyle(color: Color(0xFF1C315E)),),
                    ),
                    Text("/", style: TextStyle(color: Color(0xFF1C315E)),),
                    TextButton(
                      onPressed: () {
                        _showSimpleModalDialog(context);
                      },
                      child: Text("Continue with Google", style: TextStyle(color: Color(0xFF1C315E)),),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    _submit(context);
                  },
                  child: Text("Sign Up", style: TextStyle(color: Color(0xFF1C315E), fontSize: 20),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
