import 'package:flutter/material.dart';

import '../home/home.dart';
import '../profile/profile.dart';

class Root extends StatefulWidget {
  const Root({Key? key, required this.login}) : super(key: key);
  final bool login;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _widgetOptions = <Widget>[
      const Home(),
      widget.login ? const Profile() : const ProfileUnLogin(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFBFC4AA),
        // backgroundColor: const Color(0xFF363534),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex != 0 ? Icons.home_outlined : Icons.home,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex != 1 ? Icons.person_outline : Icons.person,
              size: 40,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF363534),
        unselectedItemColor: Color(0xFF363534),
        onTap: _onItemTapped,
      ),
    );
  }
}
