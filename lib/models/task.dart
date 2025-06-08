// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/theme_service.dart';

// class Task {
//   final String id;
//   final String title;
//   final String description;
//   final bool isCompleted;
//   final DateTime createdAt;
//   final String userId;
//   final DateTime? dueDate;
//   final TaskPriority priority;
//   final String? category;
//   final List<String> tags;
//   final bool isRecurring;
//   final RecurrenceType? recurrenceType;
//   final int? recurrenceInterval;

//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.isCompleted,
//     required this.createdAt,
//     required this.userId,
//     this.dueDate,
//     this.priority = TaskPriority.medium,
//     this.category,
//     this.tags = const [],
//     this.isRecurring = false,
//     this.recurrenceType,
//     this.recurrenceInterval,
//   });

//   factory Task.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Task(
//       id: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       isCompleted: data['isCompleted'] ?? false,
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       userId: data['userId'] ?? '',
//       dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
//       priority: TaskPriority.values[data['priority'] ?? 1],
//       category: data['category'],
//       tags: List<String>.from(data['tags'] ?? []),
//       isRecurring: data['isRecurring'] ?? false,
//       recurrenceType: data['recurrenceType'] != null
//           ? RecurrenceType.values[data['recurrenceType']]
//           : null,
//       recurrenceInterval: data['recurrenceInterval'],
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'title': title,
//       'description': description,
//       'isCompleted': isCompleted,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'userId': userId,
//       'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
//       'priority': priority.index,
//       'category': category,
//       'tags': tags,
//       'isRecurring': isRecurring,
//       'recurrenceType': recurrenceType?.index,
//       'recurrenceInterval': recurrenceInterval,
//     };
//   }

//   Task copyWith({
//     String? id,
//     String? title,
//     String? description,
//     bool? isCompleted,
//     DateTime? createdAt,
//     String? userId,
//     DateTime? dueDate,
//     TaskPriority? priority,
//     String? category,
//     List<String>? tags,
//     bool? isRecurring,
//     RecurrenceType? recurrenceType,
//     int? recurrenceInterval,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       isCompleted: isCompleted ?? this.isCompleted,
//       createdAt: createdAt ?? this.createdAt,
//       userId: userId ?? this.userId,
//       dueDate: dueDate ?? this.dueDate,
//       priority: priority ?? this.priority,
//       category: category ?? this.category,
//       tags: tags ?? this.tags,
//       isRecurring: isRecurring ?? this.isRecurring,
//       recurrenceType: recurrenceType ?? this.recurrenceType,
//       recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
//     );
//   }

//   bool get isOverdue {
//     if (dueDate == null || isCompleted) return false;
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
//     return taskDate.isBefore(today);
//   }

//   bool get isDueToday {
//     if (dueDate == null) return false;
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
//     return taskDate.isAtSameMomentAs(today);
//   }

//   String get dueDateFormatted {
//     if (dueDate == null) return 'No due date';

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = DateTime(now.year, now.month, now.day + 1);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

//     if (taskDate.isAtSameMomentAs(today)) {
//       return 'Today';
//     } else if (taskDate.isAtSameMomentAs(tomorrow)) {
//       return 'Tomorrow';
//     } else if (taskDate.isAtSameMomentAs(yesterday)) {
//       return 'Yesterday';
//     } else {
//       return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
//     }
//   }
// }

// enum RecurrenceType {
//   daily,
//   weekly,
//   monthly,
//   yearly,
// }
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

enum RecurrenceType { daily, weekly, monthly, yearly }

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String userId;
  final DateTime? dueDate;
  final TaskPriority priority;
  final String? category;
  final List<String> tags;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final int? recurrenceInterval;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.userId,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.category,
    this.tags = const [],
    this.isRecurring = false,
    this.recurrenceType,
    this.recurrenceInterval,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      priority: TaskPriority.values[data['priority'] ?? 1],
      category: data['category'],
      tags: List<String>.from(data['tags'] ?? []),
      isRecurring: data['isRecurring'] ?? false,
      recurrenceType: data['recurrenceType'] != null
          ? RecurrenceType.values[data['recurrenceType']]
          : null,
      recurrenceInterval: data['recurrenceInterval'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'priority': priority.index,
      'category': category,
      'tags': tags,
      'isRecurring': isRecurring,
      'recurrenceType': recurrenceType?.index,
      'recurrenceInterval': recurrenceInterval,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
    DateTime? dueDate,
    TaskPriority? priority,
    String? category,
    List<String>? tags,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    int? recurrenceInterval,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return taskDate.isBefore(today);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return taskDate.isAtSameMomentAs(today) ||
        (taskDate.isAfter(today) && taskDate.isBefore(tomorrow));
  }

  String get dueDateFormatted {
    if (dueDate == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final yesterday = today.subtract(Duration(days: 1));
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    if (taskDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      return 'Tomorrow';
    } else if (taskDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (taskDate.isBefore(today)) {
      final difference = today.difference(taskDate).inDays;
      return '$difference day${difference > 1 ? 's' : ''} overdue';
    } else {
      final difference = taskDate.difference(today).inDays;
      return 'In $difference day${difference > 1 ? 's' : ''}';
    }
  }
}
