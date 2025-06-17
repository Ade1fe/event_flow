import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
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
                ? color.withOpacity(isDark ? 0.2 : 0.15)
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
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: .3)
                      : Colors.black.withValues(alpha: .2),
                  blurRadius: isSelected ? 6 : 4,
                  offset: Offset(0, 1),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(isSelected ? 0.1 : 0.03),
                ),
              ],
              if (isSelected) ...[
                BoxShadow(
                  color: color.withOpacity(isDark ? 0.01 : 0.2),
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
  //       final surfaceColor = isDark ? Colors.grey[900] : Colors.grey.shade50;

  //       final borderColor = isDark
  //           ? Colors.grey.shade900
  //           : Colors.grey.shade300;

  //       final shadow = isDark
  //           ? [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha:.2),
  //                 blurRadius: 4,
  //                 offset: Offset(0, 1),
  //               ),
  //               BoxShadow(
  //                 color: Colors.white.withValues(alpha:.03),
  //                 blurRadius: 2,
  //                 offset: Offset(0, -1),
  //               ),
  //             ]
  //           : null;

  //       return _buildSectionCard(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             /// Header
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   'Categorysss',
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
  //                     foregroundColor: isDark
  //                         ? Theme.of(
  //                             context,
  //                           ).colorScheme.onPrimary.withValues(alpha:.9)
  //                         : Theme.of(context).colorScheme.primary,
  //                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 12),

  //             /// Loading
  //             if (categoryProvider.isLoading)
  //               Container(
  //                 height: 60,
  //                 decoration: BoxDecoration(
  //                   color: surfaceColor,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: borderColor),
  //                   boxShadow: shadow,
  //                 ),
  //                 child: Center(
  //                   child: SizedBox(
  //                     height: 24,
  //                     width: 24,
  //                     child: CircularProgressIndicator(strokeWidth: 2),
  //                   ),
  //                 ),
  //               )
  //             /// Empty State
  //             else if (categoryProvider.categories.isEmpty)
  //               Container(
  //                 padding: EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: surfaceColor,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: borderColor),
  //                   boxShadow: shadow,
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
  //                             ? Theme.of(
  //                                 context,
  //                               ).colorScheme.onSurfaceVariant.withValues(alpha:.7)
  //                             : Colors.grey.shade500,
  //                         fontSize: 13,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             /// Scrollable Category List
  //             else
  //               Container(
  //                 constraints: BoxConstraints(maxHeight: 250),
  //                 decoration: BoxDecoration(
  //                   color: surfaceColor,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: borderColor),
  //                   boxShadow: shadow,
  //                 ),
  //                 child: Scrollbar(
  //                   thickness: 4,
  //                   radius: Radius.circular(6),
  //                   child: ListView.separated(
  //                     itemCount: categoryProvider.categories.length,
  //                     separatorBuilder: (_, __) => Divider(
  //                       height: 1,
  //                       thickness: 1,
  //                       color: isDark
  //                           ? Colors.grey.shade900
  //                           : Colors.grey.shade200,
  //                     ),
  //                     itemBuilder: (context, index) {
  //                       final category = categoryProvider.categories[index];
  //                       final isSelected = _category == category.id;

  //                       return _buildCategoryItem(
  //                         category.id,
  //                         category.name,
  //                         category.icon,
  //                         category.color,
  //                         isSelected,
  //                         categoryProvider,
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ),

  //             /// Error
  //             if (categoryProvider.error != null)
  //               Padding(
  //                 padding: EdgeInsets.only(top: 12),
  //                 child: Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: Theme.of(
  //                       context,
  //                     ).colorScheme.error.withValues(alpha:.1),
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(
  //                       color: Theme.of(
  //                         context,
  //                       ).colorScheme.error.withValues(alpha:.3),
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
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: Theme.of(
  //                             context,
  //                           ).colorScheme.error,
  //                           padding: EdgeInsets.symmetric(horizontal: 8),
  //                         ),
  //                         child: Text('Retry'),
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

  // Widget _buildCategoryItem(
  //   String categoryId,
  //   String title,
  //   IconData icon,
  //   Color color,
  //   bool isSelected,
  //   CategoryProvider categoryProvider,
  // ) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _category = categoryId;
  //       });
  //     },
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? (isDark ? color.withValues(alpha:.2) : color.withValues(alpha:.1))
  //             : null,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           // Edit & Delete buttons on left side
  //           Container(
  //             margin: EdgeInsets.only(right: 8),
  //             child: Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(
  //                     Icons.edit,
  //                     color: Theme.of(context).colorScheme.primary,
  //                   ),
  //                   tooltip: 'Edit category',
  //                   onPressed: () async {
  //                     final result = await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => AddCategoryScreen(
  //                           category: categoryProvider.categories.firstWhere(
  //                             (c) => c.id == categoryId,
  //                           ),
  //                         ),
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
  //                 ),

  //                 IconButton(
  //                   icon: Icon(Icons.delete, color: Colors.redAccent),
  //                   tooltip: 'Delete category',
  //                   onPressed: () async {
  //                     final confirmed = await showDialog<bool>(
  //                       context: context,
  //                       builder: (context) => AlertDialog(
  //                         title: Text('Delete Category'),
  //                         content: Text(
  //                           'Are you sure you want to delete "$title"? This action cannot be undone.',
  //                         ),
  //                         actions: [
  //                           TextButton(
  //                             child: Text('Cancel'),
  //                             onPressed: () => Navigator.of(context).pop(false),
  //                           ),
  //                           TextButton(
  //                             child: Text('Delete'),
  //                             onPressed: () => Navigator.of(context).pop(true),
  //                           ),
  //                         ],
  //                       ),
  //                     );

  //                     if (confirmed == true) {
  //                       await categoryProvider.deleteCategory(categoryId);
  //                       final authProvider = Provider.of<AuthProvider>(
  //                         context,
  //                         listen: false,
  //                       );
  //                       if (authProvider.user != null) {
  //                         categoryProvider.loadCategories(
  //                           authProvider.user!.uid,
  //                         );
  //                       }
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text('Category deleted!'),
  //                           backgroundColor: Colors.red,
  //                         ),
  //                       );
  //                       if (_category == categoryId) {
  //                         setState(() {
  //                           _category = null;
  //                         });
  //                       }
  //                     }
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // Category icon
  //           Container(
  //             width: 32,
  //             height: 32,
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(isDark ? 0.3 : 0.2),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Icon(icon, size: 18, color: color),
  //           ),

  //           SizedBox(width: 12),

  //           // Category title
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: TextStyle(
  //                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  //                 color: isSelected
  //                     ? color
  //                     : Theme.of(context).colorScheme.onSurface,
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),

  //           // Currently selected indicator
  //           if (isSelected) Icon(Icons.check_circle, color: color, size: 22),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategorySelector() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? Colors.grey[850] : Colors.white;

        final borderColor = isDark
            ? Colors.grey.shade700
            : Colors.grey.shade300;

        return _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with Add New button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                    icon: Icon(Icons.add_circle_outline, size: 20),
                    label: Text('Add New'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              /// Loading
              if (categoryProvider.isLoading)
                SizedBox(
                  height: 70,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (categoryProvider.categories.isEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 48,
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No categories yet',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .7),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your first category to organize tasks',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .5),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Container(
                  constraints: BoxConstraints(maxHeight: 260),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      if (isDark)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Scrollbar(
                    thickness: 6,
                    radius: Radius.circular(8),
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: categoryProvider.categories.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 1,
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        indent: 64,
                      ),
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];
                        final isSelected = _category == category.id;

                        return _buildCategoryItem(
                          category.id,
                          category.name,
                          category.icon,
                          category.color,
                          isSelected,
                          categoryProvider,
                        );
                      },
                    ),
                  ),
                ),

              /// Error message with retry
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

  // Widget _buildCategoryItem(
  //   String categoryId,
  //   String title,
  //   IconData icon,
  //   Color color,
  //   bool isSelected,
  //   CategoryProvider categoryProvider,
  // ) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _category = categoryId;
  //       });
  //     },
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? (isDark ? color.withValues(alpha:.25) : color.withValues(alpha:.12))
  //             : null,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           // Category icon
  //           Container(
  //             width: 38,
  //             height: 38,
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(isDark ? 0.35 : 0.25),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Icon(icon, size: 20, color: color),
  //           ),

  //           SizedBox(width: 14),

  //           // Category title
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: TextStyle(
  //                 fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
  //                 color: isSelected
  //                     ? color
  //                     : Theme.of(context).colorScheme.onSurface,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),

  //           // Popup menu for Edit/Delete
  //           PopupMenuButton<String>(
  //             icon: Icon(
  //               Icons.more_vert,
  //               color: Theme.of(context).colorScheme.primary,
  //             ),
  //             onSelected: (value) async {
  //               if (value == 'edit') {
  //                 final result = await Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => AddCategoryScreen(
  //                       category: categoryProvider.categories.firstWhere(
  //                         (c) => c.id == categoryId,
  //                       ),
  //                     ),
  //                   ),
  //                 );

  //                 if (result == true) {
  //                   final authProvider = Provider.of<AuthProvider>(
  //                     context,
  //                     listen: false,
  //                   );
  //                   if (authProvider.user != null) {
  //                     categoryProvider.loadCategories(authProvider.user!.uid);
  //                   }
  //                 }
  //               } else if (value == 'delete') {
  //                 final confirmed = await showDialog<bool>(
  //                   context: context,
  //                   builder: (context) => AlertDialog(
  //                     title: Text('Delete Category'),
  //                     content: Text(
  //                       'Are you sure you want to delete "$title"? This action cannot be undone.',
  //                     ),
  //                     actions: [
  //                       TextButton(
  //                         child: Text('Cancel'),
  //                         onPressed: () => Navigator.of(context).pop(false),
  //                       ),
  //                       TextButton(
  //                         child: Text('Delete'),
  //                         onPressed: () => Navigator.of(context).pop(true),
  //                       ),
  //                     ],
  //                   ),
  //                 );

  //                 if (confirmed == true) {
  //                   await categoryProvider.deleteCategory(categoryId);
  //                   final authProvider = Provider.of<AuthProvider>(
  //                     context,
  //                     listen: false,
  //                   );
  //                   if (authProvider.user != null) {
  //                     categoryProvider.loadCategories(authProvider.user!.uid);
  //                   }
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text('Category deleted!'),
  //                       backgroundColor: Colors.red,
  //                     ),
  //                   );
  //                   if (_category == categoryId) {
  //                     setState(() {
  //                       _category = null;
  //                     });
  //                   }
  //                 }
  //               }
  //             },
  //             itemBuilder: (context) => [
  //               PopupMenuItem(
  //                 value: 'edit',
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.edit,
  //                       color: Theme.of(context).colorScheme.primary,
  //                       size: 18,
  //                     ),
  //                     SizedBox(width: 8),
  //                     Text('Edit'),
  //                   ],
  //                 ),
  //               ),
  //               PopupMenuItem(
  //                 value: 'delete',
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.delete, color: Colors.redAccent, size: 18),
  //                     SizedBox(width: 8),
  //                     Text('Delete'),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),

  //           if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCategoryItem(
    String categoryId,
    String title,
    IconData icon,
    Color color,
    bool isSelected,
    CategoryProvider categoryProvider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        setState(() {
          _category = categoryId;
        });
      },
      borderRadius: BorderRadius.circular(14),
      splashColor: color.withValues(alpha: .2),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? color.withValues(alpha: .2)
                    : color.withValues(alpha: .1))
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: .2),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
          ],
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: .5)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.35 : 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: color),
            ),

            SizedBox(width: 16),

            // Category title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 16,
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Edit/Delete menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                // color: Theme.of(context).colorScheme.primary,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCategoryScreen(
                        category: categoryProvider.categories.firstWhere(
                          (c) => c.id == categoryId,
                        ),
                      ),
                    ),
                  );

                  if (result == true) {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    if (authProvider.user != null) {
                      categoryProvider.loadCategories(authProvider.user!.uid);
                    }
                  }
                } else if (value == 'delete') {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Category'),
                      content: Text(
                        'Are you sure you want to delete "$title"? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await categoryProvider.deleteCategory(categoryId);
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    if (authProvider.user != null) {
                      categoryProvider.loadCategories(authProvider.user!.uid);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Category deleted!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    if (_category == categoryId) {
                      setState(() {
                        _category = null;
                      });
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.redAccent, size: 18),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),

            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle, color: color, size: 22),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCategoryItem(
  //   String categoryId,
  //   String title,
  //   IconData icon,
  //   Color color,
  //   bool isSelected,
  //   CategoryProvider categoryProvider,
  // ) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _category = categoryId;
  //       });
  //     },
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? (isDark ? color.withValues(alpha:.25) : color.withValues(alpha:.12))
  //             : null,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           // Edit & Delete buttons on left side
  //           Row(
  //             children: [
  //               IconButton(
  //                 icon: Icon(
  //                   Icons.edit,
  //                   color: Theme.of(context).colorScheme.primary,
  //                 ),
  //                 tooltip: 'Edit category',
  //                 splashRadius: 20,
  //                 onPressed: () async {
  //                   final result = await Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => AddCategoryScreen(
  //                         category: categoryProvider.categories.firstWhere(
  //                           (c) => c.id == categoryId,
  //                         ),
  //                       ),
  //                     ),
  //                   );

  //                   if (result == true) {
  //                     final authProvider = Provider.of<AuthProvider>(
  //                       context,
  //                       listen: false,
  //                     );
  //                     if (authProvider.user != null) {
  //                       categoryProvider.loadCategories(authProvider.user!.uid);
  //                     }
  //                   }
  //                 },
  //               ),
  //               IconButton(
  //                 icon: Icon(Icons.delete, color: Colors.redAccent),
  //                 tooltip: 'Delete category',
  //                 splashRadius: 20,
  //                 onPressed: () async {
  //                   final confirmed = await showDialog<bool>(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                       title: Text('Delete Category'),
  //                       content: Text(
  //                         'Are you sure you want to delete "$title"? This action cannot be undone.',
  //                       ),
  //                       actions: [
  //                         TextButton(
  //                           child: Text('Cancel'),
  //                           onPressed: () => Navigator.of(context).pop(false),
  //                         ),
  //                         TextButton(
  //                           child: Text('Delete'),
  //                           onPressed: () => Navigator.of(context).pop(true),
  //                         ),
  //                       ],
  //                     ),
  //                   );

  //                   if (confirmed == true) {
  //                     await categoryProvider.deleteCategory(categoryId);
  //                     final authProvider = Provider.of<AuthProvider>(
  //                       context,
  //                       listen: false,
  //                     );
  //                     if (authProvider.user != null) {
  //                       categoryProvider.loadCategories(authProvider.user!.uid);
  //                     }
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text('Category deleted!'),
  //                         backgroundColor: Colors.red,
  //                       ),
  //                     );
  //                     if (_category == categoryId) {
  //                       setState(() {
  //                         _category = null;
  //                       });
  //                     }
  //                   }
  //                 },
  //               ),
  //             ],
  //           ),

  //           SizedBox(width: 12),

  //           // Category icon
  //           Container(
  //             width: 38,
  //             height: 38,
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(isDark ? 0.35 : 0.25),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Icon(icon, size: 20, color: color),
  //           ),

  //           SizedBox(width: 14),

  //           // Category title
  //           Expanded(
  //             child: Text(
  //               title,
  //               style: TextStyle(
  //                 fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
  //                 color: isSelected
  //                     ? color
  //                     : Theme.of(context).colorScheme.onSurface,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),

  //           if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(isDark ? 0.4 : 0.3),
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
