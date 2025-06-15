// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/task_provider.dart';
// import '../providers/theme_provider.dart';

// class ProfessionalAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
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
//   final bool isTransparent;
//   final Widget? flexibleSpace;
//   final double height;
//   final bool showSubtitle;
//   final String? subtitle;
//   final TextStyle? titleStyle;
//   final TextStyle? subtitleStyle;
//   final bool showBackButton;
//   final bool showShadow;
//   final BorderRadius? borderRadius;

//   const ProfessionalAppBar({
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
//     this.elevation = 2,
//     this.isTransparent = false,
//     this.flexibleSpace,
//     this.height = kToolbarHeight + 20,
//     this.showSubtitle = true,
//     this.subtitle,
//     this.titleStyle,
//     this.subtitleStyle,
//     this.showBackButton = true,
//     this.showShadow = true,
//     this.borderRadius,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//     // Determine if we have a leading widget
//     final hasLeading =
//         leading != null || (Navigator.of(context).canPop() && showBackButton);

//     // Auto-adjust title alignment based on leading widget presence
//     final shouldCenterTitle = hasLeading ? centerTitle : false;

//     // Set system UI overlay style based on theme
//     SystemChrome.setSystemUIOverlayStyle(
//       isDark
//           ? SystemUiOverlayStyle.light
//           : SystemUiOverlayStyle.dark.copyWith(
//               statusBarColor: Colors.transparent,
//               statusBarIconBrightness: Brightness.dark,
//             ),
//     );

//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: isTransparent
//             ? Colors.transparent
//             : backgroundColor ?? Theme.of(context).colorScheme.surface,
//         borderRadius: borderRadius,
//         boxShadow: showShadow && elevation > 0
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: .05),
//                   blurRadius: elevation * 2,
//                   offset: Offset(0, elevation),
//                   spreadRadius: 0,
//                 ),
//               ]
//             : null,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Stack(
//             children: [
//               // Flexible space for background effects
//               if (flexibleSpace != null) flexibleSpace!,

//               // Main content
//               Row(
//                 children: [
//                   // Leading widget or back button
//                   if (leading != null)
//                     leading!
//                   else if (Navigator.of(context).canPop() && showBackButton)
//                     _buildBackButton(context),

//                   // Add spacing only if there's a leading widget
//                   if (hasLeading) SizedBox(width: 8),

//                   // Title section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: shouldCenterTitle
//                           ? CrossAxisAlignment.center
//                           : CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           title,
//                           style:
//                               titleStyle ??
//                               TextStyle(
//                                 color: isTransparent
//                                     ? Colors.white
//                                     : Theme.of(context).colorScheme.onSurface,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.15,
//                               ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (showSubtitle &&
//                             (subtitle != null ||
//                                 title == 'Home' ||
//                                 title == 'My Tasks'))
//                           subtitle != null
//                               ? Text(
//                                   subtitle!,
//                                   style:
//                                       subtitleStyle ??
//                                       TextStyle(
//                                         color: isTransparent
//                                             ? Colors.white.withValues(alpha: .8)
//                                             : Theme.of(context)
//                                                   .colorScheme
//                                                   .onSurface
//                                                   .withValues(alpha: .6),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                 )
//                               : Consumer<TaskProvider>(
//                                   builder: (context, taskProvider, child) {
//                                     final pendingCount =
//                                         taskProvider.pendingTasks;
//                                     final overdueCount =
//                                         taskProvider.overdueTasks.length;

//                                     if (pendingCount == 0 &&
//                                         overdueCount == 0) {
//                                       return Text(
//                                         'All caught up! 🎉',
//                                         style:
//                                             subtitleStyle ??
//                                             TextStyle(
//                                               color: isTransparent
//                                                   ? Colors.white.withOpacity(
//                                                       0.8,
//                                                     )
//                                                   : Theme.of(
//                                                       context,
//                                                     ).colorScheme.primary,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                       );
//                                     }

//                                     return Text(
//                                       overdueCount > 0
//                                           ? '$overdueCount overdue, $pendingCount pending'
//                                           : '$pendingCount tasks pending',
//                                       style:
//                                           subtitleStyle ??
//                                           TextStyle(
//                                             color: overdueCount > 0
//                                                 ? Theme.of(context)
//                                                       .colorScheme
//                                                       .error
//                                                       .withValues(alpha: .8)
//                                                 : isTransparent
//                                                 ? Colors.white.withValues(alpha: .8)
//                                                 : Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface
//                                                       .withValues(alpha: .6),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                     );
//                                   },
//                                 ),
//                       ],
//                     ),
//                   ),

//                   // Actions section
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Theme toggle
//                       IconButton(
//                         icon: Icon(
//                           isDark
//                               ? Icons.light_mode_outlined
//                               : Icons.dark_mode_outlined,
//                           color: isTransparent
//                               ? Colors.white
//                               : Theme.of(context).colorScheme.onSurface,
//                           size: 22,
//                         ),
//                         onPressed: () {
//                           themeProvider.toggleTheme();
//                         },
//                         tooltip: isDark ? 'Light mode' : 'Dark mode',
//                         splashRadius: 24,
//                       ),

//                       // Notification bell
//                       if (showNotifications)
//                         Consumer<TaskProvider>(
//                           builder: (context, taskProvider, child) {
//                             final overdueCount =
//                                 taskProvider.overdueTasks.length;

