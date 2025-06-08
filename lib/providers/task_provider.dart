// import 'package:flutter/material.dart';
// import '../models/task.dart';
// import '../services/task_service.dart';

// class TaskProvider with ChangeNotifier {
//   final TaskService _taskService = TaskService();

//   List<Task> _tasks = [];
//   List<Task> _filteredTasks = [];
//   bool _isLoading = false;
//   String? _error;
//   TaskFilter _currentFilter = TaskFilter.all;
//   String _searchQuery = '';
//   TaskSortOption _sortOption = TaskSortOption.dateDesc;

//   List<Task> get tasks => _filteredTasks;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   TaskFilter get currentFilter => _currentFilter;
//   String get searchQuery => _searchQuery;
//   TaskSortOption get sortOption => _sortOption;

//   int get totalTasks => _tasks.length;
//   int get completedTasks => _tasks.where((task) => task.isCompleted).length;
//   int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
//   double get completionRate => totalTasks > 0 ? completedTasks / totalTasks : 0;

//   List<Task> get todayTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     return _tasks.where((task) {
//       if (task.dueDate == null) return false;
//       final taskDate = DateTime(
//         task.dueDate!.year,
//         task.dueDate!.month,
//         task.dueDate!.day
//       );
//       return taskDate.isAtSameMomentAs(today);
//     }).toList();
//   }

//   List<Task> get upcomingTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     return _tasks.where((task) {
//       if (task.dueDate == null) return false;
//       final taskDate = DateTime(
//         task.dueDate!.year,
//         task.dueDate!.month,
//         task.dueDate!.day
//       );
//       return taskDate.isAfter(today) && !task.isCompleted;
//     }).toList();
//   }

//   List<Task> get overdueTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     return _tasks.where((task) {
//       if (task.dueDate == null) return false;
//       final taskDate = DateTime(
//         task.dueDate!.year,
//         task.dueDate!.month,
//         task.dueDate!.day
//       );
//       return taskDate.isBefore(today) && !task.isCompleted;
//     }).toList();
//   }

//   Future<void> loadTasks(String userId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _tasks = await _taskService.getTasks(userId);
//       _applyFiltersAndSort();
//     } catch (e) {
//       _error = 'Failed to load tasks: ${e.toString()}';
//       _tasks = [];
//       _filteredTasks = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> addTask(Task task) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final newTask = await _taskService.addTask(task);
//       _tasks.add(newTask);
//       _applyFiltersAndSort();
//       return true;
//     } catch (e) {
//       _error = 'Failed to add task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> updateTask(Task task) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await _taskService.updateTask(task);
//       final index = _tasks.indexWhere((t) => t.id == task.id);
//       if (index != -1) {
//         _tasks[index] = task;
//       }
//       _applyFiltersAndSort();
//       return true;
//     } catch (e) {
//       _error = 'Failed to update task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> deleteTask(String taskId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await _taskService.deleteTask(taskId);
//       _tasks.removeWhere((task) => task.id == taskId);
//       _applyFiltersAndSort();
//       return true;
//     } catch (e) {
//       _error = 'Failed to delete task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return await updateTask(updatedTask);
//   }

//   void setFilter(TaskFilter filter) {
//     _currentFilter = filter;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void setSortOption(TaskSortOption option) {
//     _sortOption = option;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void _applyFiltersAndSort() {
//     // Apply filters
//     _filteredTasks = _tasks.where((task) {
//       // Apply status filter
//       switch (_currentFilter) {
//         case TaskFilter.all:
//           break;
//         case TaskFilter.completed:
//           if (!task.isCompleted) return false;
//           break;
//         case TaskFilter.pending:
//           if (task.isCompleted) return false;
//           break;
//         case TaskFilter.today:
//           if (task.dueDate == null) return false;
//           final now = DateTime.now();
//           final today = DateTime(now.year, now.month, now.day);
//           final taskDate = DateTime(
//             task.dueDate!.year,
//             task.dueDate!.month,
//             task.dueDate!.day
//           );
//           if (!taskDate.isAtSameMomentAs(today)) return false;
//           break;
//         case TaskFilter.upcoming:
//           if (task.dueDate == null) return false;
//           final now = DateTime.now();
//           final today = DateTime(now.year, now.month, now.day);
//           final taskDate = DateTime(
//             task.dueDate!.year,
//             task.dueDate!.month,
//             task.dueDate!.day
//           );
//           if (!taskDate.isAfter(today)) return false;
//           break;
//         case TaskFilter.overdue:
//           if (task.dueDate == null) return false;
//           final now = DateTime.now();
//           final today = DateTime(now.year, now.month, now.day);
//           final taskDate = DateTime(
//             task.dueDate!.year,
//             task.dueDate!.month,
//             task.dueDate!.day
//           );
//           if (!taskDate.isBefore(today) || task.isCompleted) return false;
//           break;
//       }

