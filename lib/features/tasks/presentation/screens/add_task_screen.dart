import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/utils/constants.dart';
import 'package:up_todo/features/tasks/presentation/bloc/add_task/add_task_bloc.dart';
import 'package:up_todo/features/tasks/presentation/bloc/add_task/add_task_event.dart';
import 'package:up_todo/features/tasks/presentation/bloc/add_task/add_task_state.dart';

import '../../domain/entities/task.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskBloc, AddTaskState>(
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          Navigator.pop(context);
        } else if (state is AddTaskFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        // You can get the current values from the bloc state
        final selectedDate = state.selectedDate ?? DateTime.now();
        final selectedCategory = state.selectedCategory ?? CategoryConstants.categories.first;
        final selectedPriority = state.selectedPriority ?? 1;

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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isNotEmpty) {
                        final task = Task(
                          title: _titleController.text.trim(),
                          category: selectedCategory.name,
                          priority: selectedPriority,
                          date: selectedDate,
                          isCompleted: false,
                          createdAt: DateTime.now(),
                        );
                        context.read<AddTaskBloc>().add(AddTaskButtonPressed(task));
                      } else {
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
      },
    );
  }
}
