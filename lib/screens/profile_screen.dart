// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final AuthService _authService = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   bool _isLoading = false;
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = _authService.currentUser;
//     _nameController.text = _currentUser?.displayName ?? '';
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         await _authService.updateUserProfile(
//           displayName: _nameController.text.trim(),
//         );

//         setState(() {
//           _currentUser = _authService.currentUser;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Profile updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error updating profile: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userName = _currentUser?.displayName ?? 'User';
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: Colors.purple,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(24.0),
//           child: Column(
//             children: [
//               // Profile Avatar
//               CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.purple.shade100,
//                 child: Text(
//                   userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                   style: TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.purple,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
              
//               // Profile Form
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           'Edit Profile',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.purple,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 20),
                        
//                         // Name field
//                         TextFormField(
//                           controller: _nameController,
//                           decoration: InputDecoration(
//                             labelText: 'Full Name',
//                             prefixIcon: Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           textCapitalization: TextCapitalization.words,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your full name';
//                             }
//                             if (value.trim().length < 2) {
//                               return 'Name must be at least 2 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16),
                        
//                         // Email field (read-only)
//                         TextFormField(
//                           initialValue: _currentUser?.email ?? '',
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             suffixIcon: Icon(Icons.lock, color: Colors.grey),
//                           ),
//                           enabled: false,
//                         ),
//                         SizedBox(height: 24),
                        
//                         // Update button
//                         ElevatedButton(
//                           onPressed: _isLoading ? null : _updateProfile,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.purple,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: _isLoading
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   'Update Profile',
//                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
              
//               // Account Info Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Account Information',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.purple,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       _buildInfoRow(Icons.fingerprint, 'User ID', _currentUser?.uid ?? 'Not available'),
//                       SizedBox(height: 8),
//                       _buildInfoRow(Icons.calendar_today, 'Member Since', 
//                         _currentUser?.metadata.creationTime?.toString().split(' ')[0] ?? 'Unknown'),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             _currentUser?.emailVerified == true 
//                                 ? Icons.verified 
//                                 : Icons.warning,
//                             color: _currentUser?.emailVerified == true 
//                                 ? Colors.green 
//                                 : Colors.orange,
//                             size: 20,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             _currentUser?.emailVerified == true 
//                                 ? 'Email Verified' 
//                                 : 'Email Not Verified',
//                             style: TextStyle(
//                               color: _currentUser?.emailVerified == true 
//                                   ? Colors.green 
//                                   : Colors.orange,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[600]),
//         SizedBox(width: 8),
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(color: Colors.grey[800]),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }
