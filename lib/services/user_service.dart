import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _db.collection('profiles').doc(userId).get();

      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }

      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  // Create user profile
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _db
          .collection('profiles')
          .doc(profile.id)
          .set(profile.toFirestore());
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _db
          .collection('profiles')
          .doc(profile.id)
          .update(profile.toFirestore());
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(
      String userId, Map<String, dynamic> preferences) async {
    try {
      await _db.collection('profiles').doc(userId).update({
        'preferences': preferences,
      });
    } catch (e) {
      print('Error updating user preferences: $e');
      rethrow;
    }
  }

  // Stream user profile
  Stream<UserProfile?> streamUserProfile(String userId) {
    return _db
        .collection('profiles')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
  }
}