//       // Apply search query
//       if (_searchQuery.isNotEmpty) {
//         final query = _searchQuery.toLowerCase();
//         return task.title.toLowerCase().contains(query) ||
//                task.description.toLowerCase().contains(query);
//       }

//       return true;
//     }).toList();

//     // Apply sorting
//     _filteredTasks.sort((a, b) {
//       switch (_sortOption) {
//         case TaskSortOption.dateAsc:
//           return a.createdAt.compareTo(b.createdAt);
//         case TaskSortOption.dateDesc:
//           return b.createdAt.compareTo(a.createdAt);
//         case TaskSortOption.dueDate:
//           if (a.dueDate == null && b.dueDate == null) return 0;
//           if (a.dueDate == null) return 1;
//           if (b.dueDate == null) return -1;
//           return a.dueDate!.compareTo(b.dueDate!);
//         case TaskSortOption.priority:
//           return b.priority.index.compareTo(a.priority.index);
//         case TaskSortOption.alphabetical:
//           return a.title.compareTo(b.title);
//       }
//     });
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

// enum TaskFilter {
//   all,
//   completed,
//   pending,
//   today,
//   upcoming,
//   overdue,
// }

// enum TaskSortOption {
//   dateDesc,
//   dateAsc,
//   dueDate,
//   priority,
//   alphabetical,
// }
// import 'package:flutter/material.dart';
// import '../models/task.dart';
// import '../services/task_service.dart';

// class TaskProvider with ChangeNotifier {
//   final TaskService _taskService = TaskService();

//   List<Task> _tasks = [];
//   List<Task> _filteredTasks = [];
//   bool _isLoading = false;
//   String? _error;
//   TaskFilter _currentFilter = TaskFilter.all;
//   String _searchQuery = '';
//   TaskSortOption _sortOption = TaskSortOption.dateDesc;

//   List<Task> get tasks => _filteredTasks;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   TaskFilter get currentFilter => _currentFilter;
//   String get searchQuery => _searchQuery;
//   TaskSortOption get sortOption => _sortOption;

//   int get totalTasks => _tasks.length;
//   int get completedTasks => _tasks.where((task) => task.isCompleted).length;
//   int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
//   double get completionRate => totalTasks > 0 ? completedTasks / totalTasks : 0;

//   List<Task> get todayTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = today.add(Duration(days: 1));

//     return _tasks.where((task) {
//       if (task.dueDate == null) return false;
//       final taskDate = DateTime(
//         task.dueDate!.year,
//         task.dueDate!.month,
//         task.dueDate!.day,
//       );
//       return taskDate.isAtSameMomentAs(today) ||
//           (taskDate.isAfter(today) && taskDate.isBefore(tomorrow));
//     }).toList();
//   }

//   List<Task> get upcomingTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final tomorrow = today.add(Duration(days: 1));
//     final nextWeek = today.add(Duration(days: 7));

//     return _tasks.where((task) {
//       if (task.dueDate == null || task.isCompleted) return false;
//       final taskDate = DateTime(
//         task.dueDate!.year,
//         task.dueDate!.month,
//         task.dueDate!.day,
//       );
//       // Tasks that are due tomorrow or within the next week (but not today)
//       return taskDate.isAfter(today) &&
//           taskDate.isBefore(nextWeek.add(Duration(days: 1)));
//     }).toList()..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
//   }

