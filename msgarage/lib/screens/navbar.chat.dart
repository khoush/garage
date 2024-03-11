
import 'package:flutter/material.dart';
import 'package:msgarage/screens/first.dart';

import 'package:msgarage/screens/fourthpage.dart';
import 'package:msgarage/screens/profilepage.dart';
import 'package:msgarage/screens/secondpage.dart';
import 'package:msgarage/screens/test.dart';






class StatPage extends StatefulWidget {


  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Acceuil(),
    SecondPage(),
    ThirdPage (),
    FourthPage(),
    ProfilePage(),
    
    
  ];
  
  

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Add this line
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black, // Set the background color to black
        selectedItemColor: Colors.red, // Set the selected item color to white
        unselectedItemColor: Colors.white, // Set the unselected item color to white
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_4_bar_outlined, size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dvr, size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28.0),
            label: '',
          ),
        ],
      ),
    );
  }

}














