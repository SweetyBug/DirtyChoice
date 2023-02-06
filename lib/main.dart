import 'package:dirtychoice/auth_screen/sign_in_screen.dart';
import 'package:dirtychoice/auth_screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'root/root.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // func();
  runApp(const RestartWidget(
    child: MyApp(),
  ));
}

// func() {
//   final firestoreInstance = FirebaseFirestore.instance;
//   firestoreInstance.collection("quiz").add({
//     "title": "Поэзия",
//     "description": "Имеет свойство повторяться",
//     "questions": [
//       {
//         'title': 'Можно ли Сашу Чёрного назвать поэтом Серебряного века русской литературы?',
//         'answers': [
//           {
//             'title': 'Да',
//             'is_right': true,
//           },
//           {
//             'title': 'Нет',
//             'is_right': false,
//           },
//         ],
//       },
//       {
//         'title': 'Выберите из списка настоящие фамилию, имя и отчество Саши Чёрного.',
//         'answers': [
//           {
//             'title': 'Гликберг Александр Михайлович',
//             'is_right': true,
//           },
//           {
//             'title': 'Гутенберг Александр Иванович',
//             'is_right': false,
//           },
//         ],
//       },
//     ],
//   }).then((value) {
//     print(value.id);
//     print(value.path);
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static bool loginCheck() {
    bool login = false;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is currently signed out!');
    } else {
      login = true;
      print('User is signed in!');
    }
    print(login);
    return login;
  }

  @override
  Widget build(BuildContext context) {
    print(loginCheck());
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.blueGrey,
        // primarySwatch: Color(0xFFBFC4AA),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFBFC4AA),
          secondary: const Color(0xFF363534),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => Root(
              login: loginCheck(),
            ),
        SignInScreen.id: (context) => const SignInScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
      },
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<RestartWidgetState>()?.restartApp();
  }

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

class RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
