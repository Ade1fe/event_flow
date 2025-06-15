// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/task_provider.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//   final Widget? leading;
//   final bool showProfile;
//   final bool showNotifications;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onNotificationTap;
//   final Color? backgroundColor;
//   final bool centerTitle;
//   final double elevation;

//   const CustomAppBar({
//     Key? key,
//     required this.title,
//     this.actions,
//     this.leading,
//     this.showProfile = true,
//     this.showNotifications = true,
//     this.onProfileTap,
//     this.onNotificationTap,
//     this.backgroundColor,
//     this.centerTitle = true,
//     this.elevation = 0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             backgroundColor ?? Theme.of(context).colorScheme.primary,
//             backgroundColor?.withValues(alpha: .8) ??
//                 Theme.of(context).colorScheme.primaryContainer,
//           ],
//         ),
//         boxShadow: elevation > 0
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: .1),
//                   blurRadius: elevation,
//                   offset: Offset(0, elevation / 2),
//                 ),
//               ]
//             : null,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Row(
//             children: [
//               // Leading widget or back button
//               if (leading != null)
//                 leading!
//               else if (Navigator.of(context).canPop())
//                 IconButton(
//                   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),

//               Expanded(
//                 child: Align(
//                   alignment:
//                       (leading == null && !Navigator.of(context).canPop())
//                       ? Alignment.centerLeft
//                       : (centerTitle ? Alignment.center : Alignment.centerLeft),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       if (title == 'Home' || title == 'My Tasks')
//                         Consumer<TaskProvider>(
//                           builder: (context, taskProvider, child) {
//                             final pendingCount = taskProvider.pendingTasks;
//                             final overdueCount =
//                                 taskProvider.overdueTasks.length;

//                             if (pendingCount == 0 && overdueCount == 0) {
//                               return Text(
//                                 'All caught up! 🎉',
//                                 style: TextStyle(
//                                   color: Colors.white.withValues(alpha: .8),
//                                   fontSize: 12,
//                                 ),
//                               );
//                             }

//                             return Text(
//                               overdueCount > 0
//                                   ? '$overdueCount overdue, $pendingCount pending'
//                                   : '$pendingCount tasks pending',
//                               style: TextStyle(
//                                 color: Colors.white.withValues(alpha: .8),
//                                 fontSize: 12,
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               // // Actions section
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Notification bell
//                   if (showNotifications)
//                     Consumer<TaskProvider>(
//                       builder: (context, taskProvider, child) {
//                         final overdueCount = taskProvider.overdueTasks.length;

//                         return Stack(
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 Icons.notifications_outlined,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                               onPressed:
//                                   onNotificationTap ??
//                                   () {
//                                     _showNotificationsBottomSheet(
//                                       context,
//                                       taskProvider,
//                                     );
//                                   },
//                             ),
//                             if (overdueCount > 0)
//                               Positioned(
//                                 right: 8,
//                                 top: 8,
//                                 child: Container(
//                                   padding: EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   constraints: BoxConstraints(
//                                     minWidth: 16,
//                                     minHeight: 16,
//                                   ),
//                                   child: Text(
//                                     overdueCount > 99
//                                         ? '99+'
//                                         : overdueCount.toString(),
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         );
//                       },
//                     ),

//                   // Custom actions
//                   if (actions != null) ...actions!,

