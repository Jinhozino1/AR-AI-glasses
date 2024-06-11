import 'package:flutter/material.dart';
import 'package:untitled/tabs/tab_cart.dart';
import 'package:untitled/tabs/tab_home.dart';
import 'package:untitled/tabs/tab_search.dart';
import 'package:untitled/tabs/tab_profile.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    HomeTab(),
    SearchTab(),
    CartTab(),
    ProfileTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GLASSES',
        style: TextStyle(fontSize: 18,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.w900
        ),)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if(index == 1) {
            setState(() {
              _currentIndex = 0;
            });
            Navigator.pushNamed(context, '/search');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '장바구니'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
      body: _tabs[_currentIndex],

          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, '/MainAi');
            },
            child: const Text('AI',
              style: TextStyle(
                fontSize: 20,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.w600
              ),),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
  }
}
