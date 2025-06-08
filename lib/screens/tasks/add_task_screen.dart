// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:intl/intl.dart';
// // import '../../models/task.dart';
// // import '../../providers/auth_provider.dart';
// // import '../../providers/task_provider.dart';
// // import '../../providers/category_provider.dart';
// // import '../../widgets/custom_text_field.dart';
// // import '../../widgets/loading_overlay.dart';
// // import '../../services/theme_service.dart';

// // class AddTaskScreen extends StatefulWidget {
// //   final Task? task;

// //   const AddTaskScreen({super.key, this.task});

// //   @override
// //   _AddTaskScreenState createState() => _AddTaskScreenState();
// // }

// // class _AddTaskScreenState extends State<AddTaskScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _titleController = TextEditingController();
// //   final _descriptionController = TextEditingController();

// //   DateTime? _dueDate;
// //   TimeOfDay? _dueTime;
// //   TaskPriority _priority = TaskPriority.medium;
// //   String? _category;
// //   List<String> _tags = [];
// //   bool _isRecurring = false;
// //   RecurrenceType _recurrenceType = RecurrenceType.daily;
// //   int _recurrenceInterval = 1;

// //   @override
// //   void initState() {
// //     super.initState();

// //     if (widget.task != null) {
// //       _titleController.text = widget.task!.title;
// //       _descriptionController.text = widget.task!.description;
// //       _dueDate = widget.task!.dueDate;
// //       _priority = widget.task!.priority;
// //       _category = widget.task!.category;
// //       _tags = List.from(widget.task!.tags);
// //       _isRecurring = widget.task!.isRecurring;
// //       _recurrenceType = widget.task!.recurrenceType ?? RecurrenceType.daily;
// //       _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;

// //       if (widget.task!.dueDate != null) {
// //         _dueTime = TimeOfDay(
// //           hour: widget.task!.dueDate!.hour,
// //           minute: widget.task!.dueDate!.minute,
// //         );
// //       }
// //     }

// //     // Load categories
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //       final categoryProvider =
// //           Provider.of<CategoryProvider>(context, listen: false);

// //       if (authProvider.user != null) {
// //         categoryProvider.loadCategories(authProvider.user!.uid);
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _titleController.dispose();
// //     _descriptionController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _selectDueDate() async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _dueDate ?? DateTime.now(),
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );

// //     if (picked != null && picked != _dueDate) {
// //       setState(() {
// //         _dueDate = picked;
// //       });
// //     }
// //   }

// //   Future<void> _selectDueTime() async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: _dueTime ?? TimeOfDay.now(),
// //     );

// //     if (picked != null && picked != _dueTime) {
// //       setState(() {
// //         _dueTime = picked;
// //       });
// //     }
// //   }

// //   Future<void> _saveTask() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

// //     if (authProvider.user == null) return;

// //     // Combine date and time if both are set
// //     DateTime? combinedDateTime;
// //     if (_dueDate != null) {
// //       if (_dueTime != null) {
// //         combinedDateTime = DateTime(
// //           _dueDate!.year,
// //           _dueDate!.month,
// //           _dueDate!.day,
// //           _dueTime!.hour,
// //           _dueTime!.minute,
// //         );
// //       } else {
// //         combinedDateTime = _dueDate;
// //       }
// //     }

// //     if (widget.task == null) {
// //       // Create new task
// //       final newTask = Task(
// //         id: '',
// //         title: _titleController.text.trim(),
// //         description: _descriptionController.text.trim(),
// //         isCompleted: false,
// //         createdAt: DateTime.now(),
// //         userId: authProvider.user!.uid,
// //         dueDate: combinedDateTime,
// //         priority: _priority,
// //         category: _category,
// //         tags: _tags,
// //         isRecurring: _isRecurring,
// //         recurrenceType: _isRecurring ? _recurrenceType : null,
// //         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
// //       );

// //       final success = await taskProvider.addTask(newTask);

// //       if (success && mounted) {
// //         Navigator.pop(context);
// //       }
// //     } else {
// //       // Update existing task
// //       final updatedTask = widget.task!.copyWith(
// //         title: _titleController.text.trim(),
// //         description: _descriptionController.text.trim(),
// //         dueDate: combinedDateTime,
// //         priority: _priority,
// //         category: _category,
// //         tags: _tags,
// //         isRecurring: _isRecurring,
// //         recurrenceType: _isRecurring ? _recurrenceType : null,
// //         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
// //       );

// //       final success = await taskProvider.updateTask(updatedTask);

// //       if (success && mounted) {
// //         Navigator.pop(context);
// //       }
// //     }
// //   }

// //   Widget _buildPrioritySelector() {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: () => setState(() => _priority = TaskPriority.low),
// //             child: Container(
// //               padding: EdgeInsets.symmetric(vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: _priority == TaskPriority.low
// //                     ? ThemeService.lowPriorityColor.withValues(alpha: .2)
// //                     : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(
// //                   color: _priority == TaskPriority.low
// //                       ? ThemeService.lowPriorityColor
// //                       : Colors.grey.shade300,
// //                 ),
// //               ),
// //               child: Column(
// //                 children: [
// //                   Icon(
// //                     Icons.flag,
// //                     color: ThemeService.lowPriorityColor,
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     'Low',
// //                     style: TextStyle(
// //                       color: _priority == TaskPriority.low
// //                           ? ThemeService.lowPriorityColor
// //                           : null,
// //                       fontWeight: _priority == TaskPriority.low
// //                           ? FontWeight.bold
// //                           : null,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 8),
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: () => setState(() => _priority = TaskPriority.medium),
// //             child: Container(
// //               padding: EdgeInsets.symmetric(vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: _priority == TaskPriority.medium
// //                     ? ThemeService.mediumPriorityColor.withValues(alpha: .2)
// //                     : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(
// //                   color: _priority == TaskPriority.medium
// //                       ? ThemeService.mediumPriorityColor
// //                       : Colors.grey.shade300,
// //                 ),
// //               ),
// //               child: Column(
// //                 children: [
// //                   Icon(
// //                     Icons.flag,
// //                     color: ThemeService.mediumPriorityColor,
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     'Medium',
// //                     style: TextStyle(
// //                       color: _priority == TaskPriority.medium
// //                           ? ThemeService.mediumPriorityColor
// //                           : null,
// //                       fontWeight: _priority == TaskPriority.medium
// //                           ? FontWeight.bold
// //                           : null,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //         SizedBox(width: 8),
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: () => setState(() => _priority = TaskPriority.high),
// //             child: Container(
// //               padding: EdgeInsets.symmetric(vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: _priority == TaskPriority.high
// //                     ? ThemeService.highPriorityColor.withValues(alpha: .2)
// //                     : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(
// //                   color: _priority == TaskPriority.high
// //                       ? ThemeService.highPriorityColor
// //                       : Colors.grey.shade300,
// //                 ),
// //               ),
// //               child: Column(
// //                 children: [
// //                   Icon(
// //                     Icons.flag,
// //                     color: ThemeService.highPriorityColor,
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     'High',
// //                     style: TextStyle(
// //                       color: _priority == TaskPriority.high
// //                           ? ThemeService.highPriorityColor
// //                           : null,
// //                       fontWeight: _priority == TaskPriority.high
// //                           ? FontWeight.bold
// //                           : null,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final taskProvider = Provider.of<TaskProvider>(context);
// //     final categoryProvider = Provider.of<CategoryProvider>(context);
// //     final isEditing = widget.task != null;

// //     return LoadingOverlay(
// //       isLoading: taskProvider.isLoading,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(isEditing ? 'Edit Task' : 'Add Task'),
// //           actions: [
// //             TextButton(
// //               onPressed: taskProvider.isLoading ? null : _saveTask,
// //               child: Text('Save'),
// //             ),
// //           ],
// //         ),
// //         body: SingleChildScrollView(
// //           padding: EdgeInsets.all(16),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Title field
// //                 CustomTextField(
// //                   controller: _titleController,
// //                   labelText: 'Task Title',
// //                   hintText: 'Enter task title',
// //                   prefixIcon: Icons.title,
// //                   validator: (value) {
// //                     if (value == null || value.trim().isEmpty) {
// //                       return 'Please enter a task title';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16),

// //                 // Description field
// //                 CustomTextField(
// //                   controller: _descriptionController,
// //                   labelText: 'Description',
// //                   hintText: 'Enter task description (optional)',
// //                   prefixIcon: Icons.description,
// //                   maxLines: 4,
// //                 ),
// //                 SizedBox(height: 24),

