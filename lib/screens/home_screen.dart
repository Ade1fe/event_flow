import 'package:flutter/material.dart';
import 'package:task_manager_clean/screens/tasks/add_task_screen.dart';
import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Test Firestore connection when screen loads
    _firestoreService.testConnection();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text('User not signed in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _authService.signOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // User info banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Colors.purple.shade50,
                  child: Text(
                    'Welcome, ${user.email}!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                // Tasks list
                Expanded(
                  child: StreamBuilder<List<Task>>(
                    stream: _firestoreService.getTasksStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, size: 64, color: Colors.red),
                              SizedBox(height: 16),
                              Text(
                                'Error loading tasks',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${snapshot.error}',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {}); // Refresh
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final tasks = snapshot.data ?? [];

                      if (tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No tasks yet!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the + button to add your first task',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) {
                                  _firestoreService.toggleTaskCompletion(
                                    task.id,
                                    task.isCompleted,
                                  );
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted ? Colors.grey : null,
                                ),
                              ),
                              subtitle: task.description.isNotEmpty
                                  ? Text(
                                      task.description,
                                      style: TextStyle(
                                        color: task.isCompleted
                                            ? Colors.grey
                                            : null,
                                      ),
                                    )
                                  : null,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddTaskScreen(task: task),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(task);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ),
                          );
                        },
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
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.deleteTask(task.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
