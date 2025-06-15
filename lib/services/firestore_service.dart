// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get tasks stream for a user
  Stream<List<Task>> getTasksStream(String userId) {
    try {
      return _db
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        print('Firestore snapshot received: ${snapshot.docs.length} tasks');
        return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print('Error getting tasks stream: $e');
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    try {
      final docRef = await _db.collection('tasks').add(task.toFirestore());
      print('Task added with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    try {
      await _db.collection('tasks').doc(task.id).update(task.toFirestore());
      print('Task updated: ${task.id}');
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
      print('Task deleted: $taskId');
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _db.collection('tasks').doc(taskId).update({
        'isCompleted': !isCompleted,
      });
      print('Task completion toggled: $taskId');
    } catch (e) {
      print('Error toggling task: $e');
      rethrow;
    }
  }

  // Test Firestore connection
  Future<void> testConnection() async {
    try {
      await _db.collection('test').doc('test').set({'test': true});
      print('Firestore connection successful');
      await _db.collection('test').doc('test').delete();
    } catch (e) {
      print('Firestore connection failed: $e');
    }
  }
}
