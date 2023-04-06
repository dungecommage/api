

import 'cartPage.dart';
import 'category.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';

import 'myaccount/acc_dashboard.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<Widget> _tabs = <Widget>[
    HomePage(
      key: PageStorageKey<String>('home'),
    ),
    CategoryPage(
      categoryId: 2,
      key: PageStorageKey('category'),
    ),
    AccDashBoard(
      key: PageStorageKey('myaccount'),
    ),
    CartPage(
      key: PageStorageKey('cart'),
    ),
  ];
  int _selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: _tabs[_selectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}