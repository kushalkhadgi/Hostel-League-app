import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rolebase/Captain/AnnouncementCaptain.dart';
import 'package:rolebase/Captain/HistoryCaptain.dart';
import 'package:rolebase/CaptainDashboard.dart';
import 'package:rolebase/announcement.dart';
import 'package:rolebase/history_screen.dart';
import 'package:rolebase/ManagementDashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final String role; // This will be passed from the LoginPage after login

  HomePage({required this.role});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab index

  // Pages for Management
  final List<Widget> _managementPages = [
    ManagementLandingPage(),
    SendMessageScreen(), // Management-specific announcements
    HistoryScreen(), // Shared screen
  ];

  // Pages for Captain
  final List<Widget> _captainPages = [
    CaptainLandingPage(),
    CaptainViewMessageScreen(), // Captain-specific announcements
    HistoryCaptain(), // Shared screen for captains
  ];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fallback if an unrecognized role is passed
    List<Widget> currentPages;
    List<Widget> bottomNavItems;

    if (widget.role == 'management') {
      currentPages = _managementPages;
      bottomNavItems = [
        Icon(Icons.home, size: 30),
        Icon(Icons.announcement, size: 30),
        Icon(Icons.history, size: 30),
      ];
    } else if (widget.role == 'captain') {
      currentPages = _captainPages;
      bottomNavItems = [
        Icon(Icons.home, size: 30),
        Icon(Icons.announcement, size: 30),
        Icon(Icons.history, size: 30),
      ];
    } else {
      // Handle unknown roles
      currentPages = [Text('Error: Unrecognized role')];
      bottomNavItems = [Icon(Icons.error, size: 30)];
    }

    // Ensure selectedIndex is valid
    if (_selectedIndex >= currentPages.length) {
      _selectedIndex = 0; // Reset index if out of range
    }

    return Scaffold(
      body: Center(
        // Display the appropriate page based on selected index
        child: currentPages[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 180, 68),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 300),
        height: 60,
        items: bottomNavItems, // Dynamically assign items based on role
        onTap: _onItemTapped,
        index: _selectedIndex,
      ),
    );
  }
}