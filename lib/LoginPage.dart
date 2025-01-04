import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';  // Google Sign-In
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore
import 'package:rolebase/HomePage.dart';  // Ensure correct import

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 255, 158, 119), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/login.png', height: 150), // Centered image
                SizedBox(height: 40),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // Show loading spinner if login is in progress
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _loginWithEmail,
                        child: Text('Login with Email'),
                      ),
                SizedBox(height: 20),

                if (errorMessage != null) ...[
                  SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        obscureText: obscureText,
      ),
    );
  }

  // Email/Password login with role check
  void _loginWithEmail() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get user ID and check role in Firestore
      String userId = userCredential.user!.uid;
      _checkUserRole(userId);
    } catch (e) {
      setState(() {
        errorMessage = 'Login failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Method to check user's role from Firestore
  void _checkUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        if (role == 'management' || role == 'captain') {
          // Navigate to HomePage based on role
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(role: role), // Pass role to HomePage
            ),
          );
        } else {
          setState(() {
            errorMessage = 'Error: Invalid role';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: User document does not exist';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: Unable to fetch user role: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
}






// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rolebase/HomePage.dart';  // Ensure this import is correct

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String? errorMessage;
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [const Color.fromARGB(255, 255, 158, 119), Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Image.asset('assets/login.png', height: 150), // Centered image
//                 SizedBox(height: 40),
//                 _buildTextField(
//                   controller: _emailController,
//                   label: 'Email',
//                   icon: Icons.email,
//                 ),
//                 SizedBox(height: 20),
//                 _buildTextField(
//                   controller: _passwordController,
//                   label: 'Password',
//                   icon: Icons.lock,
//                   obscureText: true,
//                 ),
//                 SizedBox(height: 20),

//                 // Show a loading indicator while login is in progress
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: _login,
//                         child: Text('Login'),
//                       ),

//                 // Display error message if exists
//                 if (errorMessage != null) ...[
//                   SizedBox(height: 20),
//                   Text(
//                     errorMessage!,
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Method to build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool obscureText = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30.0),
//         color: Colors.white,
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
//         ),
//         obscureText: obscureText,
//       ),
//     );
//   }

//   // Login function to authenticate the user
//   void _login() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator when login starts
//       errorMessage = null; // Reset error message
//     });

//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       String userId = userCredential.user!.uid;
//       _checkUserRole(userId); // Check the user's role after login
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Login failed: ${e.toString()}'; // Display error message
//         _isLoading = false;  // Hide loading indicator on error
//       });
//     }
//   }

//   // Method to check user's role from Firestore
//   void _checkUserRole(String userId) async {
//     try {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (userDoc.exists) {
//         String role = userDoc['role'];

//         if (role == 'management' || role == 'captain') {
//           // Navigate to HomePage and pass the role
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomePage(role: role), // Pass role to HomePage
//             ),
//           );
//         } else {
//           // Handle invalid role
//           setState(() {
//             errorMessage = 'Error: Invalid role';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Error: User document does not exist';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: Unable to fetch user role: ${e.toString()}';
//         _isLoading = false;
//       });
//     }
//   }
// }
