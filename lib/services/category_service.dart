import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'categories';

  Future<List<TaskCategory>> getCategories(String userId) async {
    try {
      // Simple query without orderBy to avoid composite index requirement
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      final categories = querySnapshot.docs.map((doc) {
        return TaskCategory.fromFirestore(doc);
      }).toList();

      // Sort in Dart instead of Firestore to avoid index requirement
      categories.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return categories;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<TaskCategory> addCategory(TaskCategory category) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'name': category.name,
        'colorIndex': category.colorIndex,
        'userId': category.userId,
        'createdAt': FieldValue.serverTimestamp(),
        'icon': category.icon.codePoint,
      });

      return category.copyWith(id: docRef.id);
    } catch (e) {
      // ignore: avoid_print
      print('Error adding category: $e');
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> updateCategory(TaskCategory category) async {
    try {
      await _firestore.collection(_collection).doc(category.id).update({
        'name': category.name,
        'colorIndex': category.colorIndex,
        'icon': category.icon.codePoint,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error updating category: $e');
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting category: $e');
      throw Exception('Failed to delete category: $e');
    }
  }

  Stream<List<TaskCategory>> getCategoriesStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final categories = snapshot.docs.map((doc) {
            return TaskCategory.fromFirestore(doc);
          }).toList();
          // Sort in Dart instead of Firestore
          categories.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
          return categories;
        });
  }
}
