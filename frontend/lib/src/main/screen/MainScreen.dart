import 'package:flutter/material.dart';
import 'package:frontend/src/account/screen/AccountScreen.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/screen/LoginScreen.dart';
import 'package:frontend/src/home/screen/HomeScreen.dart';
import 'package:frontend/src/product/screen/ProductScreen.dart';
import 'package:frontend/src/registration/screen/RegistrationScreen.dart';
import 'package:frontend/src/search/screen/SearchScreen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProductScreen(),
    const RegistrationScreen(),
    const SearchScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.business), label: '상품'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.production_quantity_limits), label: '상품등록'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box), label: '계정'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped),
      ),
    );
  }
}
