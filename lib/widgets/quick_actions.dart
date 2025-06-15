import 'package:flutter/material.dart';
import '../screens/tasks/task_list_screen.dart';
import '../providers/task_provider.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionCard(
                context,
                'All Tasks',
                Icons.list_alt,
                Colors.blue,
                () {
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
              _buildActionCard(
                context,
                'Today',
                Icons.today,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListScreen(
                        filter: TaskFilter.today,
                        title: 'Today\'s Tasks',
                      ),
                    ),
                  );
                },
              ),
              _buildActionCard(
                context,
                'Upcoming',
                Icons.event,
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListScreen(
                        filter: TaskFilter.upcoming,
                        title: 'Upcoming Tasks',
                      ),
                    ),
                  );
                },
              ),
              _buildActionCard(
                context,
                'Completed',
                Icons.check_circle,
                Colors.purple,
                () {
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
              _buildActionCard(
                context,
                'Overdue',
                Icons.warning,
                Colors.red,
                () {
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: .3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
