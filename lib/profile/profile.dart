import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dirtychoice/auth_screen/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../admin_panel/admin_panel.dart';
import '../auth_modal_dialog/auth_modal_dialog.dart';
import '../firebase_services/firebase_servises.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isAdmin = false;

  getData() async {
    isAdmin = await FirebaseServices.currentUserIsAdmin();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 4.0,
            ),
          );
        }
        var userDocument = snapshot.data;
        return SafeArea(
          child: Column(
            children: [
              const Text(
                'Профиль',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Color(0xFFF2E5E5),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL ??
                                      ''),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userDocument!["name"] ?? "User",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  userDocument!["email"] ?? "User@mail.ru",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      userDocument!['admin'] ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const AdminPanel()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25)),
                              child: Icon(
                                Icons.settings,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ) : Container() ?? Container(),

                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  signOut().then((value) {
                    RestartWidget.restartApp(context);
                  });
                },
                child: const Text('Выйти'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileUnLogin extends StatelessWidget {
  const ProfileUnLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Авторизуйтесь'),
        ElevatedButton(
          onPressed: () {
            //
            Navigator.of(context).pushReplacementNamed(SignInScreen.id);
          },
          child: const Text('Войти'),
        ),
      ],
    );
  }
}
