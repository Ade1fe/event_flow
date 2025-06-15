// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/task.dart';
// import '../providers/category_provider.dart';
// import '../providers/task_provider.dart';
// import '../services/theme_service.dart';

// class TaskCard extends StatelessWidget {
//   final Task task;
//   final VoidCallback? onToggle;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onTap;

//   const TaskCard({
//     super.key,
//     required this.task,
//     this.onToggle,
//     this.onEdit,
//     this.onDelete,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Get providers without listening to avoid rebuild loops
//     final categoryProvider = Provider.of<CategoryProvider>(context);
//     final category = categoryProvider.getCategoryById(task.category);

//     // Don't listen to TaskProvider in build method
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: task.isOverdue && !task.isCompleted
//               ? Colors.red.withValues(alpha: .5)
//               : Colors.transparent,
//           width: task.isOverdue && !task.isCompleted ? 1 : 0,
//         ),
//       ),
//       child: InkWell(
//         onTap: onTap ?? onEdit,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Checkbox
//                   Transform.scale(
//                     scale: 1.2,
//                     child: Checkbox(
//                       value: task.isCompleted,
//                       onChanged: (bool? value) {
//                         // Use onToggle if provided, otherwise use taskProvider
//                         if (onToggle != null) {
//                           onToggle!();
//                         } else {
//                           // Use Future.microtask to avoid changing state during build
//                           Future.microtask(() async {
//                             await taskProvider.toggleTaskCompletion(task);
//                           });
//                         }
//                       },
//                       shape: CircleBorder(),
//                       activeColor: ThemeService.getPriorityColor(task.priority),
//                     ),
//                   ),
//                   SizedBox(width: 8),

//                   // Task content
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           task.title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             decoration: task.isCompleted
//                                 ? TextDecoration.lineThrough
//                                 : null,
//                             color: task.isCompleted ? Colors.grey : null,
//                           ),
//                         ),
//                         if (task.description.isNotEmpty) ...[
//                           SizedBox(height: 4),
//                           Text(
//                             task.description,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: task.isCompleted
//                                   ? Colors.grey
//                                   : Colors.grey.shade700,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                         SizedBox(height: 8),

//                         // Task metadata
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             // Due date
//                             if (task.dueDate != null)
//                               _buildChip(
//                                 context,
//                                 task.isOverdue && !task.isCompleted
//                                     ? Icons.warning
//                                     : Icons.event,
//                                 task.dueDateFormatted,
//                                 task.isOverdue && !task.isCompleted
//                                     ? Colors.red
//                                     : task.isDueToday
//                                     ? Colors.orange
//                                     : Colors.blue,
//                               ),

//                             // Priority
//                             _buildChip(
//                               context,
//                               Icons.flag,
//                               task.priority
//                                   .toString()
//                                   .split('.')
//                                   .last
//                                   .capitalize(),
//                               ThemeService.getPriorityColor(task.priority),
//                             ),

//                             // Category
//                             if (category != null)
//                               _buildChip(
//                                 context,
//                                 category.icon,
//                                 category.name,
//                                 category.color,
//                               ),

//                             // Recurring
//                             if (task.isRecurring)
//                               _buildChip(
//                                 context,
//                                 Icons.repeat,
//                                 'Recurring',
//                                 Colors.purple,
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Menu
//                   PopupMenuButton<String>(
//                     icon: Icon(Icons.more_vert),
//                     onSelected: (value) {
//                       if (value == 'edit') {
//                         onEdit?.call();
//                       } else if (value == 'delete') {
//                         _showDeleteConfirmation(context);
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'edit',
//                         child: Row(
//                           children: [
//                             Icon(Icons.edit, size: 20),
//                             SizedBox(width: 8),
//                             Text('Edit'),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'delete',
//                         child: Row(
//                           children: [
//                             Icon(Icons.delete, size: 20, color: Colors.red),
//                             SizedBox(width: 8),
//                             Text('Delete', style: TextStyle(color: Colors.red)),
//                           ],
//                         ),
//                       ),
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

//   Widget _buildChip(
//     BuildContext context,
//     IconData icon,
//     String label,
//     Color color,
//   ) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: .1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withValues(alpha: .3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete "${task.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               onDelete?.call();
//             },
//             child: Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/task.dart';
// import '../providers/category_provider.dart';
// import '../providers/task_provider.dart';
// import '../services/theme_service.dart';

// class TaskCard extends StatelessWidget {
//   final Task task;
//   final VoidCallback? onToggle;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onTap;

