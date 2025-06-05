import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all categories for a user
  Future<List<TaskCategory>> getCategories(String userId) async {
    try {
      final snapshot = await _db
          .collection('categories')
          .where('userId', isEqualTo: userId)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => TaskCategory.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }

  // Stream categories for a user
  Stream<List<TaskCategory>> streamCategories(String userId) {
    return _db
        .collection('categories')
        .where('userId', isEqualTo: userId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskCategory.fromFirestore(doc))
            .toList());
  }

  // Add a new category
  Future<TaskCategory> addCategory(TaskCategory category) async {
    try {
      final docRef =
          await _db.collection('categories').add(category.toFirestore());

      // Get the created category with ID
      final doc = await docRef.get();
      return TaskCategory.fromFirestore(doc);
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  // Update a category
  Future<void> updateCategory(TaskCategory category) async {
    try {
      await _db
          .collection('categories')
          .doc(category.id)
          .update(category.toFirestore());
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _db.collection('categories').doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // Get category by ID
  Future<TaskCategory?> getCategoryById(String categoryId) async {
    try {
      final doc = await _db.collection('categories').doc(categoryId).get();

      if (doc.exists) {
        return TaskCategory.fromFirestore(doc);
      }

      return null;
    } catch (e) {
      print('Error getting category: $e');
      rethrow;
    }
  }
}
