import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:up_todo/core/utils/constants.dart';
import 'package:up_todo/features/tasks/presentation/widgets/categories_dialog.dart';

import '../../domain/entities/task.dart';
import '../bloc/tasks/task_bloc.dart';
import '../bloc/tasks/task_event.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  CategoryItem _selectedCategory = CategoryConstants.categories.first;
  int _selectedPriority = 1;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Title',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter Task Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),

            // Task Date
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Task Date :',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Task Category
            Row(
              children: [
                const Icon(Icons.local_offer, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Task Category :',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _showCategoryPicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedCategory.color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _selectedCategory.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Task Priority
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Task Priority :',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedPriority < 5) {
                        _selectedPriority++;
                      } else {
                        _selectedPriority = 1;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flag, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _selectedPriority.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.trim().isNotEmpty) {
                    final task = Task(
                      title: _titleController.text.trim(),
                      category: _selectedCategory.name,
                      priority: _selectedPriority,
                      date: _selectedDate,
                      isCompleted: false,
                      createdAt: DateTime.now(),
                    );

                    context.read<TaskBloc>().add(AddTaskEvent(task));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a task title'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8875FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Task',
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

  void _showCategoryPicker() {
    CategoryDialog.show(context, onCategorySelected: (CategoryItem category) {
      setState(() {
        _selectedCategory = category;
      });
    });
  }
}
