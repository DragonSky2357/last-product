import 'package:flutter/material.dart';
import 'package:frontend/src/account/screen/AccountScreen.dart';
import 'package:frontend/src/account/state/AuthState.dart';
import 'package:frontend/src/account/screen/LoginScreen.dart';
import 'package:frontend/src/category/screen/CategoryScreen.dart';
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
    const CategoryScreen(),
    const ProductScreen(),
    // todo 검색 스크린
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegistrationScreen()));
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, size: 40),
      ),
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: '카테고리'),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: '상품'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.account_box), label: '계정'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped),
    );
  }
}