//   const TaskCard({
//     super.key,
//     required this.task,
//     this.onToggle,
//     this.onEdit,
//     this.onDelete,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = Provider.of<CategoryProvider>(
//       context,
//       listen: false,
//     );
//     final category = categoryProvider.getCategoryById(task.category);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     final bool isOverdue = task.isOverdue && !task.isCompleted;
//     final brightness = Theme.of(context).brightness;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           if (isOverdue)
//             BoxShadow(
//               color: Colors.red.withValues(alpha: .1), // subtle red tint
//               blurRadius: 2,
//               spreadRadius: 1,
//               offset: const Offset(0, 0),
//             ),
//         ],
//       ),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: isOverdue
//               ? BorderSide(
//                   color: brightness == Brightness.dark
//                       ? Colors.grey[800]!.withValues(alpha: .5)
//                       : Colors.grey[300]!.withValues(alpha: .5),
//                   width: 1,
//                 )
//               : BorderSide.none,
//         ),
//         child: InkWell(
//           onTap: onTap ?? onEdit,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: buildCardContent(context, category, taskProvider),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCardContent(
//     BuildContext context,
//     dynamic category,
//     TaskProvider taskProvider,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Checkbox
//             Transform.scale(
//               scale: 1.2,
//               child: Checkbox(
//                 value: task.isCompleted,
//                 onChanged: (bool? value) {
//                   if (onToggle != null) {
//                     onToggle!();
//                   } else {
//                     Future.microtask(() async {
//                       await taskProvider.toggleTaskCompletion(task);
//                     });
//                   }
//                 },
//                 shape: const CircleBorder(),
//                 activeColor: ThemeService.getPriorityColor(task.priority),
//               ),
//             ),
//             const SizedBox(width: 8),

//             // Task title and description
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     task.title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       decoration: task.isCompleted
//                           ? TextDecoration.lineThrough
//                           : null,
//                       color: task.isCompleted ? Colors.grey : null,
//                     ),
//                   ),
//                   if (task.description.isNotEmpty) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       task.description,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: task.isCompleted
//                             ? Colors.grey
//                             : Colors.grey.shade700,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                   const SizedBox(height: 8),

//                   // Metadata chips
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: [
//                       if (task.dueDate != null)
//                         _buildChip(
//                           context,
//                           task.isOverdue && !task.isCompleted
//                               ? Icons.warning
//                               : Icons.event,
//                           task.dueDateFormatted,
//                           task.isOverdue && !task.isCompleted
//                               ? Colors.red
//                               : task.isDueToday
//                               ? Colors.orange
//                               : Colors.blue,
//                         ),
//                       _buildChip(
//                         context,
//                         Icons.flag,
//                         task.priority.toString().split('.').last.capitalize(),
//                         ThemeService.getPriorityColor(task.priority),
//                       ),
//                       if (category != null)
//                         _buildChip(
//                           context,
//                           category.icon,
//                           category.name,
//                           category.color,
//                         ),
//                       if (task.isRecurring)
//                         _buildChip(
//                           context,
//                           Icons.repeat,
//                           'Recurring',
//                           Colors.purple,
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Popup Menu
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert),
//               onSelected: (value) {
//                 if (value == 'edit') {
//                   onEdit?.call();
//                 } else if (value == 'delete') {
//                   _showDeleteConfirmation(context);
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'edit',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.edit, size: 20),
//                       SizedBox(width: 8),
//                       Text('Edit'),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'delete',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.delete, size: 20, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('Delete', style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildChip(
//     BuildContext context,
//     IconData icon,
//     String label,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: .1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withValues(alpha: .3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Task'),
//         content: Text('Are you sure you want to delete "${task.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               onDelete?.call();
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Extension method to capitalize strings
// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/task.dart';
// import '../providers/category_provider.dart';
// import '../providers/task_provider.dart';
// import '../services/theme_service.dart';

// class TaskCard extends StatelessWidget {
//   final Task task;
//   final VoidCallback? onToggle;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onTap;

