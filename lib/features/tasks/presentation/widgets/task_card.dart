import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:up_todo/core/utils/constants.dart';
import 'package:up_todo/features/tasks/domain/entities/task.dart';
import 'package:up_todo/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:up_todo/features/tasks/presentation/bloc/task_event.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getCategoryColor(String category) {
    final categoryColor =  CategoryConstants.getCategoryByName(category).color;
    return categoryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              context.read<TaskBloc>().add(ToggleTaskCompletion(task));
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: task.isCompleted ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
          ),
          const SizedBox(width: 12),
          // Task Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(task.date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Category and Priority
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(task.category),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.category,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flag, color: Colors.grey, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    task.priority.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Delete button
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
                        Navigator.pop(context);
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
