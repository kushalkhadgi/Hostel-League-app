import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagementInfoScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {'name': 'Shahzab ali', 'phone': '7889847053'},
    {'name': 'Sam Chacko Ruby', 'phone': '8848438994'},
    {'name': 'Gaurav Pidurkar', 'phone': '8788498617'},
    {'name': 'Yash Gawande', 'phone': '8261903434'},
    {'name': 'Shahid sameer', 'phone': '9103843551'},
    {'name': 'devesh banote', 'phone': '8010369855'},
    {'name': 'Mayank Saha', 'phone': '8871334457'},
    {'name': 'Sparsh Chalotra', 'phone': '7889964900'},
    {'name': 'Omkar Pachbhai', 'phone': '8308202440'},
    {'name': 'Nainesh Zod', 'phone': '9021667707'},
  ];

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor:  const Color.fromARGB(255, 255, 180, 68),
        title: Text('Management Team'),
        automaticallyImplyLeading: true, // Show back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Icon(Icons.person_rounded, size: 40), // Icon for Name
                title: Text(contact['name'] ?? 'Unknown Name'),
                trailing: IconButton(
                  icon: Icon(Icons.call_outlined, color: Colors.green),
                  onPressed: () => _launchPhone(contact['phone'] ?? ''),
                ),
                // subtitle: Text(contact['phone'] ?? 'Unknown Phone Number'),
              ),
            );
          },
        ),
      ),
    );
  }
}