// //                 // Due date and time
// //                 Text(
// //                   'Due Date & Time',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: InkWell(
// //                         onTap: _selectDueDate,
// //                         child: Container(
// //                           padding: EdgeInsets.all(12),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey.shade300),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.calendar_today),
// //                               SizedBox(width: 8),
// //                               Text(
// //                                 _dueDate != null
// //                                     ? DateFormat('MMM dd, yyyy')
// //                                         .format(_dueDate!)
// //                                     : 'Select Date',
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(width: 12),
// //                     Expanded(
// //                       child: InkWell(
// //                         onTap: _dueDate != null ? _selectDueTime : null,
// //                         child: Container(
// //                           padding: EdgeInsets.all(12),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(
// //                               color: _dueDate != null
// //                                   ? Colors.grey.shade300
// //                                   : Colors.grey.shade200,
// //                             ),
// //                             borderRadius: BorderRadius.circular(8),
// //                             color:
// //                                 _dueDate != null ? null : Colors.grey.shade100,
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 Icons.access_time,
// //                                 color: _dueDate != null ? null : Colors.grey,
// //                               ),
// //                               SizedBox(width: 8),
// //                               Text(
// //                                 _dueTime != null
// //                                     ? _dueTime!.format(context)
// //                                     : 'Select Time',
// //                                 style: TextStyle(
// //                                   color: _dueDate != null ? null : Colors.grey,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: 24),

// //                 // Priority
// //                 Text(
// //                   'Priority',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 _buildPrioritySelector(),
// //                 SizedBox(height: 24),

// //                 // Category
// //                 Text(
// //                   'Category',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 DropdownButtonFormField<String>(
// //                   value: _category,
// //                   decoration: InputDecoration(
// //                     prefixIcon: Icon(Icons.category),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     contentPadding:
// //                         EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// //                   ),
// //                   hint: Text('Select Category'),
// //                   items: [
// //                     DropdownMenuItem<String>(
// //                       value: null,
// //                       child: Text('None'),
// //                     ),
// //                     ...categoryProvider.categories.map((category) {
// //                       return DropdownMenuItem<String>(
// //                         value: category.id,
// //                         child: Row(
// //                           children: [
// //                             Icon(
// //                               category.icon,
// //                               color: category.color,
// //                               size: 20,
// //                             ),
// //                             SizedBox(width: 8),
// //                             Text(category.name),
// //                           ],
// //                         ),
// //                       );
// //                     }),
// //                   ],
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _category = value;
// //                     });
// //                   },
// //                 ),
// //                 SizedBox(height: 24),

// //                 // Recurring task
// //                 SwitchListTile(
// //                   title: Text(
// //                     'Recurring Task',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   subtitle: Text('Set up a repeating task'),
// //                   value: _isRecurring,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _isRecurring = value;
// //                     });
// //                   },
// //                   contentPadding: EdgeInsets.zero,
// //                 ),

// //                 if (_isRecurring) ...[
// //                   SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         flex: 2,
// //                         child: DropdownButtonFormField<RecurrenceType>(
// //                           value: _recurrenceType,
// //                           decoration: InputDecoration(
// //                             labelText: 'Repeat',
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                           items: RecurrenceType.values.map((type) {
// //                             return DropdownMenuItem<RecurrenceType>(
// //                               value: type,
// //                               child: Text(
// //                                   type.toString().split('.').last.capitalize()),
// //                             );
// //                           }).toList(),
// //                           onChanged: (value) {
// //                             if (value != null) {
// //                               setState(() {
// //                                 _recurrenceType = value;
// //                               });
// //                             }
// //                           },
// //                         ),
// //                       ),
// //                       SizedBox(width: 12),
// //                       Expanded(
// //                         flex: 1,
// //                         child: DropdownButtonFormField<int>(
// //                           value: _recurrenceInterval,
// //                           decoration: InputDecoration(
// //                             labelText: 'Every',
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                           items: List.generate(10, (index) => index + 1)
// //                               .map((value) {
// //                             return DropdownMenuItem<int>(
// //                               value: value,
// //                               child: Text(value.toString()),
// //                             );
// //                           }).toList(),
// //                           onChanged: (value) {
// //                             if (value != null) {
// //                               setState(() {
// //                                 _recurrenceInterval = value;
// //                               });
// //                             }
// //                           },
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],

// //                 SizedBox(height: 32),

// //                 // Save button
// //                 ElevatedButton(
// //                   onPressed: taskProvider.isLoading ? null : _saveTask,
// //                   style: ElevatedButton.styleFrom(
// //                     minimumSize: Size(double.infinity, 50),
// //                   ),
// //                   child: Text(isEditing ? 'Update Task' : 'Add Task'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // extension StringExtension on String {
// //   String capitalize() {
// //     return "${this[0].toUpperCase()}${substring(1)}";
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../models/task.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/task_provider.dart';
// import '../../providers/category_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/loading_overlay.dart';
// import '../../services/theme_service.dart';

// class AddTaskScreen extends StatefulWidget {
//   final Task? task;
//   final DateTime? initialDate;

//   const AddTaskScreen({super.key, this.task, this.initialDate});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   DateTime? _dueDate;
//   TimeOfDay? _dueTime;
//   TaskPriority _priority = TaskPriority.medium;
//   String? _category;
//   List<String> _tags = [];
//   bool _isRecurring = false;
//   RecurrenceType _recurrenceType = RecurrenceType.daily;
//   int _recurrenceInterval = 1;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//       _category = widget.task!.category;
//       _tags = List.from(widget.task!.tags);
//       _isRecurring = widget.task!.isRecurring;
//       _recurrenceType = widget.task!.recurrenceType ?? RecurrenceType.daily;
//       _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;

//       if (widget.task!.dueDate != null) {
//         _dueTime = TimeOfDay(
//           hour: widget.task!.dueDate!.hour,
//           minute: widget.task!.dueDate!.minute,
//         );
//       }
//     } else if (widget.initialDate != null) {
//       _dueDate = widget.initialDate;
//     }

//     // Load categories
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final categoryProvider = Provider.of<CategoryProvider>(
//         context,
//         listen: false,
//       );

//       if (authProvider.user != null) {
//         categoryProvider.loadCategories(authProvider.user!.uid);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDueDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dueDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null && picked != _dueDate) {
//       setState(() {
//         _dueDate = picked;
//       });
//     }
//   }

//   Future<void> _selectDueTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _dueTime ?? TimeOfDay.now(),
//     );

//     if (picked != null && picked != _dueTime) {
//       setState(() {
//         _dueTime = picked;
//       });
//     }
//   }

//   Future<void> _saveTask() async {
//     if (!_formKey.currentState!.validate()) return;

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     if (authProvider.user == null) return;

//     // Combine date and time if both are set
//     DateTime? combinedDateTime;
//     if (_dueDate != null) {
//       if (_dueTime != null) {
//         combinedDateTime = DateTime(
//           _dueDate!.year,
//           _dueDate!.month,
//           _dueDate!.day,
//           _dueTime!.hour,
//           _dueTime!.minute,
//         );
//       } else {
//         combinedDateTime = _dueDate;
//       }
//     }

//     if (widget.task == null) {
//       // Create new task
//       final newTask = Task(
//         id: '',
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         isCompleted: false,
//         createdAt: DateTime.now(),
//         userId: authProvider.user!.uid,
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.addTask(newTask);

//       if (success && mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task created successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } else {
//       // Update existing task
//       final updatedTask = widget.task!.copyWith(
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.updateTask(updatedTask);

//       if (success && mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildPrioritySelector() {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.low),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.low
//                     ? ThemeService.lowPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.low
//                       ? ThemeService.lowPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.lowPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'Low',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.low
//                           ? ThemeService.lowPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.low
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.medium),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.medium
//                     ? ThemeService.mediumPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.medium
//                       ? ThemeService.mediumPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.mediumPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'Medium',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.medium
//                           ? ThemeService.mediumPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.medium
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.high),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.high
//                     ? ThemeService.highPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.high
//                       ? ThemeService.highPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.highPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'High',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.high
//                           ? ThemeService.highPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.high
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final categoryProvider = Provider.of<CategoryProvider>(context);
//     final isEditing = widget.task != null;

//     return LoadingOverlay(
//       isLoading: taskProvider.isLoading,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(isEditing ? 'Edit Task' : 'Add Task'),
//           actions: [
//             TextButton(
//               onPressed: taskProvider.isLoading ? null : _saveTask,
//               child: Text('Save'),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title field
//                 CustomTextField(
//                   controller: _titleController,
//                   labelText: 'Task Title',
//                   hintText: 'Enter task title',
//                   prefixIcon: Icons.title,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter a task title';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 // Description field
//                 CustomTextField(
//                   controller: _descriptionController,
//                   labelText: 'Description',
//                   hintText: 'Enter task description (optional)',
//                   prefixIcon: Icons.description,
//                   maxLines: 4,
//                 ),
//                 SizedBox(height: 24),

