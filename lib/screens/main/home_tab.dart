import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_clean/widgets/professional_app_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/quick_actions.dart';
import '../../widgets/task_card.dart';
import '../tasks/add_task_screen.dart';
import '../tasks/task_list_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState(); // Call super first
    _loadTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Properly dispose here
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (authProvider.user != null) {
        await taskProvider.loadTasks(authProvider.user!.uid);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading tasks: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfessionalAppBar(
        title: 'Home',
        showNotifications: true,
        showProfile: true,
        showSubtitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Container(
                          padding: EdgeInsets.all(20),

                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     colors: [
                          //       Theme.of(
                          //         context,
                          //       ).colorScheme.primary.withValues(alpha: .1),
                          //       Theme.of(
                          //         context,
                          //       ).colorScheme.secondary.withValues(alpha: .1),
                          //     ],
                          //   ),
                          //   borderRadius: BorderRadius.circular(16),
                          // ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primaryContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      authProvider.userProfile?.displayName ??
                                          'User',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Consumer<TaskProvider>(
                                      builder: (context, taskProvider, child) {
                                        final now = DateTime.now();
                                        final greeting = now.hour < 12
                                            ? 'Good morning!'
                                            : now.hour < 17
                                            ? 'Good afternoon!'
                                            : 'Good evening!';

                                        return Text(
                                          greeting,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.waving_hand,
                                size: 40,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),

                    // Stats cards
                    Consumer<TaskProvider>(
                      builder: (context, taskProvider, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StatsCard(
                                    title: 'Total Tasks',
                                    value: taskProvider.totalTasks.toString(),
                                    icon: Icons.task_alt,
                                    color: Colors.blue,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TaskListScreen(
                                            filter: TaskFilter.all,
                                            title: 'All Tasks',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: StatsCard(
                                    title: 'Completed',
                                    value: taskProvider.completedTasks
                                        .toString(),
                                    icon: Icons.check_circle,
                                    color: Colors.green,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TaskListScreen(
                                            filter: TaskFilter.completed,
                                            title: 'Completed Tasks',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: StatsCard(
                                    title: 'Pending',
                                    value: taskProvider.pendingTasks.toString(),
                                    icon: Icons.pending_actions,
                                    color: Colors.orange,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TaskListScreen(
                                            filter: TaskFilter.pending,
                                            title: 'Pending Tasks',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: StatsCard(
                                    title: 'Overdue',
                                    value: taskProvider.overdueTasks.length
                                        .toString(),
                                    icon: Icons.warning,
                                    color: Colors.red,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TaskListScreen(
                                            filter: TaskFilter.overdue,
                                            title: 'Overdue Tasks',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 32),

                    // Quick actions
                    QuickActions(),
                    SizedBox(height: 32),

                    // Recent tasks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Tasks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskListScreen(
                                  filter: TaskFilter.all,
                                  title: 'All Tasks',
                                ),
                              ),
                            );
                          },
                          child: Text('View All'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Task list
                    Consumer<TaskProvider>(
                      builder: (context, taskProvider, child) {
                        final recentTasks = taskProvider.tasks.take(5).toList();

                        if (recentTasks.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            //      return Center(
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No tasks yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Create your first task to get started!',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddTaskScreen(),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add),
                                    label: Text('Add Task'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: recentTasks.map((task) {
                            return TaskCard(
                              task: task,
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddTaskScreen(task: task),
                                  ),
                                );
                              },
                              onDelete: () {
                                Future.microtask(() async {
                                  final success = await taskProvider.deleteTask(
                                    task.id,
                                  );
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Task deleted'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
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
}
