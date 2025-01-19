// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AuthPage(),
//     );
//   }
// }

// class AuthPage extends StatefulWidget {
//   @override
//   _AuthPageState createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   bool isLogin = true; // Toggle between login and register
//   bool isChecked = false; // "Remember me" checkbox
//   bool isPasswordVisible = false; // Toggle password visibility
//   bool isConfirmPasswordVisible = false; // Toggle confirm password visibility

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      appBar: AppBar(
//         backgroundColor: Color(0xFF0B1D26),
//         elevation: 0,
//         flexibleSpace: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 70.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left side with "News", "Statistics", "Map"
//               Row(
//                 children: [
//                   Text(
//                     'News',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Text(
//                     'Statistics',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Text(
//                     'Map',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               // Right side with account icon and text "Account"
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     'Account',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Color(0xFF0B1D26),
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
//           height: MediaQuery.of(context).size.height * 0.8, // Set the container height
//           color: Color(0xFF0B1D26), // Set background color of the container
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Welcome!',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           isLogin
//                               ? 'Log in to our website simply'
//                               : 'Sign Up to our website simply',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         if (!isLogin) // Email field for registration
//                           TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               filled: true,
//                               fillColor: Colors.white10,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         SizedBox(height: 10),
//                         TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Username',
//                             filled: true,
//                             fillColor: Colors.white10,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         // Password field with visibility toggle
//                         TextField(
//                           obscureText: !isPasswordVisible,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             filled: true,
//                             fillColor: Colors.white10,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Colors.black,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   isPasswordVisible = !isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         if (!isLogin) // Confirm Password field for registration with visibility toggle
//                           Column(
//                             children: [
//                               SizedBox(height: 10),
//                               TextField(
//                                 obscureText: !isConfirmPasswordVisible,
//                                 decoration: InputDecoration(
//                                   labelText: 'Confirm Password',
//                                   filled: true,
//                                   fillColor: Colors.white10,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       isConfirmPasswordVisible
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                       color: Colors.black,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isConfirmPasswordVisible = !isConfirmPasswordVisible;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: isChecked,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       isChecked = value!;
//                                     });
//                                   },
//                                 ),
//                                 Text(
//                                   'Remember me',
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               child: Text(
//                                 'Forgot Password?',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 30),
//                         // MaterialButton with corner radius
//                         MaterialButton(
//                           onPressed: () {
//                             // Handle login or register action
//                           },
//                           color: Colors.black, // Button color
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 200, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             isLogin ? 'Log In' : 'Sign Up',
//                             style: TextStyle(fontSize: 18, color: Colors.white),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               isLogin = !isLogin; // Switch pages
//                             });
//                           },
//                           child: Text(
//                             isLogin
//                                 ? "Don't have an Account? Register"
//                                 : "Already have an Account? Log In",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               // The second half containing the image
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.45,
//                 child: Image.asset(
//                   'lib/assets/images/5.jpg',
//                   fit: BoxFit.cover,
//                   height: double.infinity,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
