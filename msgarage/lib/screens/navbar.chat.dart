
import 'package:flutter/material.dart';
import 'package:msgarage/screens/acceuil.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/fourthpage.dart';
import 'package:msgarage/screens/profilepage.dart';
import 'package:msgarage/screens/secondpage.dart';






class StatPage extends StatefulWidget {


  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Acceuil(),
    SecondPage(),
    ClientPage(),
    FourthPage(),
    ProfilePage(),
    
    
  ];
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      

      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF002E7F), // Changer la couleur des icônes sélectionnées
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
            size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_4_bar_outlined,
            size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dvr,
            size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history,
            size: 28.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
            size: 28.0),
            label: '',
          ),
        ],
      ),
    );
  }
}














