import 'package:dirtychoice/auth_screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_modal_dialog/auth_modal_dialog.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "sign_in_screen";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  late final FocusNode _focusNodePassword;

  @override
  void initState() {
    _focusNodePassword = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    super.dispose();
  }

  _showSimpleModalDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AuthModalDialog();
        });
  }

  Future<void> signIn({required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()) {
      return;
    }
    try{
      signIn(email: _email, password: _password);
    } catch (e) {
      print(e);
    }
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
                        FocusScope.of(context).requestFocus(_focusNodePassword);
                      },
                      onSaved: (value) {
                        _email = value!.trim();
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
                        Navigator.of(context).pushReplacementNamed(SignUpScreen.id);
                      },
                      child: Text("Sign Up", style: TextStyle(color: Color(0xFF1C315E)),),
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
                  child: Text("Sign In", style: TextStyle(color: Color(0xFF1C315E), fontSize: 20),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
