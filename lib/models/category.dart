import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class TaskCategory {
  final String id;
  final String name;
  final int colorIndex;
  final String userId;
  final DateTime createdAt;
  final IconData icon;
  
  TaskCategory({
    required this.id,
    required this.name,
    required this.colorIndex,
    required this.userId,
    required this.createdAt,
    required this.icon,
  });
  
  factory TaskCategory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskCategory(
      id: doc.id,
      name: data['name'] ?? '',
      colorIndex: data['colorIndex'] ?? 0,
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      icon: IconData(data['iconCodePoint'] ?? 0xe5d5, fontFamily: 'MaterialIcons'),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'colorIndex': colorIndex,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'iconCodePoint': icon.codePoint,
    };
  }
  
  Color get color => ThemeService.getCategoryColor(colorIndex);
  
  TaskCategory copyWith({
    String? id,
    String? name,
    int? colorIndex,
    String? userId,
    DateTime? createdAt,
    IconData? icon,
  }) {
    return TaskCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      colorIndex: colorIndex ?? this.colorIndex,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
    );
  }
}
