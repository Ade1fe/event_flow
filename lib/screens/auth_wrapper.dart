// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import 'login_screen.dart';
// import 'home_screen.dart';

// class AuthWrapper extends StatelessWidget {
//   final AuthService _authService = AuthService();

//   AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: _authService.authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         if (snapshot.hasData) {
//           return HomeScreen();
//         } else {
//           return LoginScreen();
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
