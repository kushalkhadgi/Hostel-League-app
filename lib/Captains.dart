import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CaptainScreen extends StatelessWidget {
  // A list of teams
  final List<String> _teams = [
    'Black Eagles',
    'Anna Warriors',
    'Defending Titans',
    'White Walkers',
    'The Scout Regiment',
    'Retro Rivals',
    'Rising Giants',
  ];

  // A list of captain contacts for each team
  final List<Map<String, String>> _captaincontacts = [
    {'name': 'Jatin Meenia', 'phone': '6006831796'},
    {'name': 'Alwyn Paul', 'phone': '9643351583'},
    {'name': 'Saurabh Wande', 'phone': '9322611266'},
    {'name': 'Dishant Kewat', 'phone': '9156929978'},
    {'name': 'Rajat Sawarbandhe', 'phone': '7821865342'},
    {'name': 'Allen Jess', 'phone': '7985606935'},
    {'name': 'Denil Daby', 'phone': '9497213784'},
  ];

  // A list of vice-captain contacts for each team
  final List<Map<String, String>> _viceCaptaincontacts = [
    {'name': 'Sahil Kumar', 'phone': '9149655254'},
    {'name': 'Mathew Binoy', 'phone': '8130908578'},
    {'name': 'Ayush Zurmure', 'phone': '9527555788'},
    {'name': 'Suyash Burile', 'phone': '7020412386'},
    {'name': 'Neeraj Ruda', 'phone': '8879962654'},
    {'name': 'Ayush Benny', 'phone': '8606304705'},
    {'name': 'Jelson Joseph', 'phone': '9863141632'},
  ];

  // Method to launch the dialer
  void _launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:  const Color.fromARGB(255, 255, 180, 68),
        title: Text('Captains Contact'),
        
      ),
      body: ListView.builder(
        itemCount: _teams.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  // Main parent Tile for the team name
                  ListTile(
                    title: Text(
                      _teams[index], // Team name as the title
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(height: 1), 
                  ListTile(
                    title: Text(
                      '${_captaincontacts[index]['name']!}', // Captain's name
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () => _launchDialer(_captaincontacts[index]['phone']!), // Captain's phone
                    ),
                  ),
                  
                  ListTile(
                    title: Text(
                      '${_viceCaptaincontacts[index]['name']!}', // Vice captain's name
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () => _launchDialer(_viceCaptaincontacts[index]['phone']!), // Vice captain's phone
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