//   List<Task> get overdueTasks {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     return _tasks.where((task) {
//         if (task.dueDate == null || task.isCompleted) return false;
//         final taskDate = DateTime(
//           task.dueDate!.year,
//           task.dueDate!.month,
//           task.dueDate!.day,
//         );
//         // Tasks that are due before today
//         return taskDate.isBefore(today);
//       }).toList()
//       ..sort((a, b) => b.dueDate!.compareTo(a.dueDate!)); // Most overdue first
//   }

//   // Getter for completed tasks count (for consistency)
//   int get completedTasksCount => completedTasks;

//   // Getter for overdue tasks count
//   int get overdueTasksCount => overdueTasks.length;

//   Future<void> loadTasks(String userId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _tasks = await _taskService.getTasks(userId);
//       _applyFiltersAndSort();

//       // Check for overdue tasks (simplified without NotificationService)
//       _checkOverdueTasks();
//     } catch (e) {
//       _error = 'Failed to load tasks: ${e.toString()}';
//       _tasks = [];
//       _filteredTasks = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> addTask(Task task) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final newTask = await _taskService.addTask(task);
//       _tasks.add(newTask);
//       _applyFiltersAndSort();

//       return true;
//     } catch (e) {
//       _error = 'Failed to add task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> updateTask(Task task) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await _taskService.updateTask(task);
//       final index = _tasks.indexWhere((t) => t.id == task.id);
//       if (index != -1) {
//         _tasks[index] = task;
//       }
//       _applyFiltersAndSort();

//       return true;
//     } catch (e) {
//       _error = 'Failed to update task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> deleteTask(String taskId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await _taskService.deleteTask(taskId);
//       _tasks.removeWhere((task) => task.id == taskId);
//       _applyFiltersAndSort();

