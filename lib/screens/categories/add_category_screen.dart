// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/professional_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';

class AddCategoryScreen extends StatefulWidget {
  final TaskCategory? category;

  const AddCategoryScreen({super.key, this.category});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.folder;
  bool _isEditing = false;

  // Predefined colors for selection
  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  // Predefined icons for selection
  final List<IconData> _icons = [
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.fitness_center,
    Icons.restaurant,
    Icons.local_hospital,
    Icons.directions_car,
    Icons.airplanemode_active,
    Icons.beach_access,
    Icons.book,
    Icons.music_note,
    Icons.movie,
    Icons.sports_basketball,
    Icons.attach_money,
    Icons.family_restroom,
    Icons.pets,
    Icons.folder,
    Icons.star,
    Icons.lightbulb,
    Icons.celebration,
    Icons.local_grocery_store,
    Icons.local_cafe,
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.category != null;

    if (_isEditing) {
      _nameController.text = widget.category!.name;
      _selectedColor = widget.category!.color;
      _selectedIcon = widget.category!.icon;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int _getColorIndex(Color color) {
    final predefinedColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
    ];

    for (int i = 0; i < predefinedColors.length; i++) {
      if (predefinedColors[i].value == color.value) {
        return i;
      }
    }
    return 0; // Default to blue if not found
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to create categories'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final name = _nameController.text.trim();

    // Check for duplicate name (case insensitive)
    bool duplicateExists = categoryProvider.categories.any(
      (cat) =>
          cat.name.toLowerCase() == name.toLowerCase() &&
          cat.id != (widget.category?.id ?? ''),
    );

    if (duplicateExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You already have a category with this name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool success;
    if (_isEditing) {
      final updatedCategory = widget.category!.copyWith(
        name: name,
        colorIndex: _getColorIndex(_selectedColor),
        icon: _selectedIcon,
      );
      success = await categoryProvider.updateCategory(updatedCategory);
    } else {
      final newCategory = TaskCategory(
        id: '',
        name: name,
        colorIndex: _getColorIndex(_selectedColor),
        userId: authProvider.user!.uid,
        createdAt: DateTime.now(),
        icon: _selectedIcon,
      );
      success = await categoryProvider.addCategory(newCategory);
    }

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Category updated!' : 'Category created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteCategory() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete this category? This action cannot be undone.',
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
        );
      },
    );

    if (confirmDelete == true) {
      await categoryProvider.deleteCategory(widget.category!.id);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category deleted!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LoadingOverlay(
      isLoading: categoryProvider.isLoading,
      child: Scaffold(
        appBar: ProfessionalAppBar(
          title: _isEditing ? 'Edit Category' : 'New Category',
          showNotifications: false,
          showSubtitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _selectedColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _selectedIcon,
                          size: 40,
                          color: _selectedColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _nameController.text.isEmpty
                            ? 'Category Preview'
                            : _nameController.text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap to customize',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Name field
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                  prefixIcon: Icons.label,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Color selection
                Text(
                  'Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                      final color = _colors[index];
                      final isSelected = _selectedColor.value == color.value;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 48,
                          height: 48,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: isSelected ? 8 : 0,
                                spreadRadius: isSelected ? 2 : 0,
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24),

                // Icon selection
                Text(
                  'Icon',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _icons.length,
                    itemBuilder: (context, index) {
                      final icon = _icons[index];
                      final isSelected =
                          _selectedIcon.codePoint == icon.codePoint;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = icon),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _selectedColor.withOpacity(0.2)
                                : isDark
                                ? Colors.grey.shade700
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? _selectedColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? _selectedColor
                                : isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 32),

                // Save button
                ElevatedButton(
                  onPressed: categoryProvider.isLoading ? null : _saveCategory,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _isEditing ? 'Update Category' : 'Create Category',
                  ),
                ),

                // Delete button (only if editing)
                if (_isEditing) ...[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: categoryProvider.isLoading
                        ? null
                        : _deleteCategory,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Delete Category'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
