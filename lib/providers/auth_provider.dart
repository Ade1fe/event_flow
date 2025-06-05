import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  User? _user;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = _authService.currentUser;
      if (_user != null) {
        await _loadUserProfile();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Listen for auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    if (_user == null) return;

    try {
      _userProfile = await _userService.getUserProfile(_user!.uid);
      if (_userProfile == null) {
        // Create default profile if none exists
        _userProfile = UserProfile(
          id: _user!.uid,
          displayName:
              _user!.displayName ?? _user!.email?.split('@')[0] ?? 'User',
          email: _user!.email ?? '',
          photoUrl: _user!.photoURL,
          createdAt: DateTime.now(),
          taskCount: 0,
          completedTaskCount: 0,
        );
        await _userService.createUserProfile(_userProfile!);
      }
    } catch (e) {
      _error = 'Failed to load profile: ${e.toString()}';
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      _error = _getReadableAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
      String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential =
          await _authService.registerWithEmailAndPassword(email, password);
      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(displayName);

        // Create user profile
        final newProfile = UserProfile(
          id: userCredential.user!.uid,
          displayName: displayName,
          email: email,
          photoUrl: null,
          createdAt: DateTime.now(),
          taskCount: 0,
          completedTaskCount: 0,
        );

        await _userService.createUserProfile(newProfile);
        return true;
      }
      return false;
    } catch (e) {
      _error = _getReadableAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({String? displayName, String? photoUrl}) async {
    if (_user == null || _userProfile == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      if (displayName != null && displayName.isNotEmpty) {
        await _user!.updateDisplayName(displayName);
      }

      if (photoUrl != null) {
        await _user!.updatePhotoURL(photoUrl);
      }

      // Update user profile
      final updatedProfile = _userProfile!.copyWith(
        displayName: displayName ?? _userProfile!.displayName,
        photoUrl: photoUrl ?? _userProfile!.photoUrl,
      );

      await _userService.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _error = _getReadableAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getReadableAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'This email is already registered. Please sign in or use a different email.';
        case 'weak-password':
          return 'Password is too weak. Please use a stronger password.';
        case 'invalid-email':
          return 'Invalid email address format.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many failed login attempts. Please try again later.';
        default:
          return error.message ?? 'Authentication error occurred.';
      }
    }
    return error.toString();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
