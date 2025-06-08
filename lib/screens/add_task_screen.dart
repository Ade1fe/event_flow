// // // import 'package:flutter/material.dart';
// // // import '../models/task.dart';
// // // import '../services/auth_service.dart';
// // // import '../services/firestore_service.dart';

// // // class AddTaskScreen extends StatefulWidget {
// // //   final Task? task;

// // //   const AddTaskScreen({super.key, this.task});

// // //   @override
// // //   _AddTaskScreenState createState() => _AddTaskScreenState();
// // // }

// // // class _AddTaskScreenState extends State<AddTaskScreen> {
// // //   final AuthService _authService = AuthService();
// // //   final FirestoreService _firestoreService = FirestoreService();
// // //   final _formKey = GlobalKey<FormState>();
// // //   final _titleController = TextEditingController();
// // //   final _descriptionController = TextEditingController();
// // //   bool _isLoading = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     if (widget.task != null) {
// // //       _titleController.text = widget.task!.title;
// // //       _descriptionController.text = widget.task!.description;
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _titleController.dispose();
// // //     _descriptionController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _saveTask() async {
// // //     if (_formKey.currentState!.validate()) {
// // //       setState(() {
// // //         _isLoading = true;
// // //       });

// // //       try {
// // //         final user = _authService.currentUser;

// // //         if (user == null) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text('User not signed in'),
// // //               backgroundColor: Colors.red,
// // //             ),
// // //           );
// // //           setState(() {
// // //             _isLoading = false;
// // //           });
// // //           return;
// // //         }

// // //         if (widget.task == null) {
// // //           // Add new task
// // //           final newTask = Task(
// // //             id: '',
// // //             title: _titleController.text.trim(),
// // //             description: _descriptionController.text.trim(),
// // //             isCompleted: false,
// // //             createdAt: DateTime.now(),
// // //             userId: user.uid,
// // //           );
// // //           await _firestoreService.addTask(newTask);
// // //         } else {
// // //           // Update existing task
// // //           final updatedTask = widget.task!.copyWith(
// // //             title: _titleController.text.trim(),
// // //             description: _descriptionController.text.trim(),
// // //           );
// // //           await _firestoreService.updateTask(updatedTask);
// // //         }
// // //         Navigator.pop(context);
// // //       } catch (e) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text('Error saving task: ${e.toString()}'),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       } finally {
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isEditing = widget.task != null;

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(isEditing ? 'Edit Task' : 'Add Task'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: _isLoading ? null : _saveTask,
// // //             child: _isLoading
// // //                 ? SizedBox(
// // //                     width: 20,
// // //                     height: 20,
// // //                     child: CircularProgressIndicator(
// // //                       strokeWidth: 2,
// // //                       color: Colors.white,
// // //                     ),
// // //                   )
// // //                 : Text(
// // //                     'Save',
// // //                     style: TextStyle(color: Colors.white),
// // //                   ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Padding(
// // //         padding: EdgeInsets.all(16.0),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               TextFormField(
// // //                 controller: _titleController,
// // //                 decoration: InputDecoration(
// // //                   labelText: 'Task Title',
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(8),
// // //                   ),
// // //                 ),
// // //                 validator: (value) {
// // //                   if (value == null || value.trim().isEmpty) {
// // //                     return 'Please enter a task title';
// // //                   }
// // //                   return null;
// // //                 },
// // //               ),
// // //               SizedBox(height: 16),
// // //               TextFormField(
// // //                 controller: _descriptionController,
// // //                 decoration: InputDecoration(
// // //                   labelText: 'Description (Optional)',
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(8),
// // //                   ),
// // //                 ),
// // //                 maxLines: 4,
// // //               ),
// // //               SizedBox(height: 24),
// // //               ElevatedButton(
// // //                 onPressed: _isLoading ? null : _saveTask,
// // //                 child: _isLoading
// // //                     ? CircularProgressIndicator(color: Colors.white)
// // //                     : Text(isEditing ? 'Update Task' : 'Add Task'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
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
// // import '../../widgets/professional_app_bar.dart';

// // class AddTaskScreen extends StatefulWidget {
// //   final Task? task;
// //   final DateTime? initialDate;

// //   const AddTaskScreen({super.key, this.task, this.initialDate});

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
// //     } else if (widget.initialDate != null) {
// //       _dueDate = widget.initialDate;
// //     }

// //     // Load categories
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //       final categoryProvider = Provider.of<CategoryProvider>(
// //         context,
// //         listen: false,
// //       );

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
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Task created successfully!'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
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
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Task updated successfully!'),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
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
// //                     ? ThemeService.lowPriorityColor.withOpacity(0.2)
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
// //                   Icon(Icons.flag, color: ThemeService.lowPriorityColor),
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
// //                     ? ThemeService.mediumPriorityColor.withOpacity(0.2)
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
// //                   Icon(Icons.flag, color: ThemeService.mediumPriorityColor),
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
// //                     ? ThemeService.highPriorityColor.withOpacity(0.2)
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
// //                   Icon(Icons.flag, color: ThemeService.highPriorityColor),
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
// //         appBar: ProfessionalAppBar(
// //           title: isEditing ? 'Edit Task' : 'New Task',
// //           showNotifications: false,
// //           showSubtitle: false,
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
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
// //                                     ? DateFormat(
// //                                         'MMM dd, yyyy',
// //                                       ).format(_dueDate!)
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
// //                             color: _dueDate != null
// //                                 ? null
// //                                 : Colors.grey.shade100,
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
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //                 SizedBox(height: 8),
// //                 _buildPrioritySelector(),
// //                 SizedBox(height: 24),

// //                 // Category
// //                 Text(
// //                   'Category',
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //                 SizedBox(height: 8),
// //                 DropdownButtonFormField<String>(
// //                   value: _category,
// //                   decoration: InputDecoration(
// //                     prefixIcon: Icon(Icons.category),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     contentPadding: EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 12,
// //                     ),
// //                   ),
// //                   hint: Text('Select Category'),
// //                   items: [
// //                     DropdownMenuItem<String>(value: null, child: Text('None')),
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
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
// //                                 type.toString().split('.').last.capitalize(),
// //                               ),
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
// //                           items: List.generate(10, (index) => index + 1).map((
// //                             value,
// //                           ) {
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
// import '../../widgets/professional_app_bar.dart';

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
//         Navigator.pop(context, true); // Return true to indicate success
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
//         Navigator.pop(context, true); // Return true to indicate success
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
//                     ? ThemeService.lowPriorityColor.withOpacity(0.2)
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
//                     ? ThemeService.mediumPriorityColor.withOpacity(0.2)
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
//                     ? ThemeService.highPriorityColor.withOpacity(0.2)
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