//       return true;
//     } catch (e) {
//       _error = 'Failed to delete task: ${e.toString()}';
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> toggleTaskCompletion(Task task) async {
//     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
//     return await updateTask(updatedTask);
//   }

//   void setFilter(TaskFilter filter) {
//     _currentFilter = filter;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void setSortOption(TaskSortOption option) {
//     _sortOption = option;
//     _applyFiltersAndSort();
//     notifyListeners();
//   }

//   void _applyFiltersAndSort() {
//     // Apply filters
//     _filteredTasks = _tasks.where((task) {
//       // Apply status filter
//       switch (_currentFilter) {
//         case TaskFilter.all:
//           break;
//         case TaskFilter.completed:
//           if (!task.isCompleted) return false;
//           break;
//         case TaskFilter.pending:
//           if (task.isCompleted) return false;
//           break;
//         case TaskFilter.today:
//           if (!todayTasks.contains(task)) return false;
//           break;
//         case TaskFilter.upcoming:
//           if (!upcomingTasks.contains(task)) return false;
//           break;
//         case TaskFilter.overdue:
//           if (!overdueTasks.contains(task)) return false;
//           break;
//       }

//       // Apply search query
//       if (_searchQuery.isNotEmpty) {
//         final query = _searchQuery.toLowerCase();
//         return task.title.toLowerCase().contains(query) ||
//             task.description.toLowerCase().contains(query);
//       }

//       return true;
//     }).toList();

//     // Apply sorting
//     _filteredTasks.sort((a, b) {
//       switch (_sortOption) {
//         case TaskSortOption.dateAsc:
//           return a.createdAt.compareTo(b.createdAt);
//         case TaskSortOption.dateDesc:
//           return b.createdAt.compareTo(a.createdAt);
//         case TaskSortOption.dueDate:
//           if (a.dueDate == null && b.dueDate == null) return 0;
//           if (a.dueDate == null) return 1;
//           if (b.dueDate == null) return -1;
//           return a.dueDate!.compareTo(b.dueDate!);
//         case TaskSortOption.priority:
//           return b.priority.index.compareTo(a.priority.index);
//         case TaskSortOption.alphabetical:
//           return a.title.compareTo(b.title);
//       }
//     });
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   void _checkOverdueTasks() {
//     // Simple overdue check without notifications
//     final overdueCount = overdueTasks.length;
//     if (overdueCount > 0) {
//       print('Found $overdueCount overdue tasks');
//     }
//   }

//   // Helper methods for getting tasks by category and priority
//   List<Task> getTasksByCategory(String category) {
//     return _tasks.where((task) => task.category == category).toList();
//   }

//   List<Task> getTasksByPriority(TaskPriority priority) {
//     return _tasks.where((task) => task.priority == priority).toList();
//   }
// }

// enum TaskFilter { all, completed, pending, today, upcoming, overdue }

// enum TaskSortOption { dateDesc, dateAsc, dueDate, priority, alphabetical }
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = false;
  String? _error;
  TaskFilter _currentFilter = TaskFilter.all;
  String _searchQuery = '';
  TaskSortOption _sortOption = TaskSortOption.dateDesc;

  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  TaskSortOption get sortOption => _sortOption;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  double get completionRate => totalTasks > 0 ? completedTasks / totalTasks : 0;

  List<Task> get todayTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      return taskDate.isAtSameMomentAs(today) ||
          (taskDate.isAfter(today) && taskDate.isBefore(tomorrow));
    }).toList();
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final nextWeek = today.add(Duration(days: 7));

    return _tasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      // Tasks that are due tomorrow or within the next week (but not today)
      return taskDate.isAfter(today) &&
          taskDate.isBefore(nextWeek.add(Duration(days: 1)));
    }).toList()..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  List<Task> get overdueTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _tasks.where((task) {
        if (task.dueDate == null || task.isCompleted) return false;
        final taskDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        // Tasks that are due before today
        return taskDate.isBefore(today);
      }).toList()
      ..sort((a, b) => b.dueDate!.compareTo(a.dueDate!)); // Most overdue first
  }

  // Getter for completed tasks count (for consistency)
  int get completedTasksCount => completedTasks;

  // Getter for overdue tasks count
  int get overdueTasksCount => overdueTasks.length;

  Future<void> loadTasks(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskService.getTasks(userId);
      _applyFiltersAndSort();

      // Check for overdue tasks (simplified without NotificationService)
      _checkOverdueTasks();
    } catch (e) {
      _error = 'Failed to load tasks: ${e.toString()}';
      _tasks = [];
      _filteredTasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTask = await _taskService.addTask(task);
      _tasks.add(newTask);
      _applyFiltersAndSort();

      return true;
    } catch (e) {
      _error = 'Failed to add task: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners(); // Always notify listeners to update UI
    }
  }

  Future<bool> updateTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _taskService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      _applyFiltersAndSort();

      return true;
    } catch (e) {
      _error = 'Failed to update task: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTask(String taskId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _applyFiltersAndSort();

      return true;
    } catch (e) {
      _error = 'Failed to delete task: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    return await updateTask(updatedTask);
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSortOption(TaskSortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void _applyFiltersAndSort() {
    // Apply filters
    _filteredTasks = _tasks.where((task) {
      // Apply status filter
      switch (_currentFilter) {
        case TaskFilter.all:
          break;
        case TaskFilter.completed:
          if (!task.isCompleted) return false;
          break;
        case TaskFilter.pending:
          if (task.isCompleted) return false;
          break;
        case TaskFilter.today:
          if (!todayTasks.contains(task)) return false;
          break;
        case TaskFilter.upcoming:
          if (!upcomingTasks.contains(task)) return false;
          break;
        case TaskFilter.overdue:
          if (!overdueTasks.contains(task)) return false;
          break;
      }

      // Apply search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();

    // Apply sorting
    _filteredTasks.sort((a, b) {
      switch (_sortOption) {
        case TaskSortOption.dateAsc:
          return a.createdAt.compareTo(b.createdAt);
        case TaskSortOption.dateDesc:
          return b.createdAt.compareTo(a.createdAt);
        case TaskSortOption.dueDate:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case TaskSortOption.priority:
          return b.priority.index.compareTo(a.priority.index);
        case TaskSortOption.alphabetical:
          return a.title.compareTo(b.title);
      }
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _checkOverdueTasks() {
    // Simple overdue check without notifications
    final overdueCount = overdueTasks.length;
    if (overdueCount > 0) {
      print('Found $overdueCount overdue tasks');
    }
  }

  // Helper methods for getting tasks by category and priority
  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }
}

enum TaskFilter { all, completed, pending, today, upcoming, overdue }

enum TaskSortOption { dateDesc, dateAsc, dueDate, priority, alphabetical }
