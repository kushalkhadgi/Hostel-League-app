import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Removed Firestore import
// import 'package:flutter/rendering.dart'; // Removed unused import
import 'package:url_launcher/url_launcher.dart';

class BlackEaglesCaptain extends StatelessWidget {
  final String teamName = 'Black Eagles';

  final List<String> _players = [
    'Krishna D Raut',
    'Yash Mandokar',
    'Albert Wilson',
    'Basil Issac',
    'Parimal Ghumde',
    'Pranay mune',
    'Ashay wanjari',
    'Mairaj Sheikh',
    'Sarthak band',
    'Christo Paul Jobi',
    'Ishant Vishnu Padole',
    'Kushal Patil',
    'Nayan Bhendarkar',
    'Sushrut Vaidya',
    'preshit borkar',
    'Prajwal Godbole',
    'Dewanshu Patle',
    'Aditya Falke',
    'Ojas Bramhane',
    'Ansh Kene',
    'Gaurav Tribhuwan',
    'Aaron Geevarghese Mathews',
    'Satvik Satpute',
    'Devanshu wankhede',
    'Uzaif Mirza',
    'MAYURESH MANGRULKAR',
    'Stanzin',
    'Aman Martin',
    'sahil sudhakar kharkate',
    'Sandesh Fandi',
    'Shravan Manapure',
    'Bhavesh Ghubde',
    'rohan singh',
    'chinmay wadettiwar',
    'Guradesh Dhillon',
    'sandeep deurkar',
    'Nalaksh Randhawa',
    'Raja Mehar',
    'Rahul Verma',
    'Bhawani singh',
    'Pavan Waghmare',
    'singay wangchuk',
    'Mohit Kumar',
    'Junaid Hameed',
    'Santosh ingle',
    'devansh dubey',
    'Aryan Nandurkar',
    'Jaypal Chavan',
    'Tanish Dewase',
    'Malleshwar Reddy',
    'Pradhyum meshram',
    'avinash wankhade',
    'Raunak Singh',
    'Sohel Sheikh',
    'Jatin Meenia',
    'Sahil Kumar',
    'Aayush Jibhkate',
    'villayat ali',
    'Prince Singh',
    'Ishan Bassin',
    'Aryan Choudhary',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 255, 180, 68),
        title: Text(teamName),
      ),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final playerName = _players[index];

          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(
              playerName,
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              // Navigate to a simplified MemberDetailsScreen for now
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemberDetailsScreen(memberName: playerName),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MemberDetailsScreen extends StatelessWidget {
  final String memberName;

  MemberDetailsScreen({required this.memberName});

  // Function to launch the dialer (kept for potential future use, but not directly used here)
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 255, 180, 68),
        title: Text('Member Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  memberName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Add more cards for other details if available in a more detailed CSV
          ],
        ),
      ),
    );
  }
}