//                             return Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.notifications_outlined,
//                                     color: isTransparent
//                                         ? Colors.white
//                                         : Theme.of(
//                                             context,
//                                           ).colorScheme.onSurface,
//                                     size: 22,
//                                   ),
//                                   onPressed:
//                                       onNotificationTap ??
//                                       () {
//                                         _showNotificationsBottomSheet(
//                                           context,
//                                           taskProvider,
//                                         );
//                                       },
//                                   tooltip: 'Notifications',
//                                   splashRadius: 24,
//                                 ),
//                                 if (overdueCount > 0)
//                                   Positioned(
//                                     right: 6,
//                                     top: 6,
//                                     child: Container(
//                                       padding: EdgeInsets.all(
//                                         overdueCount > 9 ? 2 : 0,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Theme.of(
//                                           context,
//                                         ).colorScheme.error,
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: isTransparent
//                                               ? Colors.black.withValues(alpha: .1)
//                                               : Theme.of(
//                                                   context,
//                                                 ).colorScheme.surface,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       constraints: BoxConstraints(
//                                         minWidth: 18,
//                                         minHeight: 18,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           overdueCount > 99
//                                               ? '99+'
//                                               : overdueCount.toString(),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             );
//                           },
//                         ),

//                       // Custom actions
//                       if (actions != null) ...actions!,

//                       // Profile avatar
//                       if (showProfile)
//                         Consumer<AuthProvider>(
//                           builder: (context, authProvider, child) {
//                             return GestureDetector(
//                               onTap: onProfileTap,
//                               child: Container(
//                                 margin: EdgeInsets.only(left: 4),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: isTransparent
//                                         ? Colors.white.withValues(alpha: .2)
//                                         : Theme.of(context).colorScheme.primary
//                                               .withValues(alpha: .2),
//                                     width: 2,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withValues(alpha: .05),
//                                       blurRadius: 4,
//                                       spreadRadius: 1,
//                                     ),
//                                   ],
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: 16,
//                                   backgroundColor: isTransparent
//                                       ? Colors.white.withValues(alpha: .2)
//                                       : Theme.of(
//                                           context,
//                                         ).colorScheme.primary.withValues(alpha: .1),
//                                   child:
//                                       authProvider.userProfile?.photoUrl != null
//                                       ? ClipOval(
//                                           child: Image.network(
//                                             authProvider.userProfile!.photoUrl!,
//                                             width: 32,
//                                             height: 32,
//                                             fit: BoxFit.cover,
//                                             errorBuilder:
//                                                 (context, error, stackTrace) {
//                                                   return Text(
//                                                     authProvider
//                                                             .userProfile
//                                                             ?.initials ??
//                                                         'U',
//                                                     style: TextStyle(
//                                                       color: isTransparent
//                                                           ? Colors.white
//                                                           : Theme.of(context)
//                                                                 .colorScheme
//                                                                 .primary,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   );
//                                                 },
//                                           ),
//                                         )
//                                       : Text(
//                                           authProvider.userProfile?.initials ??
//                                               'U',
//                                           style: TextStyle(
//                                             color: isTransparent
//                                                 ? Colors.white
//                                                 : Theme.of(
//                                                     context,
//                                                   ).colorScheme.primary,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackButton(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 4),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isTransparent
//             ? Colors.white.withValues(alpha: .2)
//             : Theme.of(context).colorScheme.surface,
//         border: Border.all(
//           color: isTransparent
//               ? Colors.white.withValues(alpha: .1)
//               : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
//           width: 1,
//         ),
//         boxShadow: showShadow
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: .05),
//                   blurRadius: 4,
//                   spreadRadius: 0,
//                 ),
//               ]
//             : null,
//       ),
//       child: IconButton(
//         icon: Icon(
//           Icons.arrow_back_ios_rounded,
//           size: 18,
//           color: isTransparent
//               ? Colors.white
//               : Theme.of(context).colorScheme.onSurface,
//         ),
//         onPressed: () => Navigator.of(context).pop(),
//         padding: EdgeInsets.zero,
//         constraints: BoxConstraints(minWidth: 36, minHeight: 36),
//         splashRadius: 20,
//       ),
//     );
//   }

//   void _showNotificationsBottomSheet(
//     BuildContext context,
//     TaskProvider taskProvider,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.6,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: .1),
//               blurRadius: 10,
//               spreadRadius: 0,
//               offset: Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Handle bar
//             Container(
//               margin: EdgeInsets.only(top: 12),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Header
//             Padding(
//               padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.primary.withValues(alpha: .1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.notifications_outlined,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 20,
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     'Notifications',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.15,
//                     ),
//                   ),
//                   Spacer(),
//                   TextButton.icon(
//                     onPressed: () => Navigator.pop(context),
//                     icon: Icon(Icons.close, size: 18),
//                     label: Text('Close'),
//                     style: TextButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.primary,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),

