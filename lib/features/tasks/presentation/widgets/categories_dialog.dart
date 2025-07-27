import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/utils/colors.dart';

import '../../../../core/utils/constants.dart';
import '../bloc/categories/category_bloc.dart';
import '../bloc/categories/category_event.dart';
import '../bloc/categories/category_state.dart';

class CategoryDialog extends StatelessWidget {
  final String? selectedCategory;
  final Function(CategoryItem category) onCategorySelected;

  const CategoryDialog({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  static Future<String?> show(
    BuildContext context, {
    String? selectedCategory,
    required Function(CategoryItem category) onCategorySelected,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => CategoryDialog(
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          onCategorySelected(category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(LoadCategories());

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Choose Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Category Grid with BLoC
            BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: TodoColors.primary,
                    ),
                  );
                }

                if (state is CategoryLoaded) {
                  return GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                    children: state.categories.map((category) {
                      final isSelected = selectedCategory == category.name;
                      return _CategoryCard(
                        category: category,
                        isSelected: isSelected,
                        onTap: () => onCategorySelected(category),
                      );
                    }).toList(),
                  );
                }

                return const Center(
                  child: Text(
                    'No categories available',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Add Category Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showAddCategoryDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8875FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    IconData selectedIcon = Icons.category;
    Color selectedColor = const Color(0xFF8875FF);

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Add Custom Category',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Name Input
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter category name',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8875FF)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Icon Selection
              const Text(
                'Choose Icon:',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  Icons.category,
                  Icons.star,
                  Icons.bookmark,
                  Icons.lightbulb,
                  Icons.celebration,
                ]
                    .map((icon) => GestureDetector(
                          onTap: () => setState(() => selectedIcon = icon),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedIcon == icon ? selectedColor : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: Colors.white, size: 20),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Color Selection
              const Text(
                'Choose Color:',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  const Color(0xFF8875FF),
                  const Color(0xFF66BB6A),
                  const Color(0xFFEF5350),
                  const Color(0xFF42A5F5),
                  const Color(0xFFAB47BC),
                ]
                    .map((color) => GestureDetector(
                          onTap: () => setState(() => selectedColor = color),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final categoryName = controller.text.trim();
                if (categoryName.isNotEmpty) {
                  // Use the original context (from the CategoryDialog) to access the BLoC
                  context.read<CategoryBloc>().add(
                        AddCategory(
                          name: categoryName,
                          icon: selectedIcon,
                          color: selectedColor,
                        ),
                      );
                  Navigator.pop(dialogContext);
                } else {
                  // Show error for empty name
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Color(0xFF8875FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
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
