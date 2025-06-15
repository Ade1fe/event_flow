import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<TaskCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<TaskCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories(userId);
    } catch (e) {
      _error = 'Failed to load categories: ${e.toString()}';
      _categories = [];
          // ignore: avoid_print
      print('CategoryProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCategory(TaskCategory category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newCategory = await _categoryService.addCategory(category);
      _categories.add(newCategory);
      // Sort locally after adding
      _categories.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return true;
    } catch (e) {
      _error = 'Failed to add category: ${e.toString()}';
      // ignore: avoid_print
      print('CategoryProvider add error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCategory(TaskCategory category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _categoryService.updateCategory(category);
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
      }
      // Sort locally after updating
      _categories.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return true;
    } catch (e) {
      _error = 'Failed to update category: ${e.toString()}';
          // ignore: avoid_print
      print('CategoryProvider update error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _categoryService.deleteCategory(categoryId);
      _categories.removeWhere((category) => category.id == categoryId);
      return true;
    } catch (e) {
      _error = 'Failed to delete category: ${e.toString()}';
          // ignore: avoid_print
      print('CategoryProvider delete error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  TaskCategory? getCategoryById(String? categoryId) {
    if (categoryId == null) return null;
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
