import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:task_manager_clean/widgets/professional_app_bar.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/stats_card.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsTabState createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  // final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Analytics'),
      // ),
      // appBar: CustomAppBar(
      //   title: 'Analytics',
      //   showProfile: false,
      //   scrollController: _scrollController,
      //   showNotifications: true,
      // ),
      appBar: ProfessionalAppBar(
        title: 'Analytics',
        showNotifications: true,
        showSubtitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 32),

            // User stats
            Text(
              'Your Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: authProvider.userProfile?.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  authProvider.userProfile!.photoUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                authProvider.userProfile?.initials ?? 'U',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.userProfile?.displayName ?? 'User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Member since ${authProvider.userProfile?.createdAt.year ?? DateTime.now().year}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              taskProvider.totalTasks.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Total Tasks',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              taskProvider.completedTasks.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${(taskProvider.completionRate * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Success Rate',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ------
            SizedBox(height: 32),
            // Overview stats
            Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total Tasks',
                    value: taskProvider.totalTasks.toString(),
                    icon: Icons.task_alt,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Completion Rate',
                    value:
                        '${(taskProvider.completionRate * 100).toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Pending',
                    value: taskProvider.pendingTasks.toString(),
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Overdue',
                    value: taskProvider.overdueTasks.length.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Completion chart
            Text(
              'Task Completion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Container(
              height: 250,
              padding: EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //   color: Theme.of(context).colorScheme.surface,
              //   borderRadius: BorderRadius.circular(16),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withValues(alpha: .1),
              //       blurRadius: 8,
              //       offset: Offset(0, 2),
              //     ),
              //   ],
              // ),
              decoration: BoxDecoration(
                color: isDark
                    ? theme
                          .colorScheme
                          .surface // light for dark
                    : theme
                          .colorScheme
                          .surfaceContainerHighest, // dark for light
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: taskProvider.totalTasks > 0
                  ? PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: taskProvider.completedTasks.toDouble(),
                            title: 'Completed\n${taskProvider.completedTasks}',
                            radius: 60,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: taskProvider.pendingTasks.toDouble(),
                            title: 'Pending\n${taskProvider.pendingTasks}',
                            radius: 60,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (taskProvider.overdueTasks.isNotEmpty)
                            PieChartSectionData(
                              color: Colors.red,
                              value: taskProvider.overdueTasks.length
                                  .toDouble(),
                              title:
                                  'Overdue\n${taskProvider.overdueTasks.length}',
                              radius: 60,
                              titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    )
                  : Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