//                   // Profile avatar
//                   if (showProfile)
//                     Consumer<AuthProvider>(
//                       builder: (context, authProvider, child) {
//                         return GestureDetector(
//                           onTap: onProfileTap,
//                           child: Container(
//                             margin: EdgeInsets.only(left: 8),
//                             child: CircleAvatar(
//                               radius: 18,
//                               backgroundColor: Colors.white.withValues(alpha: .2),
//                               child: authProvider.userProfile?.photoUrl != null
//                                   ? ClipOval(
//                                       child: Image.network(
//                                         authProvider.userProfile!.photoUrl!,
//                                         width: 36,
//                                         height: 36,
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                               return Text(
//                                                 authProvider
//                                                         .userProfile
//                                                         ?.initials ??
//                                                     'U',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               );
//                                             },
//                                       ),
//                                     )
//                                   : Text(
//                                       authProvider.userProfile?.initials ?? 'U',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showNotificationsBottomSheet(
//     BuildContext context,
//     TaskProvider taskProvider,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.6,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           children: [
//             // Handle bar
//             Container(
//               margin: EdgeInsets.only(top: 8),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Header
//             Padding(
//               padding: EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.notifications,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   SizedBox(width: 8),
//                   Text(
//                     'Notifications',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Spacer(),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('Close'),
//                   ),
//                 ],
//               ),
//             ),

//             Divider(height: 1),

//             // Notifications list
//             Expanded(
//               child: taskProvider.overdueTasks.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.notifications_off_outlined,
//                             size: 64,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'No notifications',
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                           ),
//                           Text(
//                             'You\'re all caught up!',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: taskProvider.overdueTasks.length,
//                       itemBuilder: (context, index) {
//                         final task = taskProvider.overdueTasks[index];
//                         return Card(
//                           margin: EdgeInsets.only(bottom: 8),
//                           child: ListTile(
//                             leading: Icon(Icons.warning, color: Colors.red),
//                             title: Text(
//                               task.title,
//                               style: TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                             subtitle: Text(
//                               'Overdue: ${task.dueDateFormatted}',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             trailing: IconButton(
//                               icon: Icon(Icons.check_circle_outline),
//                               onPressed: () {
//                                 taskProvider.toggleTaskCompletion(task);
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight + 20);
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showProfile;
  final bool showNotifications;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool centerTitle;
  final double elevation;
  final ScrollController? scrollController;

  const CustomAppBar({
    super.key,
    required this.title,
    this.scrollController,
    this.actions,
    this.leading,
    this.showProfile = true,
    this.showNotifications = true,
    this.onProfileTap,
    this.onNotificationTap,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController!.offset > 10 && !_scrolled) {
      setState(() => _scrolled = true);
    } else if (widget.scrollController!.offset <= 10 && _scrolled) {
      setState(() => _scrolled = false);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Background colors based on scroll
    final Color backgroundColor = _scrolled
        ? Colors.purple
        : (isDark ? theme.colorScheme.surface : theme.colorScheme.surface);

    final Color secondaryBackgroundColor = _scrolled
        ? Colors.purple.withValues(alpha: .8)
        : (isDark
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .8));

    // Text and icon colors based on theme
    final textColor = theme.colorScheme.onSurface;
    final iconColor = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor, secondaryBackgroundColor],
        ),
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: widget.elevation,
                  offset: Offset(0, widget.elevation / 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Leading widget or back button
              if (widget.leading != null)
                widget.leading!
              else if (Navigator.of(context).canPop())
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: iconColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),

              Expanded(
                child: Align(
                  alignment:
                      (widget.leading == null &&
                          !Navigator.of(context).canPop())
                      ? Alignment.centerLeft
                      : (widget.centerTitle
                            ? Alignment.center
                            : Alignment.centerLeft),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.title == 'Home' || widget.title == 'My Tasks')
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            final pendingCount = taskProvider.pendingTasks;
                            final overdueCount =
                                taskProvider.overdueTasks.length;

                            if (pendingCount == 0 && overdueCount == 0) {
                              return Text(
                                'All caught up! 🎉',
                                style: TextStyle(
                                  color: textColor.withValues(alpha: .8),
                                  fontSize: 12,
                                ),
                              );
                            }

                            return Text(
                              overdueCount > 0
                                  ? '$overdueCount overdue, $pendingCount pending'
                                  : '$pendingCount tasks pending',
                              style: TextStyle(
                                color: textColor.withValues(alpha: .8),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Actions section
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showNotifications)
                    Consumer<TaskProvider>(
                      builder: (context, taskProvider, child) {
                        final overdueCount = taskProvider.overdueTasks.length;

                        return Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_outlined,
                                color: iconColor,
                                size: 24,
                              ),
                              onPressed:
                                  widget.onNotificationTap ??
                                  () {
                                    _showNotificationsBottomSheet(
                                      context,
                                      taskProvider,
                                    );
                                  },
                            ),
                            if (overdueCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    overdueCount > 99
                                        ? '99+'
                                        : overdueCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                  if (widget.actions != null) ...widget.actions!,

                  if (widget.showProfile)
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return GestureDetector(
                          onTap: widget.onProfileTap,
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: textColor.withValues(alpha: .2),
                              child: authProvider.userProfile?.photoUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        authProvider.userProfile!.photoUrl!,
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Text(
                                                authProvider
                                                        .userProfile
                                                        ?.initials ??
                                                    'U',
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                      ),
                                    )
                                  : Text(
                                      authProvider.userProfile?.initials ?? 'U',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsBottomSheet(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Notifications list
            Expanded(
              child: taskProvider.overdueTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No notifications',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'You\'re all caught up!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: taskProvider.overdueTasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.overdueTasks[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(Icons.warning, color: Colors.red),
                            title: Text(
                              task.title,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Overdue: ${task.dueDateFormatted}',
                              style: TextStyle(color: Colors.red),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.check_circle_outline),
                              onPressed: () {
                                taskProvider.toggleTaskCompletion(task);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
