import 'package:flutter/material.dart';

class CategoryDialog extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryDialog({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  static Future<String?> show(
    BuildContext context, {
    String? selectedCategory,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => CategoryDialog(
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          Navigator.of(context).pop(category);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            // Category Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: _categories.map((category) {
                final isSelected = selectedCategory == category.name;
                return _CategoryCard(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(category.name),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Add Category Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle add custom category
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Add Custom Category',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                onCategorySelected(controller.text.trim());
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xFF8875FF)),
            ),
          ),
        ],
      ),
    );
  }

  static final List<CategoryItem> _categories = [
    CategoryItem(
      name: 'Grocery',
      icon: Icons.shopping_cart,
      color: const Color(0xFF66BB6A), // Green
    ),
    CategoryItem(
      name: 'Work',
      icon: Icons.work,
      color: const Color(0xFFEF5350), // Red
    ),
    CategoryItem(
      name: 'Sport',
      icon: Icons.fitness_center,
      color: const Color(0xFF42A5F5), // Blue
    ),
    CategoryItem(
      name: 'Home',
      icon: Icons.home,
      color: const Color(0xFFE57373), // Light Red
    ),
    CategoryItem(
      name: 'University',
      icon: Icons.school,
      color: const Color(0xFF8875FF), // Purple
    ),
    CategoryItem(
      name: 'Social',
      icon: Icons.people,
      color: const Color(0xFFAB47BC), // Pink/Purple
    ),
    CategoryItem(
      name: 'Music',
      icon: Icons.music_note,
      color: const Color(0xFFBA68C8), // Light Purple
    ),
    CategoryItem(
      name: 'Health',
      icon: Icons.favorite,
      color: const Color(0xFF4CAF50), // Green
    ),
    CategoryItem(
      name: 'Movie',
      icon: Icons.movie,
      color: const Color(0xFF29B6F6), // Light Blue
    ),
  ];
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

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
