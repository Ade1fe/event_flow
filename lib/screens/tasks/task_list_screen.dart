import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_clean/widgets/professional_app_bar.dart';
import '../../providers/task_provider.dart';
import '../../widgets/task_card.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskFilter filter;
  final String title;

  const TaskListScreen({super.key, required this.filter, required this.title});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _searchQuery = '';
  TaskSortOption _sortOption = TaskSortOption.dateDesc;

  @override
  void initState() {
    super.initState();

    // Set the filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.setFilter(widget.filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context);
            },
          ),
        ],
      ),
      // appBar: ProfessionalAppBar(
      //   title: widget.title,
      //   // showNotifications: true,
      //   // showProfile: true,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.sort),
      //       onPressed: () {
      //         _showSortOptions(context);
      //       },
      //     ),
      //   ],
      //   // showSubtitle: true,
      // ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                taskProvider.setSearchQuery(value);
              },
            ),
          ),

          // Task list
          Expanded(
            child: taskProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : taskProvider.tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return TaskCard(
                        task: task,
                        onToggle: () => taskProvider.toggleTaskCompletion(task),
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          );
                        },
                        onDelete: () => taskProvider.deleteTask(task.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getEmptyStateIcon(), size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            _getEmptyStateTitle(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'No tasks match your search'
                : 'Tap the + button to add a task',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    if (_searchQuery.isNotEmpty) {
      return Icons.search_off;
    }

    switch (widget.filter) {
      case TaskFilter.completed:
        return Icons.check_circle_outline;
      case TaskFilter.pending:
        return Icons.pending_actions;
      case TaskFilter.today:
        return Icons.today;
      case TaskFilter.upcoming:
        return Icons.upcoming;
      case TaskFilter.overdue:
        return Icons.event_busy;
      default:
        return Icons.task_alt;
    }
  }

  String _getEmptyStateTitle() {
    if (_searchQuery.isNotEmpty) {
      return 'No matching tasks';
    }

    switch (widget.filter) {
      case TaskFilter.completed:
        return 'No completed tasks';
      case TaskFilter.pending:
        return 'No pending tasks';
      case TaskFilter.today:
        return 'No tasks for today';
      case TaskFilter.upcoming:
        return 'No upcoming tasks';
      case TaskFilter.overdue:
        return 'No overdue tasks';
      default:
        return 'No tasks yet';
    }
  }

  void _showSortOptions(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort By',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildSortOption(
                    context,
                    'Date (Newest First)',
                    TaskSortOption.dateDesc,
                    taskProvider,
                    setState,
                  ),
                  _buildSortOption(
                    context,
                    'Date (Oldest First)',
                    TaskSortOption.dateAsc,
                    taskProvider,
                    setState,
                  ),
                  _buildSortOption(
                    context,
                    'Due Date',
                    TaskSortOption.dueDate,
                    taskProvider,
                    setState,
                  ),
                  _buildSortOption(
                    context,
                    'Priority',
                    TaskSortOption.priority,
                    taskProvider,
                    setState,
                  ),
                  _buildSortOption(
                    context,
                    'Alphabetical',
                    TaskSortOption.alphabetical,
                    taskProvider,
                    setState,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    TaskSortOption option,
    TaskProvider taskProvider,
    StateSetter setState,
  ) {
    return ListTile(
      title: Text(title),
      leading: Radio<TaskSortOption>(
        value: option,
        groupValue: taskProvider.sortOption,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _sortOption = value;
            });
            taskProvider.setSortOption(value);
            Navigator.pop(context);
          }
        },
      ),
      onTap: () {
        setState(() {
          _sortOption = option;
        });
        taskProvider.setSortOption(option);
        Navigator.pop(context);
      },
    );
  }
}
