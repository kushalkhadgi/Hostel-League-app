 import 'package:curved_navigation_bar/curved_navigation_bar.dart';
 import 'package:rolebase/announcement.dart';
import 'package:rolebase/history_screen.dart';
import 'package:flutter/material.dart';
 import 'package:rolebase/ManagementDashboard.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of widgets for different tabs
  static List<Widget> _pages = <Widget>[
    ManagementLandingPage(),
     SendMessageScreen(),
    HistoryScreen(),
  ];

  // Method to handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        // Display the corresponding page based on the current index
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 194, 107, 101),
        color: Colors.white,
        buttonBackgroundColor: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.announcement, size: 30),
          Icon(Icons.history, size: 30),
        ],
        onTap: _onItemTapped, // Handle the tap event
        index: _selectedIndex, // Current selected index
      ),
    );
  }
}

