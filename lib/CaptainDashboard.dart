import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolebase/Scoreboard.dart'; 
import 'management_info_screen.dart';
import 'package:rolebase/Captain/AnnaWarriorCaptain.dart';
import 'package:rolebase/Captain/BlackEagleCaptain.dart';
import 'package:rolebase/Captain/DefendingTitansCaptain.dart';
import 'package:rolebase/Captain/GrievanceCaptian.dart';
import 'package:rolebase/Captain/RetroRivalCaptain.dart';
import 'package:rolebase/Captain/RisingGiantCaptain.dart';
import 'package:rolebase/Captain/TheScoutRegimentCaptain.dart';
import 'package:rolebase/Captain/WhiteWalkersCaptain.dart';
import 'EmergencyContact.dart';
import 'Captains.dart';
import 'Developers.dart';
import 'LoginPage.dart';
import 'package:rolebase/stories.dart';
import 'package:rolebase/aboutleague.dart';
import 'package:rolebase/Photos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';

class CaptainLandingPage extends StatefulWidget {
  @override
  _CaptainLandingPageState createState() => _CaptainLandingPageState();
}

class _CaptainLandingPageState extends State<CaptainLandingPage> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  // Sample list of card data (can be replaced with actual data)
  final List<Map<String, String>> cardData = [
    {'title': 'Black Eagles', 'logo': 'assets/logo1.png'},
    {'title': 'Anna Warriors', 'logo': 'assets/logo2.png'},
    {'title': 'Defending Titans', 'logo': 'assets/logo3.png'},
    {'title': 'White Walkers', 'logo': 'assets/logo4.png'},
    {'title': 'The Scout Regiment', 'logo': 'assets/logo5.png'},
    {'title': 'Retro Rivals', 'logo': 'assets/logo6.png'},
    {'title': 'Rising Giants', 'logo': 'assets/logo7.png'},
    {'title': 'Management Info', 'logo': 'assets/Management.png'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < 6) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<List<String>> _fetchPhotoUrls() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('gallery').doc('photos').get();
      List<String> photoUrls = [];

      // Assuming your photos are stored in fields pic1, pic2, pic3, ..., pic7
      for (int i = 1; i <= 10; i++) {
        String? url = snapshot.get('pic$i');
        if (url != null) {
          photoUrls.add(url);
        }
      }

      return photoUrls;
    } catch (e) {
      throw Exception("Failed to fetch photos: $e");
    }
  }

  Future<void> openPDFInBrowser(String url) async {
    final Uri pdfUri = Uri.parse(url);  // Convert URL to Uri object

    // Open the link in an external browser (e.g., Chrome)
    if (!await launchUrl(pdfUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open the PDF link';
    }
  }

  Future<String?> fetchPDFLink() async {
  try {
    // Fetch the document from Firestore
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Rulebook')  // Replace with your collection name
        .doc('PDF')      // Replace with your document ID
        .get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Extract the 'link' field from the document
      String pdfLink = documentSnapshot['link'];  // Assuming the field is named 'link'
      return pdfLink;  // Return the PDF link
    } else {
      print('Document does not exist');
    }
  } catch (e) {
    print('Error fetching document: $e');
  }
  
  return null;  // Return null if there's an error or the document doesn't exist
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 180, 68),
        title: Row(
          children: [
            Text(
              'Hostel League',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.leaderboard_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScoreboardScreen()),
                );
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 180, 68),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  SizedBox(height: 10),
                  Text(
                    'TNPS Hostel League',
                    style: TextStyle(
                      color: const Color.fromARGB(249, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer items
            _buildDrawerItem(context, Icons.menu_book, 'RuleBook', () async {
              String? pdfLink = await fetchPDFLink();

              if (pdfLink != null) {
                try {
                  await openPDFInBrowser(pdfLink);  // Open PDF link in external browser (Chrome)
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open the PDF in browser'))
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load PDF link'))
                );
              }
            }),
            _buildDrawerItem(context, Icons.memory_outlined, 'Top Stories', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TopStories()));
            }),
            _buildDrawerItem(context, Icons.book_outlined, 'About League', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
            }),
            _buildDrawerItem(context, Icons.quick_contacts_dialer_rounded, 'Captains', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CaptainScreen()));
            }),
            _buildDrawerItem(context, Icons.call_outlined, 'Emergency Contacts', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContactScreen()));
            }),
            _buildDrawerItem(context, Icons.stay_current_portrait_rounded, 'Developers', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DevelopersScreen()));
            }),
            _buildDrawerItem(context, Icons.rate_review_sharp, 'Grievance', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CaptainGrievanceScreen()));
            }),
            _buildDrawerItem(context, Icons.image_outlined, 'Photos', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen()));
            }),
            _buildDrawerItem(context, Icons.login_rounded, 'Login', () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _fetchPhotoUrls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No photos available'));
                }

                List<String> photoUrls = snapshot.data!;

                return Container(
                  height: 300.0, // Adjust height to cover the space of two cards
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: photoUrls.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: photoUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 16.0), // Spacer to separate the slider and the cards

            Padding(
              padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true, 
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        switch (cardData[index]['title']) {
                          case 'Black Eagles':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BlackEaglesCaptain()),
                            );
                            break;
                          case 'Anna Warriors':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AnnaWarriorsCaptain()),
                            );
                            break;
                          case 'Defending Titans':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DefendingTitansCaptain()),
                            );
                            break;
                          case 'White Walkers':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WhiteWalkersCaptain()),
                            );
                            break;
                          case 'The Scout Regiment':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TheScoutRegimentCaptain()),
                            );
                            break;
                          case 'Retro Rivals':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RetroRivalsCaptain()),
                            );
                            break;
                          case 'Rising Giants':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RisingGiantsCaptain()),
                            );
                            break;
                          case 'Management Info':
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ManagementInfoScreen()),
                            );
                            break;
                          default:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CardScreen(cardData[index]['title'] ?? 'Unknown Card')),
                            );
                            break;
                        }
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              cardData[index]['logo'] ?? 'assets/default_logo.png',
                              height: 65,
                              width: 65,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported);
                              },
                            ),
                            SizedBox(height: 8),
                            Text(
                              cardData[index]['title'] ?? 'Unknown Title',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create drawer items
  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}

// Screen that each card will navigate to
class CardScreen extends StatelessWidget {
  final String title;
  CardScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor:  const Color.fromARGB(255, 255, 180, 68),
        title: Text(title),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Text('Details for $title will be shown here'),
      ),
    );
  }
}
