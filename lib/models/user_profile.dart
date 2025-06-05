import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;
  final int taskCount;
  final int completedTaskCount;
  final Map<String, dynamic>? preferences;
  
  UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    this.taskCount = 0,
    this.completedTaskCount = 0,
    this.preferences,
  });
  
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      taskCount: data['taskCount'] ?? 0,
      completedTaskCount: data['completedTaskCount'] ?? 0,
      preferences: data['preferences'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'taskCount': taskCount,
      'completedTaskCount': completedTaskCount,
      'preferences': preferences,
    };
  }
  
  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
    int? taskCount,
    int? completedTaskCount,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      taskCount: taskCount ?? this.taskCount,
      completedTaskCount: completedTaskCount ?? this.completedTaskCount,
      preferences: preferences ?? this.preferences,
    );
  }
  
  double get completionRate {
    if (taskCount == 0) return 0;
    return completedTaskCount / taskCount;
  }
  
  String get initials {
    if (displayName.isEmpty) return '';
    
    final nameParts = displayName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return displayName[0].toUpperCase();
    }
  }
}
