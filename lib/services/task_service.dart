// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all tasks for a user
  Future<List<Task>> getTasks(String userId) async {
    try {
      final snapshot = await _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting tasks: $e');
      rethrow;
    }
  }

  // Stream tasks for a user
  Stream<List<Task>> streamTasks(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  // Add a new task
  Future<Task> addTask(Task task) async {
    try {
      final docRef = await _db.collection('tasks').add(task.toFirestore());

      // Update user's task count
      await _db.collection('profiles').doc(task.userId).update({
        'taskCount': FieldValue.increment(1),
      });

      // Get the created task with ID
      final doc = await docRef.get();
      return Task.fromFirestore(doc);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    try {
      final oldTask = await _db.collection('tasks').doc(task.id).get();
      final oldTaskData = oldTask.data() as Map<String, dynamic>;
      final wasCompleted = oldTaskData['isCompleted'] ?? false;

      await _db.collection('tasks').doc(task.id).update(task.toFirestore());

      // Update completion count if completion status changed
      if (wasCompleted != task.isCompleted) {
        await _db.collection('profiles').doc(task.userId).update({
          'completedTaskCount': FieldValue.increment(task.isCompleted ? 1 : -1),
        });
      }
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      final task = await _db.collection('tasks').doc(taskId).get();
      final taskData = task.data() as Map<String, dynamic>;
      final userId = taskData['userId'] as String;
      final isCompleted = taskData['isCompleted'] as bool;

      await _db.collection('tasks').doc(taskId).delete();

      // Update user's task counts
      await _db.collection('profiles').doc(userId).update({
        'taskCount': FieldValue.increment(-1),
        if (isCompleted) 'completedTaskCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  // Get tasks by category
  Future<List<Task>> getTasksByCategory(String userId, String category) async {
    try {
      final snapshot = await _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting tasks by category: $e');
      rethrow;
    }
  }

  // Get tasks by due date
  Future<List<Task>> getTasksByDueDate(String userId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('dueDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting tasks by due date: $e');
      rethrow;
    }
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks(String userId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final snapshot = await _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false)
          .where('dueDate', isLessThan: Timestamp.fromDate(today))
          .get();

      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting overdue tasks: $e');
      rethrow;
    }
  }
}