//   const TaskCard({
//     super.key,
//     required this.task,
//     this.onToggle,
//     this.onEdit,
//     this.onDelete,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = Provider.of<CategoryProvider>(
//       context,
//       listen: false,
//     );
//     final category = categoryProvider.getCategoryById(task.category);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     final bool isOverdue = task.isOverdue && !task.isCompleted;
//     final bool isCompleted = task.isCompleted;
//     final brightness = Theme.of(context).brightness;
//     final colorScheme = Theme.of(context).colorScheme;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           if (isOverdue)
//             BoxShadow(
//               color: colorScheme.error.withValues(alpha: .1),
//               blurRadius: 4,
//               spreadRadius: 1,
//               offset: const Offset(0, 2),
//             )
//           else if (isCompleted)
//             BoxShadow(
//               color: Colors.green.withValues(alpha: .08),
//               blurRadius: 4,
//               spreadRadius: 1,
//               offset: const Offset(0, 2),
//             )
//           else
//             BoxShadow(
//               color: colorScheme.shadow.withValues(alpha: .05),
//               blurRadius: 4,
//               spreadRadius: 0,
//               offset: const Offset(0, 2),
//             ),
//         ],
//       ),
//       child: Card(
//         elevation: 0,
//         // Removed the background color - keeping it default
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: isOverdue
//               ? BorderSide(
//                   color: colorScheme.error.withValues(alpha: .3),
//                   width: 1.5,
//                 )
//               : isCompleted
//               ? BorderSide(color: Colors.green.withValues(alpha: .3), width: 1.5)
//               : BorderSide(
//                   color: brightness == Brightness.dark
//                       ? colorScheme.outline.withValues(alpha: .2)
//                       : colorScheme.outline.withValues(alpha: .1),
//                   width: 1,
//                 ),
//         ),
//         child: InkWell(
//           onTap: onTap ?? onEdit,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: buildCardContent(context, category, taskProvider),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildCardContent(
//     BuildContext context,
//     dynamic category,
//     TaskProvider taskProvider,
//   ) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final brightness = Theme.of(context).brightness;
//     final isCompleted = task.isCompleted;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Professional Checkbox
//             Container(
//               decoration: BoxDecoration(shape: BoxShape.circle),
//               child: Transform.scale(
//                 scale: 1.3,
//                 child: Checkbox(
//                   value: task.isCompleted,
//                   onChanged: (bool? value) {
//                     if (onToggle != null) {
//                       onToggle!();
//                     } else {
//                       Future.microtask(() async {
//                         await taskProvider.toggleTaskCompletion(task);
//                       });
//                     }
//                   },
//                   shape: const CircleBorder(),
//                   activeColor: Colors.green,
//                   checkColor: Colors.white,
//                   side: BorderSide(
//                     color: isCompleted
//                         ? Colors.green
//                         : ThemeService.getPriorityColor(task.priority),
//                     width: 2,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),

//             // Task title and description
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           task.title,
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             decoration: task.isCompleted
//                                 ? TextDecoration.lineThrough
//                                 : null,
//                             decorationColor: Colors.green.withValues(alpha: .7),
//                             decorationThickness: 2,
//                             color: task.isCompleted
//                                 ? (brightness == Brightness.dark
//                                       ? colorScheme.onSurface.withValues(alpha: .6)
//                                       : colorScheme.onSurface.withValues(alpha: .5))
//                                 : colorScheme.onSurface,
//                           ),
//                         ),
//                       ),
//                       if (task.isCompleted)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.green.withValues(alpha: .1),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: Colors.green.withValues(alpha: .3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.check_circle_rounded,
//                                 size: 14,
//                                 color: Colors.green,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 'Completed',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                   if (task.description.isNotEmpty) ...[
//                     const SizedBox(height: 6),
//                     Text(
//                       task.description,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: task.isCompleted
//                             ? colorScheme.onSurface.withValues(alpha: .4)
//                             : colorScheme.onSurface.withValues(alpha: .7),
//                         height: 1.4,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                   const SizedBox(height: 12),