//                 // Due date and time
//                 Text(
//                   'Due Date & Time',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: _selectDueDate,
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.calendar_today),
//                               SizedBox(width: 8),
//                               Text(
//                                 _dueDate != null
//                                     ? DateFormat(
//                                         'MMM dd, yyyy',
//                                       ).format(_dueDate!)
//                                     : 'Select Date',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: InkWell(
//                         onTap: _dueDate != null ? _selectDueTime : null,
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _dueDate != null
//                                   ? Colors.grey.shade300
//                                   : Colors.grey.shade200,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                             color: _dueDate != null
//                                 ? null
//                                 : Colors.grey.shade100,
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.access_time,
//                                 color: _dueDate != null ? null : Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 _dueTime != null
//                                     ? _dueTime!.format(context)
//                                     : 'Select Time',
//                                 style: TextStyle(
//                                   color: _dueDate != null ? null : Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),

//                 // Priority
//                 Text(
//                   'Priority',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 _buildPrioritySelector(),
//                 SizedBox(height: 24),

//                 // Category
//                 Text(
//                   'Category',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 DropdownButtonFormField<String>(
//                   value: _category,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.category),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 12,
//                     ),
//                   ),
//                   hint: Text('Select Category'),
//                   items: [
//                     DropdownMenuItem<String>(value: null, child: Text('None')),
//                     ...categoryProvider.categories.map((category) {
//                       return DropdownMenuItem<String>(
//                         value: category.id,
//                         child: Row(
//                           children: [
//                             Icon(
//                               category.icon,
//                               color: category.color,
//                               size: 20,
//                             ),
//                             SizedBox(width: 8),
//                             Text(category.name),
//                           ],
//                         ),
//                       );
//                     }),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _category = value;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 24),

//                 // Recurring task
//                 SwitchListTile(
//                   title: Text(
//                     'Recurring Task',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text('Set up a repeating task'),
//                   value: _isRecurring,
//                   onChanged: (value) {
//                     setState(() {
//                       _isRecurring = value;
//                     });
//                   },
//                   contentPadding: EdgeInsets.zero,
//                 ),

