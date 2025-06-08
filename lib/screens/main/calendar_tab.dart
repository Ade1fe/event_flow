// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../../providers/task_provider.dart';
// import '../../models/task.dart';
// import '../../widgets/task_card.dart';
// import '../tasks/add_task_screen.dart';

// class CalendarTab extends StatefulWidget {
//   const CalendarTab({super.key});

//   @override
//   _CalendarTabState createState() => _CalendarTabState();
// }

// class _CalendarTabState extends State<CalendarTab> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = DateTime.now();
//   }

//   List<Task> _getTasksForDay(DateTime day, List<Task> tasks) {
//     return tasks.where((task) {
//       if (task.dueDate == null) return false;
//       return isSameDay(task.dueDate!, day);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final tasksForSelectedDay = _selectedDay != null
//         ? _getTasksForDay(_selectedDay!, taskProvider.tasks)
//         : <Task>[];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.today),
//             onPressed: () {
//               setState(() {
//                 _focusedDay = DateTime.now();
//                 _selectedDay = DateTime.now();
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           TableCalendar<Task>(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             eventLoader: (day) => _getTasksForDay(day, taskProvider.tasks),
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             calendarStyle: CalendarStyle(
//               outsideDaysVisible: false,
//               weekendTextStyle: TextStyle(color: Colors.red),
//               holidayTextStyle: TextStyle(color: Colors.red),
//               markerDecoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 shape: BoxShape.circle,
//               ),
//               selectedDecoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 shape: BoxShape.circle,
//               ),
//               todayDecoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondary,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             headerStyle: HeaderStyle(
//               formatButtonVisible: true,
//               titleCentered: true,
//               formatButtonShowsNext: false,
//               formatButtonDecoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               formatButtonTextStyle: TextStyle(color: Colors.white),
//             ),
//             onDaySelected: (selectedDay, focusedDay) {
//               if (!isSameDay(_selectedDay, selectedDay)) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               }
//             },
//             onFormatChanged: (format) {
//               if (_calendarFormat != format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               }
//             },
//             onPageChanged: (focusedDay) {
//               _focusedDay = focusedDay;
//             },
//           ),
//           const SizedBox(height: 8.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     _selectedDay != null
//                         ? 'Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}'
//                         : 'Select a date',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Expanded(
//                   child: tasksForSelectedDay.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.event_available,
//                                 size: 64,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'No tasks for this day',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Tap the + button to add a task',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: tasksForSelectedDay.length,
//                           itemBuilder: (context, index) {
//                             final task = tasksForSelectedDay[index];
//                             return TaskCard(
//                               task: task,
//                               onToggle: () =>
//                                   taskProvider.toggleTaskCompletion(task),
//                               onEdit: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         AddTaskScreen(task: task),
//                                   ),
//                                 );
//                               },
//                               onDelete: () => taskProvider.deleteTask(task.id),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:task_manager_clean/screens/add_task_screen.dart';
// import '../../providers/task_provider.dart';
// import '../../models/task.dart';
// import '../../widgets/task_card.dart';

// class CalendarTab extends StatefulWidget {
//   const CalendarTab({super.key});

//   @override
//   _CalendarTabState createState() => _CalendarTabState();
// }

// class _CalendarTabState extends State<CalendarTab> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = DateTime.now();
//   }

//   List<Task> _getTasksForDay(DateTime day, List<Task> tasks) {
//     return tasks.where((task) {
//       if (task.dueDate == null) return false;
//       return isSameDay(task.dueDate!, day);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final tasksForSelectedDay = _selectedDay != null
//         ? _getTasksForDay(_selectedDay!, taskProvider.tasks)
//         : <Task>[];

//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Calendar'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.today),
//             onPressed: () {
//               setState(() {
//                 _focusedDay = DateTime.now();
//                 _selectedDay = DateTime.now();
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Card(
//             margin: const EdgeInsets.all(16),
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TableCalendar<Task>(
//                 firstDay: DateTime.utc(2020, 1, 1),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: _focusedDay,
//                 calendarFormat: _calendarFormat,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 eventLoader: (day) => _getTasksForDay(day, taskProvider.tasks),
//                 startingDayOfWeek: StartingDayOfWeek.monday,
//                 daysOfWeekStyle: const DaysOfWeekStyle(
//                   weekendStyle: TextStyle(color: Colors.redAccent),
//                 ),
//                 calendarStyle: CalendarStyle(
//                   outsideDaysVisible: false,
//                   weekendTextStyle: const TextStyle(color: Colors.redAccent),
//                   todayDecoration: BoxDecoration(
//                     color: theme.colorScheme.secondary.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: theme.colorScheme.primary.withOpacity(0.4),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   markerDecoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   selectedTextStyle: const TextStyle(color: Colors.white),
//                 ),
//                 headerStyle: HeaderStyle(
//                   titleCentered: true,
//                   formatButtonVisible: true,
//                   formatButtonShowsNext: false,
//                   formatButtonDecoration: BoxDecoration(
//                     color: theme.colorScheme.primary,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   formatButtonTextStyle: const TextStyle(color: Colors.white),
//                   leftChevronIcon: Icon(
//                     Icons.chevron_left,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                   rightChevronIcon: Icon(
//                     Icons.chevron_right,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                   titleTextStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                 ),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   if (!isSameDay(_selectedDay, selectedDay)) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                   }
//                 },
//                 onFormatChanged: (format) {
//                   if (_calendarFormat != format) {
//                     setState(() {
//                       _calendarFormat = format;
//                     });
//                   }
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: tasksForSelectedDay.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(
//                             Icons.event_available,
//                             size: 64,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'No tasks for this day',
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Tap the + button to add a task',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: tasksForSelectedDay.length,
//                       itemBuilder: (context, index) {
//                         final task = tasksForSelectedDay[index];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 12.0),
//                           child: TaskCard(
//                             task: task,
//                             onToggle: () =>
//                                 taskProvider.toggleTaskCompletion(task),
//                             onEdit: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       AddTaskScreen(task: task),
//                                 ),
//                               );
//                             },
//                             onDelete: () => taskProvider.deleteTask(task.id),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager_clean/screens/add_task_screen.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../widgets/task_card.dart';
import '../tasks/add_task_screen.dart';
import '../../widgets/professional_app_bar.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<Task> _getTasksForDay(DateTime day, List<Task> tasks) {
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return isSameDay(task.dueDate!, day);
    }).toList();
  }

  // Custom marker builder that ALWAYS shows just ONE indicator per day
  Widget _buildMarker(DateTime day, List<Task> tasks) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;
    final hasOverdue = tasks.any((task) => task.isOverdue);

    // Determine color based on task status
    Color markerColor;
    if (hasOverdue) {
      markerColor = Colors.red;
    } else if (completedTasks == totalTasks) {
      markerColor = Colors.green;
    } else if (completedTasks > 0) {
      markerColor = Colors.orange;
    } else {
      markerColor = Theme.of(context).colorScheme.primary;
    }

    // For single task - just show a small dot
    if (totalTasks == 1) {
      return Positioned(
        bottom: 1,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    // For multiple tasks - show a badge with count
    return Positioned(
      bottom: 1,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Center(
            child: Text(
              totalTasks > 99
                  ? '99+'
                  : totalTasks > 9
                  ? '9+'
                  : totalTasks.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasksForSelectedDay = _selectedDay != null
        ? _getTasksForDay(_selectedDay!, taskProvider.tasks)
        : <Task>[];

    final theme = Theme.of(context);

    return Scaffold(
      appBar: ProfessionalAppBar(
        title: 'Calendar',
        showNotifications: true,
        showSubtitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Go to today',
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Calendar Card
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TableCalendar<Task>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) => _getTasksForDay(day, taskProvider.tasks),
                startingDayOfWeek: StartingDayOfWeek.monday,

                // IMPORTANT: This completely disables the default markers
                calendarBuilders: CalendarBuilders<Task>(
                  // This overrides the default marker builder to use our custom one
                  markerBuilder: (context, day, tasks) {
                    return _buildMarker(day, tasks);
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final tasks = _getTasksForDay(day, taskProvider.tasks);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (tasks.isNotEmpty) _buildMarker(day, tasks),
                        ],
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final tasks = _getTasksForDay(day, taskProvider.tasks);
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (tasks.isNotEmpty) _buildMarker(day, tasks),
                        ],
                      ),
                    );
                  },
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                  weekdayStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red.shade400),
                  holidayTextStyle: TextStyle(color: Colors.red.shade400),

                  // CRITICAL: These settings ensure no default markers are shown
                  markersMaxCount: 0,
                  canMarkersOverflow: false,
                  markersAnchor: 0.0,
                  markerMargin: EdgeInsets.zero,
                  markerSize: 0,

                  // Default day styling
                  defaultTextStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),

                  // Cell decoration
                  cellMargin: const EdgeInsets.all(4),
                  cellPadding: EdgeInsets.zero,

                  // Remove default decorations since we're using custom builders
                  selectedDecoration: const BoxDecoration(),
                  todayDecoration: const BoxDecoration(),
                  markerDecoration: const BoxDecoration(),
                ),

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: true,
                  formatButtonShowsNext: false,
                  headerPadding: const EdgeInsets.symmetric(vertical: 16),
                  formatButtonDecoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  formatButtonTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: theme.colorScheme.onSurface,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface,
                    size: 28,
                  ),
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
          ),

          // Legend
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('No tasks', Colors.grey, context),
                _buildLegendItem('Pending', theme.colorScheme.primary, context),
                _buildLegendItem('Partial', Colors.orange, context),
                _buildLegendItem('Complete', Colors.green, context),
                _buildLegendItem('Overdue', Colors.red, context),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Selected day header with task count
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.event, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Tasks for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (tasksForSelectedDay.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _isDarkMode(context)
                            ? Colors.white.withValues(alpha: .1)
                            : theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tasksForSelectedDay.length}',
                        style: TextStyle(
                          color: _isDarkMode(context)
                              ? Colors.white
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Tasks list with count indicator
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: tasksForSelectedDay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks for this day',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a task',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Task count indicator for many tasks
                        if (tasksForSelectedDay.length > 10)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${tasksForSelectedDay.length} tasks for this day',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                        // Task list
                        Expanded(
                          child: ListView.builder(
                            itemCount: tasksForSelectedDay.length,
                            itemBuilder: (context, index) {
                              final task = tasksForSelectedDay[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: TaskCard(
                                  task: task,
                                  onToggle: () =>
                                      taskProvider.toggleTaskCompletion(task),
                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddTaskScreen(task: task),
                                      ),
                                    );
                                  },
                                  onDelete: () =>
                                      taskProvider.deleteTask(task.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(initialDate: _selectedDay),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool _isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