//             // Notifications list
//             Expanded(
//               child: taskProvider.overdueTasks.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.primary.withValues(alpha: .1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.check_circle_outline_rounded,
//                               size: 48,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'All caught up!',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'You have no pending notifications',
//                             style: TextStyle(
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.onSurface.withValues(alpha: .6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.separated(
//                       padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
//                       itemCount: taskProvider.overdueTasks.length,
//                       separatorBuilder: (context, index) => SizedBox(height: 8),
//                       itemBuilder: (context, index) {
//                         final task = taskProvider.overdueTasks[index];
//                         return Card(
//                           elevation: 0,
//                           margin: EdgeInsets.zero,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.outline.withValues(alpha: .2),
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(12),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(
//                                       context,
//                                     ).colorScheme.error.withValues(alpha: .1),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Icon(
//                                     Icons.warning_rounded,
//                                     color: Theme.of(context).colorScheme.error,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         task.title,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         'Overdue: ${task.dueDateFormatted}',
//                                         style: TextStyle(
//                                           color: Theme.of(
//                                             context,
//                                           ).colorScheme.error,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.check_circle_outline_rounded,
//                                     color: Theme.of(
//                                       context,
//                                     ).colorScheme.primary,
//                                   ),
//                                   onPressed: () {
//                                     taskProvider.toggleTaskCompletion(task);
//                                     if (taskProvider.overdueTasks.isEmpty) {
//                                       Navigator.pop(context);
//                                     }
//                                   },
//                                   tooltip: 'Mark as complete',
//                                   splashRadius: 24,
//                                 ),
//                               ],
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
//   Size get preferredSize => Size.fromHeight(height);
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/task_provider.dart';
// import '../providers/theme_provider.dart';

// class ProfessionalAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
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
//   final bool isTransparent;
//   final Widget? flexibleSpace;
//   final double height;
//   final bool showSubtitle;
//   final String? subtitle;
//   final TextStyle? titleStyle;
//   final TextStyle? subtitleStyle;
//   final bool showBackButton;
//   final bool showShadow;
//   final BorderRadius? borderRadius;

//   const ProfessionalAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.leading,
//     this.showProfile = true,
//     this.showNotifications = true,
//     this.onProfileTap,
//     this.onNotificationTap,
//     this.backgroundColor,
//     this.centerTitle = true,
//     this.elevation = 2,
//     this.isTransparent = false,
//     this.flexibleSpace,
//     this.height = kToolbarHeight + 20,
//     this.showSubtitle = true,
//     this.subtitle,
//     this.titleStyle,
//     this.subtitleStyle,
//     this.showBackButton = true,
//     this.showShadow = true,
//     this.borderRadius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//     // Determine if we have a leading widget
//     final hasLeading =
//         leading != null || (Navigator.of(context).canPop() && showBackButton);

//     // Auto-adjust title alignment based on leading widget presence
//     final shouldCenterTitle = hasLeading ? centerTitle : false;

//     // Set system UI overlay style based on theme
//     SystemChrome.setSystemUIOverlayStyle(
//       isDark
//           ? SystemUiOverlayStyle.light
//           : SystemUiOverlayStyle.dark.copyWith(
//               statusBarColor: Colors.transparent,
//               statusBarIconBrightness: Brightness.dark,
//             ),
//     );

//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: isTransparent
//             ? Colors.transparent
//             : backgroundColor ?? Theme.of(context).colorScheme.surface,
//         borderRadius: borderRadius,
//         boxShadow: showShadow && elevation > 0
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: .05),
//                   blurRadius: elevation * 2,
//                   offset: Offset(0, elevation),
//                   spreadRadius: 0,
//                 ),
//               ]
//             : null,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Stack(
//             children: [
//               // Flexible space for background effects
//               if (flexibleSpace != null) Positioned.fill(child: flexibleSpace!),

//               // Main content
//               Row(
//                 children: [
//                   // Leading widget or back button
//                   if (leading != null)
//                     leading!
//                   else if (Navigator.of(context).canPop() && showBackButton)
//                     _buildBackButton(context),

//                   // Add spacing only if there's a leading widget
//                   if (hasLeading) const SizedBox(width: 8),

//                   // Title section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: shouldCenterTitle
//                           ? CrossAxisAlignment.center
//                           : CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           title,
//                           style:
//                               titleStyle ??
//                               TextStyle(
//                                 color: isTransparent
//                                     ? Colors.white
//                                     : Theme.of(context).colorScheme.onSurface,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.15,
//                               ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (showSubtitle &&
//                             (subtitle != null ||
//                                 title == 'Home' ||
//                                 title == 'My Tasks'))
//                           subtitle != null
//                               ? Text(
//                                   subtitle!,
//                                   style:
//                                       subtitleStyle ??
//                                       TextStyle(
//                                         color: isTransparent
//                                             ? Colors.white.withValues(alpha: .8)
//                                             : Theme.of(context)
//                                                   .colorScheme
//                                                   .onSurface
//                                                   .withValues(alpha: .6),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                 )
//                               : Consumer<TaskProvider>(
//                                   builder: (context, taskProvider, child) {
//                                     final pendingCount =
//                                         taskProvider.pendingTasks;
//                                     final overdueCount =
//                                         taskProvider.overdueTasks.length;

//                                     if (pendingCount == 0 &&
//                                         overdueCount == 0) {
//                                       return Text(
//                                         'All caught up! 🎉',
//                                         style:
//                                             subtitleStyle ??
//                                             TextStyle(
//                                               color: isTransparent
//                                                   ? Colors.white.withOpacity(
//                                                       0.8,
//                                                     )
//                                                   : Theme.of(
//                                                       context,
//                                                     ).colorScheme.primary,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                       );
//                                     }

//                                     return Text(
//                                       overdueCount > 0
//                                           ? '$overdueCount overdue, $pendingCount pending'
//                                           : '$pendingCount tasks pending',
//                                       style:
//                                           subtitleStyle ??
//                                           TextStyle(
//                                             color: overdueCount > 0
//                                                 ? Theme.of(context)
//                                                       .colorScheme
//                                                       .error
//                                                       .withValues(alpha: .8)
//                                                 : isTransparent
//                                                 ? Colors.white.withValues(alpha: .8)
//                                                 : Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface
//                                                       .withValues(alpha: .6),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                     );
//                                   },
//                                 ),
//                       ],
//                     ),
//                   ),

//                   // Actions section
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Theme toggle
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () {
//                             HapticFeedback.lightImpact();
//                             themeProvider.toggleTheme();
//                           },
//                           borderRadius: BorderRadius.circular(24),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             child: Icon(
//                               isDark
//                                   ? Icons.light_mode_outlined
//                                   : Icons.dark_mode_outlined,
//                               color: isTransparent
//                                   ? Colors.white
//                                   : Theme.of(context).colorScheme.onSurface,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 4),

//                       // Notification bell
//                       if (showNotifications)
//                         Consumer<TaskProvider>(
//                           builder: (context, taskProvider, child) {
//                             final overdueCount =
//                                 taskProvider.overdueTasks.length;

//                             return Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap:
//                                     onNotificationTap ??
//                                     () {
//                                       HapticFeedback.lightImpact();
//                                       _showNotificationsBottomSheet(
//                                         context,
//                                         taskProvider,
//                                       );
//                                     },
//                                 borderRadius: BorderRadius.circular(24),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   child: Stack(
//                                     clipBehavior: Clip.none,
//                                     children: [
//                                       Icon(
//                                         Icons.notifications_outlined,
//                                         color: isTransparent
//                                             ? Colors.white
//                                             : Theme.of(
//                                                 context,
//                                               ).colorScheme.onSurface,
//                                         size: 22,
//                                       ),
//                                       if (overdueCount > 0)
//                                         Positioned(
//                                           right: -2,
//                                           top: -2,
//                                           child: Container(
//                                             padding: EdgeInsets.all(
//                                               overdueCount > 9 ? 2 : 4,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Theme.of(
//                                                 context,
//                                               ).colorScheme.error,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               border: Border.all(
//                                                 color: isTransparent
//                                                     ? Colors.white
//                                                     : Theme.of(
//                                                         context,
//                                                       ).colorScheme.surface,
//                                                 width: 1.5,
//                                               ),
//                                             ),
//                                             constraints: const BoxConstraints(
//                                               minWidth: 16,
//                                               minHeight: 16,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 overdueCount > 99
//                                                     ? '99+'
//                                                     : overdueCount.toString(),
//                                                 style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 9,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),

//                       const SizedBox(width: 4),

//                       // Custom actions
//                       if (actions != null) ...actions!,

//                       // Profile avatar
//                       if (showProfile)
//                         Consumer<AuthProvider>(
//                           builder: (context, authProvider, child) {
//                             return Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   HapticFeedback.lightImpact();
//                                   if (onProfileTap != null) {
//                                     onProfileTap!();
//                                   }
//                                 },
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Container(
//                                   margin: const EdgeInsets.only(left: 4),
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: isTransparent
//                                           ? Colors.white.withValues(alpha: .2)
//                                           : Theme.of(context)
//                                                 .colorScheme
//                                                 .primary
//                                                 .withValues(alpha: .2),
//                                       width: 2,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withValues(alpha: .05),
//                                         blurRadius: 4,
//                                         spreadRadius: 1,
//                                       ),
//                                     ],
//                                   ),
//                                   child: CircleAvatar(
//                                     radius: 16,
//                                     backgroundColor: isTransparent
//                                         ? Colors.white.withValues(alpha: .2)
//                                         : Theme.of(context).colorScheme.primary
//                                               .withValues(alpha: .1),
//                                     child:
//                                         authProvider.userProfile?.photoUrl !=
//                                             null
//                                         ? ClipOval(
//                                             child: Image.network(
//                                               authProvider
//                                                   .userProfile!
//                                                   .photoUrl!,
//                                               width: 32,
//                                               height: 32,
//                                               fit: BoxFit.cover,
//                                               errorBuilder:
//                                                   (context, error, stackTrace) {
//                                                     return Text(
//                                                       authProvider
//                                                               .userProfile
//                                                               ?.initials ??
//                                                           'U',
//                                                       style: TextStyle(
//                                                         color: isTransparent
//                                                             ? Colors.white
//                                                             : Theme.of(context)
//                                                                   .colorScheme
//                                                                   .primary,
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     );
//                                                   },
//                                             ),
//                                           )
//                                         : Text(
//                                             authProvider
//                                                     .userProfile
//                                                     ?.initials ??
//                                                 'U',
//                                             style: TextStyle(
//                                               color: isTransparent
//                                                   ? Colors.white
//                                                   : Theme.of(
//                                                       context,
//                                                     ).colorScheme.primary,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackButton(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           Navigator.of(context).pop();
//         },
//         borderRadius: BorderRadius.circular(18),
//         child: Container(
//           margin: const EdgeInsets.only(right: 4),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isTransparent
//                 ? Colors.white.withValues(alpha: .2)
//                 : Theme.of(context).colorScheme.surface,
//             border: Border.all(
//               color: isTransparent
//                   ? Colors.white.withValues(alpha: .1)
//                   : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
//               width: 1,
//             ),
//             boxShadow: showShadow
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: .05),
//                       blurRadius: 4,
//                       spreadRadius: 0,
//                     ),
//                   ]
//                 : null,
//           ),
//           width: 36,
//           height: 36,
//           child: Center(
//             child: Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 18,
//               color: isTransparent
//                   ? Colors.white
//                   : Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showNotificationsBottomSheet(
//     BuildContext context,
//     TaskProvider taskProvider,
//   ) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.6,
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isDark
//                   ? Colors.black.withValues(alpha: .4)
//                   : Colors.black.withValues(alpha: .1),
//               blurRadius: 12,
//               spreadRadius: 0,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Handle bar
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.onSurface.withValues(alpha: .3),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Header
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.primary.withValues(alpha: .1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.notifications_outlined,
//                       color: theme.colorScheme.primary,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     'Notifications',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       borderRadius: BorderRadius.circular(8),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.close,
//                               size: 18,
//                               color: theme.colorScheme.primary,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Close',
//                               style: TextStyle(
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(height: 1, thickness: 1, indent: 20, endIndent: 20),

//             // Notifications list
//             Expanded(
//               child: taskProvider.overdueTasks.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: theme.colorScheme.primary.withValues(alpha: .1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.check_circle_outline_rounded,
//                               size: 48,
//                               color: theme.colorScheme.primary,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'All caught up!',
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: theme.colorScheme.onSurface,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'You have no pending notifications',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color: theme.colorScheme.onSurface.withOpacity(
//                                 0.6,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.separated(
//                       padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//                       itemCount: taskProvider.overdueTasks.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 8),
//                       itemBuilder: (context, index) {
//                         final task = taskProvider.overdueTasks[index];
//                         return Card(
//                           elevation: 0,
//                           margin: EdgeInsets.zero,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(
//                               color: theme.colorScheme.outline.withOpacity(
//                                 0.15,
//                               ),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: theme.colorScheme.error.withOpacity(
//                                       0.1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Icon(
//                                     Icons.warning_rounded,
//                                     color: theme.colorScheme.error,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         task.title,
//                                         style: theme.textTheme.bodyMedium
//                                             ?.copyWith(
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         'Overdue: ${task.dueDateFormatted}',
//                                         style: theme.textTheme.bodySmall
//                                             ?.copyWith(
//                                               color: theme.colorScheme.error,
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     onTap: () {
//                                       HapticFeedback.lightImpact();
//                                       taskProvider.toggleTaskCompletion(task);
//                                       if (taskProvider.overdueTasks.isEmpty) {
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     borderRadius: BorderRadius.circular(24),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(8),
//                                       child: Icon(
//                                         Icons.check_circle_outline_rounded,
//                                         color: theme.colorScheme.primary,
//                                         size: 24,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
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
//   Size get preferredSize => Size.fromHeight(height);
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/task_provider.dart';
// import '../providers/theme_provider.dart';

// class ProfessionalAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
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
//   final bool isTransparent;
//   final Widget? flexibleSpace;
//   final double height;
//   final bool showSubtitle;
//   final String? subtitle;
//   final TextStyle? titleStyle;
//   final TextStyle? subtitleStyle;
//   final bool showBackButton;
//   final bool showShadow;
//   final BorderRadius? borderRadius;

//   const ProfessionalAppBar({
//     super.key,
//     required this.title,
//     this.actions,
//     this.leading,
//     this.showProfile = true,
//     this.showNotifications = true,
//     this.onProfileTap,
//     this.onNotificationTap,
//     this.backgroundColor,
//     this.centerTitle = true,
//     this.elevation = 2,
//     this.isTransparent = false,
//     this.flexibleSpace,
//     this.height = kToolbarHeight + 20,
//     this.showSubtitle = true,
//     this.subtitle,
//     this.titleStyle,
//     this.subtitleStyle,
//     this.showBackButton = true,
//     this.showShadow = true,
//     this.borderRadius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//     // Determine if we have a leading widget
//     final hasLeading =
//         leading != null || (Navigator.of(context).canPop() && showBackButton);

//     // Auto-adjust title alignment based on leading widget presence
//     final shouldCenterTitle = hasLeading ? centerTitle : false;

//     // Set system UI overlay style based on theme
//     SystemChrome.setSystemUIOverlayStyle(
//       isDark
//           ? SystemUiOverlayStyle.light
//           : SystemUiOverlayStyle.dark.copyWith(
//               statusBarColor: Colors.transparent,
//               statusBarIconBrightness: Brightness.dark,
//             ),
//     );

//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: isTransparent
//             ? Colors.transparent
//             : backgroundColor ?? Theme.of(context).colorScheme.surface,
//         borderRadius: borderRadius,
//         boxShadow: showShadow && elevation > 0
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: .05),
//                   blurRadius: elevation * 2,
//                   offset: Offset(0, elevation),
//                   spreadRadius: 0,
//                 ),
//               ]
//             : null,
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Stack(
//             children: [
//               // Flexible space for background effects
//               if (flexibleSpace != null) Positioned.fill(child: flexibleSpace!),

//               // Main content
//               Row(
//                 children: [
//                   // Leading widget or back button
//                   if (leading != null)
//                     leading!
//                   else if (Navigator.of(context).canPop() && showBackButton)
//                     _buildBackButton(context),

//                   // Add spacing only if there's a leading widget
//                   if (hasLeading) const SizedBox(width: 8),

//                   // Title section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: shouldCenterTitle
//                           ? CrossAxisAlignment.center
//                           : CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           title,
//                           style:
//                               titleStyle ??
//                               TextStyle(
//                                 color: isTransparent
//                                     ? Colors.white
//                                     : Theme.of(context).colorScheme.onSurface,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.15,
//                               ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (showSubtitle &&
//                             (subtitle != null ||
//                                 title == 'Home' ||
//                                 title == 'My Tasks'))
//                           subtitle != null
//                               ? Text(
//                                   subtitle!,
//                                   style:
//                                       subtitleStyle ??
//                                       TextStyle(
//                                         color: isTransparent
//                                             ? Colors.white.withValues(alpha: .8)
//                                             : Theme.of(context)
//                                                   .colorScheme
//                                                   .onSurface
//                                                   .withValues(alpha: .6),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                 )
//                               : Consumer<TaskProvider>(
//                                   builder: (context, taskProvider, child) {
//                                     final pendingCount =
//                                         taskProvider.pendingTasks;
//                                     final overdueCount =
//                                         taskProvider.overdueTasks.length;

//                                     if (pendingCount == 0 &&
//                                         overdueCount == 0) {
//                                       return Text(
//                                         'All caught up! 🎉',
//                                         style:
//                                             subtitleStyle ??
//                                             TextStyle(
//                                               color: isTransparent
//                                                   ? Colors.white.withOpacity(
//                                                       0.8,
//                                                     )
//                                                   : Theme.of(
//                                                       context,
//                                                     ).colorScheme.primary,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                       );
//                                     }

//                                     return Text(
//                                       overdueCount > 0
//                                           ? '$overdueCount overdue, $pendingCount pending'
//                                           : '$pendingCount tasks pending',
//                                       style:
//                                           subtitleStyle ??
//                                           TextStyle(
//                                             color: overdueCount > 0
//                                                 ? Theme.of(context)
//                                                       .colorScheme
//                                                       .error
//                                                       .withValues(alpha: .8)
//                                                 : isTransparent
//                                                 ? Colors.white.withValues(alpha: .8)
//                                                 : Theme.of(context)
//                                                       .colorScheme
//                                                       .onSurface
//                                                       .withValues(alpha: .6),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                     );
//                                   },
//                                 ),
//                       ],
//                     ),
//                   ),

//                   // Actions section
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Theme toggle
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () {
//                             HapticFeedback.lightImpact();
//                             themeProvider.toggleTheme();
//                           },
//                           borderRadius: BorderRadius.circular(24),
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             child: Icon(
//                               isDark
//                                   ? Icons.light_mode_outlined
//                                   : Icons.dark_mode_outlined,
//                               color: isTransparent
//                                   ? Colors.white
//                                   : Theme.of(context).colorScheme.onSurface,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 4),

//                       // Notification bell with improved badge
//                       if (showNotifications)
//                         Consumer<TaskProvider>(
//                           builder: (context, taskProvider, child) {
//                             final overdueCount =
//                                 taskProvider.overdueTasks.length;

//                             return Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap:
//                                     onNotificationTap ??
//                                     () {
//                                       HapticFeedback.lightImpact();
//                                       _showNotificationsBottomSheet(
//                                         context,
//                                         taskProvider,
//                                       );
//                                     },
//                                 borderRadius: BorderRadius.circular(24),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8),
//                                   child: SizedBox(
//                                     width: 24,
//                                     height: 24,
//                                     child: Stack(
//                                       children: [
//                                         // Notification icon
//                                         Positioned.fill(
//                                           child: Icon(
//                                             Icons.notifications_outlined,
//                                             color: isTransparent
//                                                 ? Colors.white
//                                                 : Theme.of(
//                                                     context,
//                                                   ).colorScheme.onSurface,
//                                             size: 22,
//                                           ),
//                                         ),
//                                         // Badge
//                                         if (overdueCount > 0)
//                                           Positioned(
//                                             right: 0,
//                                             top: 0,
//                                             child: Container(
//                                               width: 14,
//                                               height: 14,
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 4,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Theme.of(
//                                                   context,
//                                                 ).colorScheme.error,
//                                                 borderRadius:
//                                                     BorderRadius.circular(7),
//                                                 border: Border.all(
//                                                   color: isTransparent
//                                                       ? Colors.white
//                                                       : Theme.of(
//                                                           context,
//                                                         ).colorScheme.surface,
//                                                   width: 1,
//                                                 ),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   overdueCount > 99
//                                                       ? '99+'
//                                                       : overdueCount.toString(),
//                                                   style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 8,
//                                                     fontWeight: FontWeight.bold,
//                                                     height: 1,
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),

//                       const SizedBox(width: 4),

//                       // Custom actions
//                       if (actions != null) ...actions!,

//                       // Profile avatar
//                       if (showProfile)
//                         Consumer<AuthProvider>(
//                           builder: (context, authProvider, child) {
//                             return Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   HapticFeedback.lightImpact();
//                                   if (onProfileTap != null) {
//                                     onProfileTap!();
//                                   }
//                                 },
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Container(
//                                   margin: const EdgeInsets.only(left: 4),
//                                   padding: const EdgeInsets.all(2),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: isTransparent
//                                           ? Colors.white.withValues(alpha: .2)
//                                           : Theme.of(context)
//                                                 .colorScheme
//                                                 .primary
//                                                 .withValues(alpha: .2),
//                                       width: 2,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withValues(alpha: .05),
//                                         blurRadius: 4,
//                                         spreadRadius: 1,
//                                       ),
//                                     ],
//                                   ),
//                                   child: CircleAvatar(
//                                     radius: 16,
//                                     backgroundColor: isTransparent
//                                         ? Colors.white.withValues(alpha: .2)
//                                         : Theme.of(context).colorScheme.primary
//                                               .withValues(alpha: .1),
//                                     child:
//                                         authProvider.userProfile?.photoUrl !=
//                                             null
//                                         ? ClipOval(
//                                             child: Image.network(
//                                               authProvider
//                                                   .userProfile!
//                                                   .photoUrl!,
//                                               width: 32,
//                                               height: 32,
//                                               fit: BoxFit.cover,
//                                               errorBuilder:
//                                                   (context, error, stackTrace) {
//                                                     return Text(
//                                                       authProvider
//                                                               .userProfile
//                                                               ?.initials ??
//                                                           'U',
//                                                       style: TextStyle(
//                                                         color: isTransparent
//                                                             ? Colors.white
//                                                             : Theme.of(context)
//                                                                   .colorScheme
//                                                                   .primary,
//                                                         fontSize: 12,
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                       ),
//                                                     );
//                                                   },
//                                             ),
//                                           )
//                                         : Text(
//                                             authProvider
//                                                     .userProfile
//                                                     ?.initials ??
//                                                 'U',
//                                             style: TextStyle(
//                                               color: isTransparent
//                                                   ? Colors.white
//                                                   : Theme.of(
//                                                       context,
//                                                     ).colorScheme.primary,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackButton(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           Navigator.of(context).pop();
//         },
//         borderRadius: BorderRadius.circular(18),
//         child: Container(
//           margin: const EdgeInsets.only(right: 4),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isTransparent
//                 ? Colors.white.withValues(alpha: .2)
//                 : Theme.of(context).colorScheme.surface,
//             border: Border.all(
//               color: isTransparent
//                   ? Colors.white.withValues(alpha: .1)
//                   : Theme.of(context).colorScheme.onSurface.withValues(alpha: .1),
//               width: 1,
//             ),
//             boxShadow: showShadow
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: .05),
//                       blurRadius: 4,
//                       spreadRadius: 0,
//                     ),
//                   ]
//                 : null,
//           ),
//           width: 36,
//           height: 36,
//           child: Center(
//             child: Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 18,
//               color: isTransparent
//                   ? Colors.white
//                   : Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showNotificationsBottomSheet(
//     BuildContext context,
//     TaskProvider taskProvider,
//   ) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//     final colorScheme = theme.colorScheme;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         decoration: BoxDecoration(
//           color: colorScheme.surface,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(28),
//             topRight: Radius.circular(28),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isDark
//                   ? Colors.black.withValues(alpha: .6)
//                   : Colors.black.withValues(alpha: .15),
//               blurRadius: 20,
//               spreadRadius: 0,
//               offset: const Offset(0, -8),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // Handle bar
//             Container(
//               margin: const EdgeInsets.only(top: 16),
//               width: 48,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: colorScheme.onSurface.withValues(alpha: .2),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Header
//             Container(
//               padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: colorScheme.primary.withValues(alpha: .1),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: colorScheme.primary.withValues(alpha: .2),
//                         width: 1,
//                       ),
//                     ),
//                     child: Icon(
//                       Icons.notifications_rounded,
//                       color: colorScheme.primary,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Notifications',
//                           style: theme.textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: colorScheme.onSurface,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           taskProvider.overdueTasks.isEmpty
//                               ? 'All up to date'
//                               : '${taskProvider.overdueTasks.length} overdue tasks',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: colorScheme.onSurface.withValues(alpha: .6),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       borderRadius: BorderRadius.circular(12),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: colorScheme.onSurface.withValues(alpha: .05),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           Icons.close_rounded,
//                           size: 20,
//                           color: colorScheme.onSurface.withValues(alpha: .7),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Divider
//             Container(
//               height: 1,
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     colorScheme.onSurface.withValues(alpha: .05),
//                     colorScheme.onSurface.withValues(alpha: .1),
//                     colorScheme.onSurface.withValues(alpha: .05),
//                   ],
//                 ),
//               ),
//             ),

//             // Notifications list
//             Expanded(
//               child: taskProvider.overdueTasks.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   colorScheme.primary.withValues(alpha: .1),
//                                   colorScheme.primary.withValues(alpha: .05),
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: colorScheme.primary.withValues(alpha: .2),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Icon(
//                               Icons.check_circle_rounded,
//                               size: 56,
//                               color: colorScheme.primary,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           Text(
//                             'All caught up! 🎉',
//                             style: theme.textTheme.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.w700,
//                               color: colorScheme.onSurface,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'You have no pending notifications.\nGreat job staying on top of things!',
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: colorScheme.onSurface.withValues(alpha: .6),
//                               height: 1.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.separated(
//                       padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
//                       itemCount: taskProvider.overdueTasks.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 12),
//                       itemBuilder: (context, index) {
//                         final task = taskProvider.overdueTasks[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: isDark ? colorScheme.surface : Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: colorScheme.error.withValues(alpha: .2),
//                               width: 1,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: isDark
//                                     ? Colors.black.withValues(alpha: .2)
//                                     : colorScheme.shadow.withValues(alpha: .08),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () {
//                                 // Handle task tap if needed
//                               },
//                               borderRadius: BorderRadius.circular(16),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             colorScheme.error.withValues(alpha: .15),
//                                             colorScheme.error.withValues(alpha: .1),
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: colorScheme.error.withOpacity(
//                                             0.3,
//                                           ),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.warning_rounded,
//                                         color: colorScheme.error,
//                                         size: 20,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             task.title,
//                                             style: theme.textTheme.bodyLarge
//                                                 ?.copyWith(
//                                                   fontWeight: FontWeight.w600,
//                                                   color: colorScheme.onSurface,
//                                                 ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           const SizedBox(height: 6),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 8,
//                                               vertical: 4,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: colorScheme.error
//                                                   .withValues(alpha: .1),
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                             ),
//                                             child: Text(
//                                               'Overdue: ${task.dueDateFormatted}',
//                                               style: theme.textTheme.bodySmall
//                                                   ?.copyWith(
//                                                     color: colorScheme.error,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         onTap: () {
//                                           HapticFeedback.lightImpact();
//                                           taskProvider.toggleTaskCompletion(
//                                             task,
//                                           );
//                                           if (taskProvider
//                                               .overdueTasks
//                                               .isEmpty) {
//                                             Navigator.pop(context);
//                                           }
//                                         },
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             gradient: LinearGradient(
//                                               colors: [
//                                                 colorScheme.primary,
//                                                 colorScheme.primary.withOpacity(
//                                                   0.8,
//                                                 ),
//                                               ],
//                                               begin: Alignment.topLeft,
//                                               end: Alignment.bottomRight,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: colorScheme.primary
//                                                     .withValues(alpha: .3),
//                                                 blurRadius: 8,
//                                                 offset: const Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: const Icon(
//                                             Icons.check_rounded,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
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
//   Size get preferredSize => Size.fromHeight(height);
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';

class ProfessionalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showProfile;
  final bool showNotifications;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final bool isTransparent;
  final Widget? flexibleSpace;
  final double height;
  final bool showSubtitle;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showBackButton;
  final bool showShadow;
  final BorderRadius? borderRadius;

  const ProfessionalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showProfile = true,
    this.showNotifications = true,
    this.onProfileTap,
    this.onNotificationTap,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 2,
    this.isTransparent = false,
    this.flexibleSpace,
    this.height = kToolbarHeight + 30,
    this.showSubtitle = true,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.showBackButton = true,
    this.showShadow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Determine if we have a leading widget
    final hasLeading =
        leading != null || (Navigator.of(context).canPop() && showBackButton);

    // Auto-adjust title alignment based on leading widget presence
    final shouldCenterTitle = hasLeading ? centerTitle : false;

    // Set system UI overlay style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.transparent
            : backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
        boxShadow: showShadow && elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Stack(
            children: [
              // Flexible space for background effects
              if (flexibleSpace != null) Positioned.fill(child: flexibleSpace!),

              // Main content
              Row(
                children: [
                  // Leading widget or back button
                  if (leading != null)
                    leading!
                  else if (Navigator.of(context).canPop() && showBackButton)
                    _buildBackButton(context),

                  // Add spacing only if there's a leading widget
                  if (hasLeading) const SizedBox(width: 8),

                  // Title section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: shouldCenterTitle
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style:
                              titleStyle ??
                              TextStyle(
                                color: isTransparent
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showSubtitle &&
                            (subtitle != null ||
                                title == 'Home' ||
                                title == 'My Tasks'))
                          subtitle != null
                              ? Text(
                                  subtitle!,
                                  style:
                                      subtitleStyle ??
                                      TextStyle(
                                        color: isTransparent
                                            ? Colors.white.withValues(alpha: .8)
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: .6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                )
                              : Consumer<TaskProvider>(
                                  builder: (context, taskProvider, child) {
                                    final pendingCount =
                                        taskProvider.pendingTasks;
                                    final overdueCount =
                                        taskProvider.overdueTasks.length;

                                    if (pendingCount == 0 &&
                                        overdueCount == 0) {
                                      return Text(
                                        'All caught up! 🎉',
                                        style:
                                            subtitleStyle ??
                                            TextStyle(
                                              color: isTransparent
                                                  ? Colors.white.withValues(
                                                      alpha: .8,
                                                    )
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      );
                                    }

                                    // return Text(
                                    //   overdueCount > 0
                                    //       ? '$overdueCount overdue, $pendingCount pending'
                                    //       : '$pendingCount tasks pending',
                                    //   style:
                                    //       subtitleStyle ??
                                    //       TextStyle(
                                    //         color: overdueCount > 0
                                    //             ? Theme.of(context)
                                    //                   .colorScheme
                                    //                   .error
                                    //                   .withValues(alpha: .8)
                                    //             : isTransparent
                                    //             ? Colors.white.withValues(alpha: .8)
                                    //             : Theme.of(context)
                                    //                   .colorScheme
                                    //                   .onSurface
                                    //                   .withValues(alpha: .6),
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.w400,
                                    //       ),
                                    // );
                                    return Text(
                                      overdueCount > 0
                                          ? '$overdueCount overdue, $pendingCount pending'
                                          : '$pendingCount tasks pending',
                                      style:
                                          subtitleStyle ??
                                          TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: overdueCount > 0
                                                ? Colors.red.withValues(
                                                    alpha: .85,
                                                  )
                                                : isTransparent
                                                ? Colors.white.withValues(
                                                    alpha: .8,
                                                  )
                                                : Colors.white,
                                          ),
                                    );
                                  },
                                ),
                      ],
                    ),
                  ),

                  // Actions section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Theme toggle
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            themeProvider.toggleTheme();
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              color: isTransparent
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                              size: 22,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      // Notification bell with smaller badge
                      if (showNotifications)
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            final overdueCount =
                                taskProvider.overdueTasks.length;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap:
                                    onNotificationTap ??
                                    () {
                                      HapticFeedback.lightImpact();
                                      _showNotificationsBottomSheet(
                                        context,
                                        taskProvider,
                                      );
                                    },
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Stack(
                                      children: [
                                        // Notification icon
                                        Positioned.fill(
                                          child: Icon(
                                            Icons.notifications_outlined,
                                            color: isTransparent
                                                ? Colors.white
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            size: 20,
                                          ),
                                        ),
                                        // Smaller badge
                                        if (overdueCount > 0)
                                          Positioned(
                                            right: -1,
                                            top: -1,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isTransparent
                                                      ? Colors.white
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  overdueCount > 99
                                                      ? '99+'
                                                      : overdueCount.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(width: 4),

                      // Custom actions
                      if (actions != null) ...actions!,

                      // Profile avatar
                      if (showProfile)
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  if (onProfileTap != null) {
                                    onProfileTap!();
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isTransparent
                                          ? Colors.white.withValues(alpha: .2)
                                          : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: .2),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: .05,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isTransparent
                                        ? Colors.white.withValues(alpha: .2)
                                        : Theme.of(context).colorScheme.primary
                                              .withValues(alpha: .1),
                                    child:
                                        authProvider.userProfile?.photoUrl !=
                                            null
                                        ? ClipOval(
                                            child: Image.network(
                                              authProvider
                                                  .userProfile!
                                                  .photoUrl!,
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Text(
                                                      authProvider
                                                              .userProfile
                                                              ?.initials ??
                                                          'U',
                                                      style: TextStyle(
                                                        color: isTransparent
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          )
                                        : Text(
                                            authProvider
                                                    .userProfile
                                                    ?.initials ??
                                                'U',
                                            style: TextStyle(
                                              color: isTransparent
                                                  ? Colors.white
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isTransparent
                ? Colors.white.withValues(alpha: .2)
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: isTransparent
                  ? Colors.white.withValues(alpha: .1)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .1),
              width: 1,
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          width: 36,
          height: 36,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: isTransparent
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationsBottomSheet(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: .6)
                  : Colors.black.withValues(alpha: .15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: .2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          taskProvider.overdueTasks.isEmpty
                              ? 'All up to date'
                              : '${taskProvider.overdueTasks.length} overdue tasks',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: .6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: .05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: .7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: .05),
                    colorScheme.onSurface.withValues(alpha: .1),
                    colorScheme.onSurface.withValues(alpha: .05),
                  ],
                ),
              ),
            ),

            // Notifications list
            Expanded(
              child: taskProvider.overdueTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withValues(alpha: .1),
                                  colorScheme.primary.withValues(alpha: .05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: .2,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 56,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'All caught up! 🎉',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You have no pending notifications.\nGreat job staying on top of things!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: .6,
                              ),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      itemCount: taskProvider.overdueTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = taskProvider.overdueTasks[index];
                        return _buildSwipeableTaskCard(
                          context,
                          task,
                          taskProvider,
                          theme,
                          colorScheme,
                          isDark,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableTaskCard(
    BuildContext context,
    dynamic task,
    TaskProvider taskProvider,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.withValues(alpha: .8), Colors.green],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt_rounded, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              'Complete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();

        // Show a quick confirmation with animation
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: .1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mark as Complete?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${task.title}"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: .7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: .6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Complete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        return result ?? false;
      },
      onDismissed: (direction) {
        HapticFeedback.lightImpact();
        taskProvider.toggleTaskCompletion(task);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.task_alt_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Task completed! 🎉',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );

        // Close notification sheet if no more overdue tasks
        if (taskProvider.overdueTasks.isEmpty) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.error.withValues(alpha: .2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: .2)
                  : colorScheme.shadow.withValues(alpha: .08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Show task details or navigate to task
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.error.withValues(alpha: .15),
                          colorScheme.error.withValues(alpha: .1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: .3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Overdue: ${task.dueDateFormatted}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Swipe hint
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swipe_left_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Swipe',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