//                 if (_isRecurring) ...[
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: DropdownButtonFormField<RecurrenceType>(
//                           value: _recurrenceType,
//                           decoration: InputDecoration(
//                             labelText: 'Repeat',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           items: RecurrenceType.values.map((type) {
//                             return DropdownMenuItem<RecurrenceType>(
//                               value: type,
//                               child: Text(
//                                 type.toString().split('.').last.capitalize(),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 _recurrenceType = value;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         flex: 1,
//                         child: DropdownButtonFormField<int>(
//                           value: _recurrenceInterval,
//                           decoration: InputDecoration(
//                             labelText: 'Every',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           items: List.generate(10, (index) => index + 1).map((
//                             value,
//                           ) {
//                             return DropdownMenuItem<int>(
//                               value: value,
//                               child: Text(value.toString()),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 _recurrenceInterval = value;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],

//                 SizedBox(height: 32),

//                 // Save button
//                 ElevatedButton(
//                   onPressed: taskProvider.isLoading ? null : _saveTask,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                   ),
//                   child: Text(isEditing ? 'Update Task' : 'Add Task'),
//                 ),
//               ],
//             ),
//           ),
//         ),
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
// import '../../providers/auth_provider.dart';
// import '../../providers/task_provider.dart';
// import '../../widgets/stats_card.dart';
// import '../../widgets/quick_actions.dart';
// import '../../widgets/task_card.dart';
// import '../../widgets/professional_app_bar.dart';
// import '../../models/task.dart';
// import '../tasks/add_task_screen.dart';
// import '../tasks/task_list_screen.dart';

// class HomeTab extends StatefulWidget {
//   const HomeTab({Key? key}) : super(key: key);

//   @override
//   _HomeTabState createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Reload tasks when returning to this screen
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadTasks();
//     });
//   }

//   Future<void> _loadTasks() async {
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);
//     await taskProvider.fetchTasks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ProfessionalAppBar(
//         title: 'Dashboard',
//         isTransparent: false,
//         elevation: 0,
//         showShadow: false,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search_rounded, size: 22),
//             onPressed: () {
//               // Show search
//             },
//             tooltip: 'Search tasks',
//             splashRadius: 24,
//           ),
//         ],
//       ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           return RefreshIndicator(
//             onRefresh: () async {
//               await taskProvider.fetchTasks();
//             },
//             child: SingleChildScrollView(
//               physics: AlwaysScrollableScrollPhysics(),
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Welcome section
//                   Consumer<AuthProvider>(
//                     builder: (context, authProvider, child) {
//                       return Container(
//                         padding: EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Theme.of(context).colorScheme.primary.withValues(alpha: .1),
//                               Theme.of(context).colorScheme.secondary.withValues(alpha: .1),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Welcome back,',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   Text(
//                                     authProvider.userProfile?.displayName ?? 'User',
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Theme.of(context).colorScheme.primary,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Consumer<TaskProvider>(
//                                     builder: (context, taskProvider, child) {
//                                       final now = DateTime.now();
//                                       final greeting = now.hour < 12
//                                           ? 'Good morning!'
//                                           : now.hour < 17
//                                               ? 'Good afternoon!'
//                                               : 'Good evening!';

//                                       return Text(
//                                         greeting,
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey[600],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Icon(
//                               Icons.waving_hand,
//                               size: 40,
//                               color: Colors.amber,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 24),

//                   // Stats cards
//                   Consumer<TaskProvider>(
//                     builder: (context, taskProvider, child) {
//                       return Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: StatsCard(
//                                   title: 'Total Tasks',
//                                   value: taskProvider.totalTasks.toString(),
//                                   icon: Icons.task_alt,
//                                   color: Colors.blue,
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TaskListScreen(
//                                           filter: TaskFilter.all,
//                                           title: 'All Tasks',
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: StatsCard(
//                                   title: 'Completed',
//                                   value: taskProvider.completedTasks.toString(),
//                                   icon: Icons.check_circle,
//                                   color: Colors.green,
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TaskListScreen(
//                                           filter: TaskFilter.completed,
//                                           title: 'Completed Tasks',
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: StatsCard(
//                                   title: 'Pending',
//                                   value: taskProvider.pendingTasks.toString(),
//                                   icon: Icons.pending_actions,
//                                   color: Colors.orange,
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TaskListScreen(
//                                           filter: TaskFilter.pending,
//                                           title: 'Pending Tasks',
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 child: StatsCard(
//                                   title: 'Overdue',
//                                   value: taskProvider.overdueTasks.length.toString(),
//                                   icon: Icons.warning,
//                                   color: Colors.red,
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TaskListScreen(
//                                           filter: TaskFilter.overdue,
//                                           title: 'Overdue Tasks',
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   SizedBox(height: 32),

//                   // Quick actions
//                   QuickActions(),
//                   SizedBox(height: 32),

//                   // Recent tasks
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Recent Tasks',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => TaskListScreen(
//                                 filter: TaskFilter.all,
//                                 title: 'All Tasks',
//                               ),
//                             ),
//                           );
//                         },
//                         child: Text('View All'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),

//                   // Task list
//                   Consumer<TaskProvider>(
//                     builder: (context, taskProvider, child) {
//                       final recentTasks = taskProvider.tasks.take(5).toList();

//                       if (recentTasks.isEmpty) {
//                         return Container(
//                           padding: EdgeInsets.all(32),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: .3),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.task_alt,
//                                 size: 64,
//                                 color: Colors.grey[400],
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'No tasks yet',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Create your first task to get started!',
//                                 style: TextStyle(
//                                   color: Colors.grey[500],
//                                 ),
//                               ),
//                               SizedBox(height: 16),
//                               ElevatedButton.icon(
//                                 onPressed: () async {
//                                   final result = await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => AddTaskScreen()),
//                                   );
//                                   // Refresh tasks when returning from add task screen
//                                   if (result == true || result == null) {
//                                     _loadTasks();
//                                   }
//                                 },
//                                 icon: Icon(Icons.add),
//                                 label: Text('Add Task'),
//                                 style: ElevatedButton.styleFrom(
//                                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       return Column(
//                         children: recentTasks.map((task) {
//                           return TaskCard(
//                             task: task,
//                             onEdit: () async {
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AddTaskScreen(task: task),
//                                 ),
//                               );
//                               // Refresh tasks when returning from edit task screen
//                               if (result == true || result == null) {
//                                 _loadTasks();
//                               }
//                             },
//                             onDelete: () {
//                               Future.microtask(() async {
//                                 final success = await taskProvider.deleteTask(task.id);
//                                 if (success && context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Task deleted'),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                 }
//                               });
//                             },
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddTaskScreen()),
//           );
//           // Refresh tasks when returning from add task screen
//           if (result == true || result == null) {
//             _loadTasks();
//           }
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add new task',
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../../models/task.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/task_provider.dart';
// import '../../providers/category_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/loading_overlay.dart';
// import '../../services/theme_service.dart';
// import '../../widgets/professional_app_bar.dart';
// import '../categories/add_category_screen.dart';

// class AddTaskScreen extends StatefulWidget {
//   final Task? task;
//   final DateTime? initialDate;

//   const AddTaskScreen({super.key, this.task, this.initialDate});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   DateTime? _dueDate;
//   TimeOfDay? _dueTime;
//   TaskPriority _priority = TaskPriority.medium;
//   String? _category;
//   List<String> _tags = [];
//   bool _isRecurring = false;
//   RecurrenceType _recurrenceType = RecurrenceType.daily;
//   int _recurrenceInterval = 1;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//       _category = widget.task!.category;
//       _tags = List.from(widget.task!.tags);
//       _isRecurring = widget.task!.isRecurring;
//       _recurrenceType = widget.task!.recurrenceType ?? RecurrenceType.daily;
//       _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;

//       if (widget.task!.dueDate != null) {
//         _dueTime = TimeOfDay(
//           hour: widget.task!.dueDate!.hour,
//           minute: widget.task!.dueDate!.minute,
//         );
//       }
//     } else if (widget.initialDate != null) {
//       _dueDate = widget.initialDate;
//     }

//     // Load categories
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final categoryProvider = Provider.of<CategoryProvider>(
//         context,
//         listen: false,
//       );

//       if (authProvider.user != null) {
//         categoryProvider.loadCategories(authProvider.user!.uid);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDueDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dueDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null && picked != _dueDate) {
//       setState(() {
//         _dueDate = picked;
//       });
//     }
//   }

//   Future<void> _selectDueTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _dueTime ?? TimeOfDay.now(),
//     );

//     if (picked != null && picked != _dueTime) {
//       setState(() {
//         _dueTime = picked;
//       });
//     }
//   }

//   Future<void> _saveTask() async {
//     if (!_formKey.currentState!.validate()) return;

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     if (authProvider.user == null) return;

//     // Combine date and time if both are set
//     DateTime? combinedDateTime;
//     if (_dueDate != null) {
//       if (_dueTime != null) {
//         combinedDateTime = DateTime(
//           _dueDate!.year,
//           _dueDate!.month,
//           _dueDate!.day,
//           _dueTime!.hour,
//           _dueTime!.minute,
//         );
//       } else {
//         combinedDateTime = _dueDate;
//       }
//     }

//     if (widget.task == null) {
//       // Create new task
//       final newTask = Task(
//         id: '',
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         isCompleted: false,
//         createdAt: DateTime.now(),
//         userId: authProvider.user!.uid,
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.addTask(newTask);

//       if (success && mounted) {
//         Navigator.pop(context, true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task created successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } else {
//       // Update existing task
//       final updatedTask = widget.task!.copyWith(
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.updateTask(updatedTask);

//       if (success && mounted) {
//         Navigator.pop(context, true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Task updated successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildPrioritySelector() {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.low),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.low
//                     ? ThemeService.lowPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.low
//                       ? ThemeService.lowPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.lowPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'Low',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.low
//                           ? ThemeService.lowPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.low
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.medium),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.medium
//                     ? ThemeService.mediumPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.medium
//                       ? ThemeService.mediumPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.mediumPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'Medium',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.medium
//                           ? ThemeService.mediumPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.medium
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: GestureDetector(
//             onTap: () => setState(() => _priority = TaskPriority.high),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: _priority == TaskPriority.high
//                     ? ThemeService.highPriorityColor.withValues(alpha: .2)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                   color: _priority == TaskPriority.high
//                       ? ThemeService.highPriorityColor
//                       : Colors.grey.shade300,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(Icons.flag, color: ThemeService.highPriorityColor),
//                   SizedBox(height: 4),
//                   Text(
//                     'High',
//                     style: TextStyle(
//                       color: _priority == TaskPriority.high
//                           ? ThemeService.highPriorityColor
//                           : null,
//                       fontWeight: _priority == TaskPriority.high
//                           ? FontWeight.bold
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategorySelector() {
//     return Consumer<CategoryProvider>(
//       builder: (context, categoryProvider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Category',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton.icon(
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddCategoryScreen(),
//                       ),
//                     );
//                     if (result == true) {
//                       // Reload categories after adding a new one
//                       final authProvider = Provider.of<AuthProvider>(
//                         context,
//                         listen: false,
//                       );
//                       if (authProvider.user != null) {
//                         categoryProvider.loadCategories(authProvider.user!.uid);
//                       }
//                     }
//                   },
//                   icon: Icon(Icons.add, size: 18),
//                   label: Text('Add Category'),
//                   style: TextButton.styleFrom(
//                     foregroundColor: Theme.of(context).colorScheme.primary,
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),

//             if (categoryProvider.isLoading)
//               Container(
//                 height: 56,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                 ),
//               )
//             else if (categoryProvider.categories.isEmpty)
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade50,
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.category_outlined,
//                       size: 32,
//                       color: Colors.grey.shade400,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'No categories yet',
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Create your first category to organize tasks',
//                       style: TextStyle(
//                         color: Colors.grey.shade500,
//                         fontSize: 12,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   children: [
//                     // None option
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           _category = null;
//                         });
//                       },
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(8),
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _category == null
//                               ? Theme.of(
//                                   context,
//                                 ).colorScheme.primary.withValues(alpha: .1)
//                               : null,
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(8),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 24,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade300,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Icon(
//                                 Icons.clear,
//                                 size: 16,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 'No Category',
//                                 style: TextStyle(
//                                   fontWeight: _category == null
//                                       ? FontWeight.w600
//                                       : FontWeight.normal,
//                                   color: _category == null
//                                       ? Theme.of(context).colorScheme.primary
//                                       : null,
//                                 ),
//                               ),
//                             ),
//                             if (_category == null)
//                               Icon(
//                                 Icons.check_circle,
//                                 color: Theme.of(context).colorScheme.primary,
//                                 size: 20,
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Divider
//                     Divider(height: 1, thickness: 1),

//                     // Category options
//                     ...categoryProvider.categories.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final category = entry.value;
//                       final isSelected = _category == category.id;
//                       final isLast =
//                           index == categoryProvider.categories.length - 1;

//                       return InkWell(
//                         onTap: () {
//                           setState(() {
//                             _category = category.id;
//                           });
//                         },
//                         borderRadius: isLast
//                             ? BorderRadius.vertical(bottom: Radius.circular(8))
//                             : null,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? category.color.withValues(alpha: .1)
//                                 : null,
//                             borderRadius: isLast
//                                 ? BorderRadius.vertical(
//                                     bottom: Radius.circular(8),
//                                   )
//                                 : null,
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   color: category.color.withValues(alpha: .2),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Icon(
//                                   category.icon,
//                                   size: 16,
//                                   color: category.color,
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   category.name,
//                                   style: TextStyle(
//                                     fontWeight: isSelected
//                                         ? FontWeight.w600
//                                         : FontWeight.normal,
//                                     color: isSelected ? category.color : null,
//                                   ),
//                                 ),
//                               ),
//                               if (isSelected)
//                                 Icon(
//                                   Icons.check_circle,
//                                   color: category.color,
//                                   size: 20,
//                                 ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),

//             if (categoryProvider.error != null)
//               Padding(
//                 padding: EdgeInsets.only(top: 8),
//                 child: Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.error.withValues(alpha: .1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.error.withValues(alpha: .3),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         color: Theme.of(context).colorScheme.error,
//                         size: 20,
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           categoryProvider.error!,
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.error,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           categoryProvider.clearError();
//                           final authProvider = Provider.of<AuthProvider>(
//                             context,
//                             listen: false,
//                           );
//                           if (authProvider.user != null) {
//                             categoryProvider.loadCategories(
//                               authProvider.user!.uid,
//                             );
//                           }
//                         },
//                         child: Text('Retry'),
//                         style: TextButton.styleFrom(
//                           foregroundColor: Theme.of(context).colorScheme.error,
//                           padding: EdgeInsets.symmetric(horizontal: 8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final isEditing = widget.task != null;

//     return LoadingOverlay(
//       isLoading: taskProvider.isLoading,
//       child: Scaffold(
//         appBar: ProfessionalAppBar(
//           title: isEditing ? 'Edit Task' : 'New Task',
//           showNotifications: false,
//           showSubtitle: false,
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title field
//                 CustomTextField(
//                   controller: _titleController,
//                   labelText: 'Task Title',
//                   hintText: 'Enter task title',
//                   prefixIcon: Icons.title,
//                   validator: (value) {
//                     if (value == null || value.trim().isEmpty) {
//                       return 'Please enter a task title';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),

//                 // Description field
//                 CustomTextField(
//                   controller: _descriptionController,
//                   labelText: 'Description',
//                   hintText: 'Enter task description (optional)',
//                   prefixIcon: Icons.description,
//                   maxLines: 4,
//                 ),
//                 SizedBox(height: 24),

//                 // Due date and time
//                 Text(
//                   'Due Date & Time',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: _selectDueDate,
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(Icons.calendar_today),
//                               SizedBox(width: 8),
//                               Text(
//                                 _dueDate != null
//                                     ? DateFormat(
//                                         'MMM dd, yyyy',
//                                       ).format(_dueDate!)
//                                     : 'Select Date',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: InkWell(
//                         onTap: _dueDate != null ? _selectDueTime : null,
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _dueDate != null
//                                   ? Colors.grey.shade300
//                                   : Colors.grey.shade200,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                             color: _dueDate != null
//                                 ? null
//                                 : Colors.grey.shade100,
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.access_time,
//                                 color: _dueDate != null ? null : Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 _dueTime != null
//                                     ? _dueTime!.format(context)
//                                     : 'Select Time',
//                                 style: TextStyle(
//                                   color: _dueDate != null ? null : Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 24),

//                 // Priority
//                 Text(
//                   'Priority',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 _buildPrioritySelector(),
//                 SizedBox(height: 24),

//                 // Category - Enhanced section
//                 _buildCategorySelector(),
//                 SizedBox(height: 24),

//                 // Recurring task
//                 SwitchListTile(
//                   title: Text(
//                     'Recurring Task',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text('Set up a repeating task'),
//                   value: _isRecurring,
//                   onChanged: (value) {
//                     setState(() {
//                       _isRecurring = value;
//                     });
//                   },
//                   contentPadding: EdgeInsets.zero,
//                 ),

//                 if (_isRecurring) ...[
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: DropdownButtonFormField<RecurrenceType>(
//                           value: _recurrenceType,
//                           decoration: InputDecoration(
//                             labelText: 'Repeat',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           items: RecurrenceType.values.map((type) {
//                             return DropdownMenuItem<RecurrenceType>(
//                               value: type,
//                               child: Text(
//                                 type.toString().split('.').last.capitalize(),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 _recurrenceType = value;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         flex: 1,
//                         child: DropdownButtonFormField<int>(
//                           value: _recurrenceInterval,
//                           decoration: InputDecoration(
//                             labelText: 'Every',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           items: List.generate(10, (index) => index + 1).map((
//                             value,
//                           ) {
//                             return DropdownMenuItem<int>(
//                               value: value,
//                               child: Text(value.toString()),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 _recurrenceInterval = value;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],

//                 SizedBox(height: 32),

//                 // Save button
//                 ElevatedButton(
//                   onPressed: taskProvider.isLoading ? null : _saveTask,
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                   ),
//                   child: Text(isEditing ? 'Update Task' : 'Add Task'),
//                 ),
//               ],
//             ),
//           ),
//         ),
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
// import 'package:intl/intl.dart';
// import '../../models/task.dart';
// import '../../models/category.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/task_provider.dart';
// import '../../providers/category_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/loading_overlay.dart';
// import '../../services/theme_service.dart';
// import '../../widgets/professional_app_bar.dart';
// import '../categories/add_category_screen.dart';

// class AddTaskScreen extends StatefulWidget {
//   final Task? task;
//   final DateTime? initialDate;

//   const AddTaskScreen({super.key, this.task, this.initialDate});

//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   DateTime? _dueDate;
//   TimeOfDay? _dueTime;
//   TaskPriority _priority = TaskPriority.medium;
//   String? _category;
//   List<String> _tags = [];
//   bool _isRecurring = false;
//   RecurrenceType _recurrenceType = RecurrenceType.daily;
//   int _recurrenceInterval = 1;

//   @override
//   void initState() {
//     super.initState();

//     if (widget.task != null) {
//       _titleController.text = widget.task!.title;
//       _descriptionController.text = widget.task!.description;
//       _dueDate = widget.task!.dueDate;
//       _priority = widget.task!.priority;
//       _category = widget.task!.category;
//       _tags = List.from(widget.task!.tags);
//       _isRecurring = widget.task!.isRecurring;
//       _recurrenceType = widget.task!.recurrenceType ?? RecurrenceType.daily;
//       _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;

//       if (widget.task!.dueDate != null) {
//         _dueTime = TimeOfDay(
//           hour: widget.task!.dueDate!.hour,
//           minute: widget.task!.dueDate!.minute,
//         );
//       }
//     } else if (widget.initialDate != null) {
//       _dueDate = widget.initialDate;
//     }

//     // Load categories
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final categoryProvider = Provider.of<CategoryProvider>(
//         context,
//         listen: false,
//       );

//       if (authProvider.user != null) {
//         categoryProvider.loadCategories(authProvider.user!.uid);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDueDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _dueDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//               primary: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _dueDate) {
//       setState(() {
//         _dueDate = picked;
//       });
//     }
//   }

//   Future<void> _selectDueTime() async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _dueTime ?? TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//               primary: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _dueTime) {
//       setState(() {
//         _dueTime = picked;
//       });
//     }
//   }

//   Future<void> _saveTask() async {
//     if (!_formKey.currentState!.validate()) return;

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final taskProvider = Provider.of<TaskProvider>(context, listen: false);

//     if (authProvider.user == null) return;

//     // Combine date and time if both are set
//     DateTime? combinedDateTime;
//     if (_dueDate != null) {
//       if (_dueTime != null) {
//         combinedDateTime = DateTime(
//           _dueDate!.year,
//           _dueDate!.month,
//           _dueDate!.day,
//           _dueTime!.hour,
//           _dueTime!.minute,
//         );
//       } else {
//         combinedDateTime = _dueDate;
//       }
//     }

//     if (widget.task == null) {
//       // Create new task
//       final newTask = Task(
//         id: '',
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         isCompleted: false,
//         createdAt: DateTime.now(),
//         userId: authProvider.user!.uid,
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.addTask(newTask);

//       if (success && mounted) {
//         Navigator.pop(context, true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text('Task created successfully!'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       }
//     } else {
//       // Update existing task
//       final updatedTask = widget.task!.copyWith(
//         title: _titleController.text.trim(),
//         description: _descriptionController.text.trim(),
//         dueDate: combinedDateTime,
//         priority: _priority,
//         category: _category,
//         tags: _tags,
//         isRecurring: _isRecurring,
//         recurrenceType: _isRecurring ? _recurrenceType : null,
//         recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
//       );

//       final success = await taskProvider.updateTask(updatedTask);

//       if (success && mounted) {
//         Navigator.pop(context, true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text('Task updated successfully!'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildSectionCard({required Widget child}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .08),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//             spreadRadius: 0,
//           ),
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .04),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(16),
//       child: child,
//     );
//   }

//   Widget _buildPrioritySelector() {
//     return _buildSectionCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Priority Level',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               _buildPriorityButton(
//                 TaskPriority.low,
//                 'Low',
//                 ThemeService.lowPriorityColor,
//                 Icons.flag_outlined,
//               ),
//               SizedBox(width: 12),
//               _buildPriorityButton(
//                 TaskPriority.medium,
//                 'Medium',
//                 ThemeService.mediumPriorityColor,
//                 Icons.flag,
//               ),
//               SizedBox(width: 12),
//               _buildPriorityButton(
//                 TaskPriority.high,
//                 'High',
//                 ThemeService.highPriorityColor,
//                 Icons.outlined_flag,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPriorityButton(
//     TaskPriority priority,
//     String label,
//     Color color,
//     IconData icon,
//   ) {
//     final isSelected = _priority == priority;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => _priority = priority),
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           padding: EdgeInsets.symmetric(vertical: 16),
//           decoration: BoxDecoration(
//             color: isSelected ? color.withValues(alpha: .15) : Colors.grey.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected ? color : Colors.grey.shade300,
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: isSelected
//                 ? [
//                     BoxShadow(
//                       color: color.withValues(alpha: .2),
//                       blurRadius: 8,
//                       offset: Offset(0, 2),
//                     ),
//                   ]
//                 : null,
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected ? color : Colors.grey.shade600,
//                 size: 24,
//               ),
//               SizedBox(height: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isSelected ? color : Colors.grey.shade700,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateTimeSelector() {
//     return _buildSectionCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Due Date & Time',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDateTimeButton(
//                   icon: Icons.calendar_today_outlined,
//                   label: _dueDate != null
//                       ? DateFormat('MMM dd, yyyy').format(_dueDate!)
//                       : 'Select Date',
//                   onTap: _selectDueDate,
//                   isSelected: _dueDate != null,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateTimeButton(
//                   icon: Icons.access_time_outlined,
//                   label: _dueTime != null
//                       ? _dueTime!.format(context)
//                       : 'Select Time',
//                   onTap: _dueDate != null ? _selectDueTime : null,
//                   isSelected: _dueTime != null,
//                   isEnabled: _dueDate != null,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateTimeButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback? onTap,
//     required bool isSelected,
//     bool isEnabled = true,
//   }) {
//     return InkWell(
//       onTap: isEnabled ? onTap : null,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Theme.of(context).colorScheme.primary.withValues(alpha: .1)
//               : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? Theme.of(context).colorScheme.primary
//                 : Colors.grey.shade300,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isEnabled
//                   ? (isSelected
//                         ? Theme.of(context).colorScheme.primary
//                         : Colors.grey.shade600)
//                   : Colors.grey.shade400,
//               size: 20,
//             ),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   color: isEnabled
//                       ? (isSelected
//                             ? Theme.of(context).colorScheme.primary
//                             : Colors.grey.shade700)
//                       : Colors.grey.shade400,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategorySelector() {
//     return Consumer<CategoryProvider>(
//       builder: (context, categoryProvider, child) {
//         return _buildSectionCard(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Category',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed: () async {
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddCategoryScreen(),
//                         ),
//                       );
//                       if (result == true) {
//                         final authProvider = Provider.of<AuthProvider>(
//                           context,
//                           listen: false,
//                         );
//                         if (authProvider.user != null) {
//                           categoryProvider.loadCategories(
//                             authProvider.user!.uid,
//                           );
//                         }
//                       }
//                     },
//                     icon: Icon(Icons.add_circle_outline, size: 18),
//                     label: Text('Add New'),
//                     style: TextButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.primary,
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),

//               if (categoryProvider.isLoading)
//                 Container(
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Center(
//                     child: SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   ),
//                 )
//               else if (categoryProvider.categories.isEmpty)
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.category_outlined,
//                         size: 40,
//                         color: Colors.grey.shade400,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'No categories yet',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Create your first category to organize tasks',
//                         style: TextStyle(
//                           color: Colors.grey.shade500,
//                           fontSize: 13,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 )
//               else
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildCategoryItem(
//                         null,
//                         'No Category',
//                         Icons.clear,
//                         Colors.grey,
//                         _category == null,
//                       ),
//                       if (categoryProvider.categories.isNotEmpty)
//                         Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: Colors.grey.shade200,
//                         ),
//                       ...categoryProvider.categories.asMap().entries.map((
//                         entry,
//                       ) {
//                         final index = entry.key;
//                         final category = entry.value;
//                         final isSelected = _category == category.id;
//                         final isLast =
//                             index == categoryProvider.categories.length - 1;

//                         return Column(
//                           children: [
//                             _buildCategoryItem(
//                               category.id,
//                               category.name,
//                               category.icon,
//                               category.color,
//                               isSelected,
//                             ),
//                             if (!isLast)
//                               Divider(
//                                 height: 1,
//                                 thickness: 1,
//                                 color: Colors.grey.shade200,
//                               ),
//                           ],
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ),

//               if (categoryProvider.error != null)
//                 Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Theme.of(
//                         context,
//                       ).colorScheme.error.withValues(alpha: .1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Theme.of(
//                           context,
//                         ).colorScheme.error.withValues(alpha: .3),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.error_outline,
//                           color: Theme.of(context).colorScheme.error,
//                           size: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             categoryProvider.error!,
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.error,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             categoryProvider.clearError();
//                             final authProvider = Provider.of<AuthProvider>(
//                               context,
//                               listen: false,
//                             );
//                             if (authProvider.user != null) {
//                               categoryProvider.loadCategories(
//                                 authProvider.user!.uid,
//                               );
//                             }
//                           },
//                           child: Text('Retry'),
//                           style: TextButton.styleFrom(
//                             foregroundColor: Theme.of(
//                               context,
//                             ).colorScheme.error,
//                             padding: EdgeInsets.symmetric(horizontal: 8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryItem(
//     String? categoryId,
//     String title,
//     IconData icon,
//     Color color,
//     bool isSelected,
//   ) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _category = categoryId;
//         });
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected ? color.withValues(alpha: .1) : null,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: color.withValues(alpha: .2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, size: 18, color: color),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   color: isSelected
//                       ? color
//                       : Theme.of(context).colorScheme.onSurface,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//             if (isSelected) Icon(Icons.check_circle, color: color, size: 22),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecurringSection() {
//     return _buildSectionCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SwitchListTile(
//             title: Text(
//               'Recurring Task',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//             subtitle: Text(
//               'Set up a repeating task schedule',
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//             ),
//             value: _isRecurring,
//             onChanged: (value) {
//               setState(() {
//                 _isRecurring = value;
//               });
//             },
//             contentPadding: EdgeInsets.zero,
//             activeColor: Theme.of(context).colorScheme.primary,
//           ),

//           if (_isRecurring) ...[
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: DropdownButtonFormField<RecurrenceType>(
//                     value: _recurrenceType,
//                     decoration: InputDecoration(
//                       labelText: 'Repeat',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 16,
//                       ),
//                     ),
//                     items: RecurrenceType.values.map((type) {
//                       return DropdownMenuItem<RecurrenceType>(
//                         value: type,
//                         child: Text(
//                           type.toString().split('.').last.capitalize(),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _recurrenceType = value;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   flex: 1,
//                   child: DropdownButtonFormField<int>(
//                     value: _recurrenceInterval,
//                     decoration: InputDecoration(
//                       labelText: 'Every',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 16,
//                       ),
//                     ),
//                     items: List.generate(10, (index) => index + 1).map((value) {
//                       return DropdownMenuItem<int>(
//                         value: value,
//                         child: Text(value.toString()),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _recurrenceInterval = value;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = Provider.of<TaskProvider>(context);
//     final isEditing = widget.task != null;

//     return LoadingOverlay(
//       isLoading: taskProvider.isLoading,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade50,
//         appBar: ProfessionalAppBar(
//           title: isEditing ? 'Edit Task' : 'Create New Task',
//           showNotifications: false,
//           showSubtitle: false,
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: .08),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//                   child: CustomTextField(
//                     controller: _titleController,
//                     labelText: 'Task Title',
//                     hintText: 'Enter a descriptive task title',
//                     prefixIcon: Icons.title_outlined,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter a task title';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 // Description field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: .08),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                         spreadRadius: 0,
//                       ),
//                     ],
//                   ),
//                   child: CustomTextField(
//                     controller: _descriptionController,
//                     labelText: 'Description',
//                     hintText: 'Add more details about this task (optional)',
//                     prefixIcon: Icons.description_outlined,
//                     maxLines: 4,
//                   ),
//                 ),
//                 SizedBox(height: 24),

//                 // Due date and time
//                 _buildDateTimeSelector(),
//                 SizedBox(height: 24),

//                 // Priority
//                 _buildPrioritySelector(),
//                 SizedBox(height: 24),

//                 // Category
//                 _buildCategorySelector(),
//                 SizedBox(height: 24),

//                 // Recurring task
//                 _buildRecurringSection(),
//                 SizedBox(height: 32),

//                 // Save button
//                 Container(
//                   width: double.infinity,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Theme.of(
//                           context,
//                         ).colorScheme.primary.withValues(alpha: .3),
//                         blurRadius: 12,
//                         offset: Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: ElevatedButton(
//                     onPressed: taskProvider.isLoading ? null : _saveTask,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).colorScheme.primary,
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (taskProvider.isLoading)
//                           SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         else
//                           Icon(
//                             isEditing ? Icons.update : Icons.add_task,
//                             size: 22,
//                           ),
//                         SizedBox(width: 8),
//                         Text(
//                           isEditing ? 'Update Task' : 'Create Task',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../services/theme_service.dart';
import '../../widgets/professional_app_bar.dart';
import '../categories/add_category_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final DateTime? initialDate;

  const AddTaskScreen({super.key, this.task, this.initialDate});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  TaskPriority _priority = TaskPriority.medium;
  String? _category;
  List<String> _tags = [];
  bool _isRecurring = false;
  RecurrenceType _recurrenceType = RecurrenceType.daily;
  int _recurrenceInterval = 1;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _category = widget.task!.category;
      _tags = List.from(widget.task!.tags);
      _isRecurring = widget.task!.isRecurring;
      _recurrenceType = widget.task!.recurrenceType ?? RecurrenceType.daily;
      _recurrenceInterval = widget.task!.recurrenceInterval ?? 1;

      if (widget.task!.dueDate != null) {
        _dueTime = TimeOfDay(
          hour: widget.task!.dueDate!.hour,
          minute: widget.task!.dueDate!.minute,
        );
      }
    } else if (widget.initialDate != null) {
      _dueDate = widget.initialDate;
    }

    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        categoryProvider.loadCategories(authProvider.user!.uid);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectDueTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueTime) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (authProvider.user == null) return;

    // Combine date and time if both are set
    DateTime? combinedDateTime;
    if (_dueDate != null) {
      if (_dueTime != null) {
        combinedDateTime = DateTime(
          _dueDate!.year,
          _dueDate!.month,
          _dueDate!.day,
          _dueTime!.hour,
          _dueTime!.minute,
        );
      } else {
        combinedDateTime = _dueDate;
      }
    }

    if (widget.task == null) {
      // Create new task
      final newTask = Task(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: false,
        createdAt: DateTime.now(),
        userId: authProvider.user!.uid,
        dueDate: combinedDateTime,
        priority: _priority,
        category: _category,
        tags: _tags,
        isRecurring: _isRecurring,
        recurrenceType: _isRecurring ? _recurrenceType : null,
        recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
      );

      final success = await taskProvider.addTask(newTask);

      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Task created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } else {
      // Update existing task
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: combinedDateTime,
        priority: _priority,
        category: _category,
        tags: _tags,
        isRecurring: _isRecurring,
        recurrenceType: _isRecurring ? _recurrenceType : null,
        recurrenceInterval: _isRecurring ? _recurrenceInterval : null,
      );

      final success = await taskProvider.updateTask(updatedTask);

      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Task updated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSectionCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(color: Colors.grey.shade900, width: 0.5)
            : Border.all(color: Colors.grey.shade300, width: 0.5),
        boxShadow: [
          if (isDark) ...[
            // Inset shadow for dark mode
            BoxShadow(
              color: Colors.black.withValues(alpha: .4),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: .05),
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
            // Outer shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: .3),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ] else ...[
            // Light mode shadows
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 10,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ],
      ),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildPrioritySelector() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildPriorityButton(
                TaskPriority.low,
                'Low',
                ThemeService.lowPriorityColor,
                Icons.flag_outlined,
              ),
              SizedBox(width: 12),
              _buildPriorityButton(
                TaskPriority.medium,
                'Medium',
                ThemeService.mediumPriorityColor,
                Icons.flag,
              ),
              SizedBox(width: 12),
              _buildPriorityButton(
                TaskPriority.high,
                'High',
                ThemeService.highPriorityColor,
                Icons.outlined_flag,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(
    TaskPriority priority,
    String label,
    Color color,
    IconData icon,
  ) {
    final isSelected = _priority == priority;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = priority),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.2 : 0.15)
                : (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
            borderRadius: BorderRadius.circular(12),
            border: isDark
                ? null
                : Border.all(
                    color: isSelected ? color : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
            boxShadow: [
              if (isDark) ...[
                // Inset shadow for border effect
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: .3)
                      : Colors.black.withValues(alpha: .2),
                  blurRadius: isSelected ? 6 : 4,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.white.withValues(
                    alpha: isSelected ? 0.1 : 0.03,
                  ),
                  // blurRadius: 2,
                  // offset: Offset(0, -1),
                ),
              ],
              if (isSelected) ...[
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.01 : 0.2),
                  blurRadius: 1,
                  offset: Offset(2, 0),
                ),
              ],
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? color
                    : (isDark
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Colors.grey.shade600),
                size: 24,
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? color
                      : (isDark
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Colors.grey.shade700),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due Date & Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeButton(
                  icon: Icons.calendar_today_outlined,
                  label: _dueDate != null
                      ? DateFormat('MMM dd, yyyy').format(_dueDate!)
                      : 'Select Date',
                  onTap: _selectDueDate,
                  isSelected: _dueDate != null,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateTimeButton(
                  icon: Icons.access_time_outlined,
                  label: _dueTime != null
                      ? _dueTime!.format(context)
                      : 'Select Time',
                  onTap: _dueDate != null ? _selectDueTime : null,
                  isSelected: _dueTime != null,
                  isEnabled: _dueDate != null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required bool isSelected,
    bool isEnabled = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? null
              : Border.all(color: Colors.grey.shade200, width: 0.5),
          boxShadow: [
            if (isDark) ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: .4),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: .05),
                blurRadius: 4,
                offset: Offset(0, -1),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: .3),
                blurRadius: 12,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ] else ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ],
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: isEnabled
                  ? (isSelected
                        ? Theme.of(context).colorScheme.primary
                        : (isDark
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Colors.grey.shade600))
                  : (isDark
                        ? Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .38)
                        : Colors.grey.shade400),
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  // color: isEnabled
                  //     ? (isSelected
                  //           ? Theme.of(context).colorScheme.primary
                  //           : (isDark
                  //                 ? Theme.of(
                  //                     context,
                  //                   ).colorScheme.onSurfaceVariant
                  //                 : Colors.grey.shade700))
                  //     : (isDark
                  //           ? Theme.of(
                  //               context,
                  //             ).colorScheme.onSurface.withValues(alpha: .38)
                  //           : Colors.grey.shade400),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCategorySelector() {
  //   return Consumer<CategoryProvider>(
  //     builder: (context, categoryProvider, child) {
  //       final isDark = Theme.of(context).brightness == Brightness.dark;
  //       return _buildSectionCard(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Category',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Theme.of(context).colorScheme.onSurface,
  //                   ),
  //                 ),
  //                 TextButton.icon(
  //                   onPressed: () async {
  //                     final result = await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => AddCategoryScreen(),
  //                       ),
  //                     );
  //                     if (result == true) {
  //                       final authProvider = Provider.of<AuthProvider>(
  //                         context,
  //                         listen: false,
  //                       );
  //                       if (authProvider.user != null) {
  //                         categoryProvider.loadCategories(
  //                           authProvider.user!.uid,
  //                         );
  //                       }
  //                     }
  //                   },
  //                   icon: Icon(Icons.add_circle_outline, size: 18),
  //                   label: Text('Add New'),
  //                   style: TextButton.styleFrom(
  //                     foregroundColor: Theme.of(context).colorScheme.primary,
  //                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 12),

  //             if (categoryProvider.isLoading)
  //               Container(
  //                 height: 60,
  //                 decoration: BoxDecoration(
  //                   color: isDark
  //                       ? Theme.of(context).colorScheme.surfaceVariant
  //                       : Colors.grey.shade50,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: isDark
  //                       ? null
  //                       : Border.all(color: Colors.grey.shade300),
  //                   boxShadow: isDark
  //                       ? [
  //                           BoxShadow(
  //                             color: Colors.black.withValues(alpha: .2),
  //                             blurRadius: 4,
  //                             offset: Offset(0, 1),
  //                           ),
  //                           BoxShadow(
  //                             color: Colors.white.withValues(alpha: .03),
  //                             blurRadius: 2,
  //                             offset: Offset(0, -1),
  //                           ),
  //                         ]
  //                       : null,
  //                 ),
  //                 child: Center(
  //                   child: SizedBox(
  //                     height: 24,
  //                     width: 24,
  //                     child: CircularProgressIndicator(strokeWidth: 2),
  //                   ),
  //                 ),
  //               )
  //             else if (categoryProvider.categories.isEmpty)
  //               Container(
  //                 padding: EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: isDark
  //                       ? Theme.of(context).colorScheme.surfaceVariant
  //                       : Colors.grey.shade50,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: isDark
  //                       ? null
  //                       : Border.all(color: Colors.grey.shade300),
  //                   boxShadow: isDark
  //                       ? [
  //                           BoxShadow(
  //                             color: Colors.black.withValues(alpha: .2),
  //                             blurRadius: 4,
  //                             offset: Offset(0, 1),
  //                           ),
  //                           BoxShadow(
  //                             color: Colors.white.withValues(alpha: .03),
  //                             blurRadius: 2,
  //                             offset: Offset(0, -1),
  //                           ),
  //                         ]
  //                       : null,
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Icon(
  //                       Icons.category_outlined,
  //                       size: 40,
  //                       color: isDark
  //                           ? Theme.of(context).colorScheme.onSurfaceVariant
  //                           : Colors.grey.shade400,
  //                     ),
  //                     SizedBox(height: 12),
  //                     Text(
  //                       'No categories yet',
  //                       style: TextStyle(
  //                         color: isDark
  //                             ? Theme.of(context).colorScheme.onSurfaceVariant
  //                             : Colors.grey.shade600,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     SizedBox(height: 4),
  //                     Text(
  //                       'Create your first category to organize tasks',
  //                       style: TextStyle(
  //                         color: isDark
  //                             ? Theme.of(context).colorScheme.onSurfaceVariant
  //                                   .withValues(alpha: .7)
  //                             : Colors.grey.shade500,
  //                         fontSize: 13,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             else
  //               Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: isDark
  //                       ? null
  //                       : Border.all(color: Colors.grey.shade300),
  //                   boxShadow: isDark
  //                       ? [
  //                           BoxShadow(
  //                             color: Colors.black.withValues(alpha: .2),
  //                             blurRadius: 4,
  //                             offset: Offset(0, 1),
  //                           ),
  //                           BoxShadow(
  //                             color: Colors.white.withValues(alpha: .03),
  //                             blurRadius: 2,
  //                             offset: Offset(0, -1),
  //                           ),
  //                         ]
  //                       : null,
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     _buildCategoryItem(
  //                       null,
  //                       'No Category',
  //                       Icons.clear,
  //                       isDark
  //                           ? Theme.of(context).colorScheme.onSurfaceVariant
  //                           : Colors.grey,
  //                       _category == null,
  //                     ),
  //                     if (categoryProvider.categories.isNotEmpty)
  //                       Divider(
  //                         height: 1,
  //                         thickness: 1,
  //                         color: isDark
  //                             ? Theme.of(
  //                                 context,
  //                               ).colorScheme.outline.withValues(alpha: .5)
  //                             : Colors.grey.shade200,
  //                       ),
  //                     ...categoryProvider.categories.asMap().entries.map((
  //                       entry,
  //                     ) {
  //                       final index = entry.key;
  //                       final category = entry.value;
  //                       final isSelected = _category == category.id;
  //                       final isLast =
  //                           index == categoryProvider.categories.length - 1;

  //                       return Column(
  //                         children: [
  //                           _buildCategoryItem(
  //                             category.id,
  //                             category.name,
  //                             category.icon,
  //                             category.color,
  //                             isSelected,
  //                           ),
  //                           if (!isLast)
  //                             Divider(
  //                               height: 1,
  //                               thickness: 1,
  //                               color: isDark
  //                                   ? Theme.of(context).colorScheme.outline
  //                                         .withValues(alpha: .5)
  //                                   : Colors.grey.shade200,
  //                             ),
  //                         ],
  //                       );
  //                     }).toList(),
  //                   ],
  //                 ),
  //               ),

  //             if (categoryProvider.error != null)
  //               Padding(
  //                 padding: EdgeInsets.only(top: 12),
  //                 child: Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: Theme.of(
  //                       context,
  //                     ).colorScheme.error.withValues(alpha: .1),
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(
  //                       color: Theme.of(
  //                         context,
  //                       ).colorScheme.error.withValues(alpha: .3),
  //                     ),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Icon(
  //                         Icons.error_outline,
  //                         color: Theme.of(context).colorScheme.error,
  //                         size: 20,
  //                       ),
  //                       SizedBox(width: 8),
  //                       Expanded(
  //                         child: Text(
  //                           categoryProvider.error!,
  //                           style: TextStyle(
  //                             color: Theme.of(context).colorScheme.error,
  //                             fontSize: 12,
  //                           ),
  //                         ),
  //                       ),
  //                       TextButton(
  //                         onPressed: () {
  //                           categoryProvider.clearError();
  //                           final authProvider = Provider.of<AuthProvider>(
  //                             context,
  //                             listen: false,
  //                           );
  //                           if (authProvider.user != null) {
  //                             categoryProvider.loadCategories(
  //                               authProvider.user!.uid,
  //                             );
  //                           }
  //                         },
  //                         child: Text('Retry'),
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: Theme.of(
  //                             context,
  //                           ).colorScheme.error,
  //                           padding: EdgeInsets.symmetric(horizontal: 8),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildCategorySelector() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? Colors.grey[900] : Colors.grey.shade50;

        final borderColor = isDark
            ? Colors.grey.shade900
            : Colors.grey.shade300;

        final shadow = isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .2),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: .03),
                  blurRadius: 2,
                  offset: Offset(0, -1),
                ),
              ]
            : null;

        return _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCategoryScreen(),
                        ),
                      );
                      if (result == true) {
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        if (authProvider.user != null) {
                          categoryProvider.loadCategories(
                            authProvider.user!.uid,
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.add_circle_outline, size: 18),
                    label: Text('Add New'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark
                          ? Theme.of(
                              context,
                            ).colorScheme.onPrimary.withValues(alpha: .9)
                          : Theme.of(context).colorScheme.primary,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              /// Loading
              if (categoryProvider.isLoading)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: shadow,
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              /// Empty State
              else if (categoryProvider.categories.isEmpty)
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: shadow,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 40,
                        color: isDark
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Colors.grey.shade400,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No categories yet',
                        style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Create your first category to organize tasks',
                        style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                                    .withValues(alpha: .7)
                              : Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              /// Scrollable Category List
              else
                Container(
                  constraints: BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: shadow,
                  ),
                  child: Scrollbar(
                    thickness: 4,
                    radius: Radius.circular(6),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // _buildCategoryItem(
                          //   null,
                          //   'No Category',
                          //   Icons.clear,
                          //   isDark
                          //       ? Theme.of(context).colorScheme.onSurfaceVariant
                          //       : Colors.grey,
                          //   _category == null,
                          // ),
                          if (categoryProvider.categories.isNotEmpty)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: isDark
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.outline.withValues(alpha: .5)
                                  : Colors.grey.shade200,
                            ),
                          ...categoryProvider.categories.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final category = entry.value;
                            final isSelected = _category == category.id;
                            final isLast =
                                index == categoryProvider.categories.length - 1;

                            return Column(
                              children: [
                                _buildCategoryItem(
                                  category.id,
                                  category.name,
                                  category.icon,
                                  category.color,
                                  isSelected,
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: isDark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade200,
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

              /// Error
              if (categoryProvider.error != null)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: .3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            categoryProvider.error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            categoryProvider.clearError();
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            if (authProvider.user != null) {
                              categoryProvider.loadCategories(
                                authProvider.user!.uid,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
    String? categoryId,
    String title,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          _category = categoryId;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? color.withValues(alpha: .2)
                    : color.withValues(alpha: .1))
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.3 : 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text(
              'Recurring Task',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Set up a repeating task schedule',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            value: _isRecurring,
            onChanged: (value) {
              setState(() {
                _isRecurring = value;
              });
            },
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).colorScheme.primary,
          ),

          if (_isRecurring) ...[
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<RecurrenceType>(
                    value: _recurrenceType,
                    decoration: InputDecoration(
                      labelText: 'Repeat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    items: RecurrenceType.values.map((type) {
                      return DropdownMenuItem<RecurrenceType>(
                        value: type,
                        child: Text(
                          type.toString().split('.').last.capitalize(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _recurrenceType = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int>(
                    value: _recurrenceInterval,
                    decoration: InputDecoration(
                      labelText: 'Every',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    items: List.generate(10, (index) => index + 1).map((value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _recurrenceInterval = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final isEditing = widget.task != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LoadingOverlay(
      isLoading: taskProvider.isLoading,
      child: Scaffold(
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.surface
            : Colors.grey.shade50,
        appBar: ProfessionalAppBar(
          title: isEditing ? 'Edit Task' : 'Create New Task',
          showNotifications: false,
          showSubtitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: isDark
                        ? null
                        : Border.all(color: Colors.grey.shade200, width: 0.5),
                    boxShadow: [
                      if (isDark) ...[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: .05),
                          blurRadius: 4,
                          offset: Offset(0, -1),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ] else ...[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ],
                  ),
                  // child: CustomTextField(
                  //   controller: _titleController,
                  //   labelText: 'Task Title',
                  //   hintText: 'Enter a descriptive task title',
                  //   prefixIcon: Icons.title_outlined,
                  //   validator: (value) {
                  //     if (value == null || value.trim().isEmpty) {
                  //       return 'Please enter a task title';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  child: CustomTextField(
                    controller: _titleController,
                    labelText: 'Task Title',
                    hintText: 'Enter a descriptive task title',
                    prefixIcon: Icons.title_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Description field
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: isDark
                        ? null
                        : Border.all(color: Colors.grey.shade200, width: 0.5),
                    boxShadow: [
                      if (isDark) ...[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: .05),
                          blurRadius: 4,
                          offset: Offset(0, -1),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ] else ...[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ],
                  ),
                  child: CustomTextField(
                    controller: _descriptionController,
                    labelText: 'Description',
                    hintText: 'Add more details about this task (optional)',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 24),

                // Due date and time
                _buildDateTimeSelector(),
                SizedBox(height: 24),

                // Priority
                _buildPrioritySelector(),
                SizedBox(height: 24),

                // Category
                _buildCategorySelector(),
                SizedBox(height: 24),

                // Recurring task
                _buildRecurringSection(),
                SizedBox(height: 32),

                // Save button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(
                          alpha: isDark ? 0.4 : 0.3,
                        ),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: taskProvider.isLoading ? null : _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (taskProvider.isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 0.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        else
                          Icon(
                            isEditing ? Icons.update : Icons.add_task,
                            size: 22,
                          ),
                        SizedBox(width: 8),
                        Text(
                          isEditing ? 'Update Task' : 'Create Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