//                   // Professional Metadata chips
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: [
//                       if (task.dueDate != null)
//                         _buildProfessionalChip(
//                           context,
//                           task.isOverdue && !task.isCompleted
//                               ? Icons.warning_rounded
//                               : Icons.schedule_rounded,
//                           task.dueDateFormatted,
//                           task.isOverdue && !task.isCompleted
//                               ? colorScheme.error
//                               : task.isDueToday
//                               ? Colors.orange
//                               : Colors.blue,
//                           isCompleted: task.isCompleted,
//                         ),
//                       _buildProfessionalChip(
//                         context,
//                         Icons.flag_rounded,
//                         task.priority.toString().split('.').last.capitalize(),
//                         ThemeService.getPriorityColor(task.priority),
//                         isCompleted: task.isCompleted,
//                       ),
//                       if (category != null)
//                         _buildProfessionalChip(
//                           context,
//                           category.icon,
//                           category.name,
//                           category.color,
//                           isCompleted: task.isCompleted,
//                         ),
//                       if (task.isRecurring)
//                         _buildProfessionalChip(
//                           context,
//                           Icons.repeat_rounded,
//                           'Recurring',
//                           Colors.purple,
//                           isCompleted: task.isCompleted,
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Professional Popup Menu
//             Container(
//               decoration: BoxDecoration(
//                 color: colorScheme.surface,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: colorScheme.outline.withValues(alpha: .1)),
//               ),
//               child: PopupMenuButton<String>(
//                 icon: Icon(
//                   Icons.more_vert_rounded,
//                   color: colorScheme.onSurface.withValues(alpha: .7),
//                   size: 20,
//                 ),
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 onSelected: (value) {
//                   if (value == 'edit') {
//                     onEdit?.call();
//                   } else if (value == 'delete') {
//                     _showDeleteConfirmation(context);
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                     value: 'edit',
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.edit_rounded,
//                           size: 18,
//                           color: colorScheme.primary,
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Edit',
//                           style: TextStyle(
//                             color: colorScheme.onSurface,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   PopupMenuItem(
//                     value: 'delete',
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.delete_rounded,
//                           size: 18,
//                           color: colorScheme.error,
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Delete',
//                           style: TextStyle(
//                             color: colorScheme.error,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildProfessionalChip(
//     BuildContext context,
//     IconData icon,
//     String label,
//     Color color, {
//     bool isCompleted = false,
//   }) {
//     final brightness = Theme.of(context).brightness;
//     final chipColor = isCompleted
//         ? (brightness == Brightness.dark
//               ? color.withValues(alpha: .3)
//               : color.withValues(alpha: .4))
//         : color;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: chipColor.withValues(alpha: .1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: chipColor.withValues(alpha: .3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: chipColor.withValues(alpha: .05),
//             blurRadius: 2,
//             spreadRadius: 0,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: chipColor),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: chipColor,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: colorScheme.error.withValues(alpha: .1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.delete_rounded,
//                 color: colorScheme.error,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text('Delete Task'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
//           style: TextStyle(color: colorScheme.onSurface.withValues(alpha: .8)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               foregroundColor: colorScheme.onSurface.withValues(alpha: .6),
//             ),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               onDelete?.call();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: colorScheme.error,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Extension method to capitalize strings
// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/category_provider.dart';
import '../providers/task_provider.dart';
import '../services/theme_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onToggle,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final category = categoryProvider.getCategoryById(task.category);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final bool isOverdue = task.isOverdue && !task.isCompleted;
    final bool isCompleted = task.isCompleted;
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isOverdue)
            BoxShadow(
              color: colorScheme.error.withValues(alpha: .1),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          else if (isCompleted)
            BoxShadow(
              color: Colors.green.withValues(alpha: .08),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          else
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: .05),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Card(
        elevation: 0,
        // Removed the background color - keeping it default
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isOverdue
              ? BorderSide(
                  color: colorScheme.error.withValues(alpha: .3),
                  width: 1.5,
                )
              : isCompleted
              ? BorderSide(color: Colors.green.withValues(alpha: .3), width: 1.5)
              : BorderSide(
                  color: brightness == Brightness.dark
                      ? colorScheme.outline.withValues(alpha: .2)
                      : colorScheme.outline.withValues(alpha: .1),
                  width: 1,
                ),
        ),
        child: InkWell(
          onTap: onTap ?? onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: buildCardContent(context, category, taskProvider),
          ),
        ),
      ),
    );
  }

  Widget buildCardContent(
    BuildContext context,
    dynamic category,
    TaskProvider taskProvider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: unused_local_variable
    final brightness = Theme.of(context).brightness;
    final isCompleted = task.isCompleted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (_) {
                if (onToggle != null) {
                  onToggle!();
                } else {
                  taskProvider.toggleTaskCompletion(task);
                }
              },
              shape: const CircleBorder(),
              activeColor: Colors.green,
              side: BorderSide(
                color: isCompleted
                    ? Colors.green
                    : ThemeService.getPriorityColor(task.priority),
                width: 2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: isCompleted
                          ? colorScheme.onSurface.withValues(alpha: .5)
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: .7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (task.dueDate != null)
                        _buildMinimalChip(
                          context,
                          task.dueDateFormatted,
                          task.isOverdue && !task.isCompleted
                              ? colorScheme.error
                              : task.isDueToday
                              ? Colors.orange
                              : Colors.blue,
                        ),
                      _buildMinimalChip(
                        context,
                        task.priority.toString().split('.').last.capitalize(),
                        ThemeService.getPriorityColor(task.priority),
                      ),
                      if (category != null)
                        _buildMinimalChip(
                          context,
                          category.name,
                          category.color,
                        ),
                      if (task.isRecurring)
                        _buildMinimalChip(context, 'Recurring', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      const Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: colorScheme.error, size: 18),
                      const SizedBox(width: 8),
                      const Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildProfessionalChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    bool isCompleted = false,
  }) {
    final brightness = Theme.of(context).brightness;
    final chipColor = isCompleted
        ? (brightness == Brightness.dark
              ? color.withValues(alpha: .3)
              : color.withValues(alpha: .4))
        : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: .3), width: 1),
        boxShadow: [
          BoxShadow(
            color: chipColor.withValues(alpha: .05),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: chipColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // Minimal chip builder for chips without icons
  Widget _buildMinimalChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_rounded,
                color: colorScheme.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Delete Task'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: .8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withValues(alpha: .6),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Extension method to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
