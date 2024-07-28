// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pizza_app/Login/Login.dart';
import 'package:pizza_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizza_app/HomeScreen/Cart.dart';
import 'package:pizza_app/HomeScreen/Favourite.dart';
import 'package:pizza_app/HomeScreen/Profile.dart';
import 'package:pizza_app/HomeScreen/Search.dart';
import 'package:pizza_app/HomeScreen/home.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 2;
  bool _isLoggedIn = false;

  static const List<Widget> _widgetOptions = <Widget>[
    Search(),
    Favourite(),
    Home(),
    Cart(),
    Profile()
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');
    
    setState(() {
      _isLoggedIn = uid != null;
    });
  }

  void _onItemTapped(int index) {
    if (_isLoggedIn) { 
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoggedIn
            ? _widgetOptions.elementAt(_selectedIndex)
            : _selectedIndex == 2 ? const Login() : _widgetOptions.elementAt(_selectedIndex), // Show LoginScreen in place of Home
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyApp.reddish,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
