import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/features/tasks/data/models/task_filter.dart';
import 'package:up_todo/features/tasks/presentation/bloc/tasks/task_bloc.dart';
import 'package:up_todo/features/tasks/presentation/bloc/tasks/task_state.dart';
import 'package:up_todo/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:up_todo/features/tasks/presentation/widgets/no_task.dart';
import 'package:up_todo/features/tasks/presentation/widgets/task_card.dart';

import '../../../../core/utils/constants.dart';
import '../bloc/tasks/task_event.dart';
import '../widgets/filter_bottomsheet.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TodoColors.black,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('Tasks'),
        ),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                final hasActiveFilters = state.activeFilter.hasFilters;
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: hasActiveFilters ? Colors.blue : Colors.white,
                      ),
                      onPressed: () => _showFilterBottomSheet(context, state.activeFilter),
                    ),
                    if (hasActiveFilters)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              }
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterBottomSheet(context, const TaskFilter()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.allTasks.isEmpty) {
              return const NoTaskWidget();
            }
            return Column(
              children: [
                searchBar(context),
                if (state.activeFilter.hasFilters) _buildActiveFiltersRow(context, state),
                state.filteredTasks.isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = state.filteredTasks[index];
                      return TaskCard(task: task);
                    },
                  ),
                )
                    : Expanded(
                  child: notTaskFound(),
                ),
              ],
            );
          } else if (state is TaskError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: TodoColors.error),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TodoColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add, color: TodoColors.white),
      ),
    );
  }

  Widget _buildActiveFiltersRow(BuildContext context, TaskLoaded state) {
    final filter = state.activeFilter;
    List<Widget> filterChips = [];

    if (filter.priority != null) {
      String priorityLabel = 'Priority: ${filter.priority}';
      Color priorityColor = Colors.blue;

      // Set color based on priority level
      switch (filter.priority!) {
        case 1:
          priorityColor = Colors.red;
          priorityLabel = 'Priority: 1 (Highest)';
          break;
        case 2:
          priorityColor = Colors.orange;
          priorityLabel = 'Priority: 2 (High)';
          break;
        case 3:
          priorityColor = Colors.yellow;
          priorityLabel = 'Priority: 3 (Medium)';
          break;
        case 4:
          priorityColor = Colors.green;
          priorityLabel = 'Priority: 4 (Low)';
          break;
        case 5:
          priorityColor = Colors.blue;
          priorityLabel = 'Priority: 5 (Lowest)';
          break;
      }

      filterChips.add(_buildFilterChip(
        label: priorityLabel,
        color: priorityColor,
        onRemove: () {
          final newFilter = filter.copyWith(priority: null);
          context.read<TaskBloc>().add(ApplyFiltersEvent(newFilter));
        },
      ));
    }

    // Add category filter chip
    if (filter.category != null) {
      final categoryItem = CategoryConstants.getCategoryByName(filter.category!);
      filterChips.add(_buildFilterChip(
        label: filter.category!,
        color: categoryItem.color,
        onRemove: () {
          final newFilter = filter.copyWith(category: null);
          context.read<TaskBloc>().add(ApplyFiltersEvent(newFilter));
        },
      ));
    }

    if (filter.dateFilter != null) {
      String dateLabel = '';
      switch (filter.dateFilter!) {
        case DateFilterType.today:
          dateLabel = 'Today';
          break;
        case DateFilterType.tomorrow:
          dateLabel = 'Tomorrow';
          break;
        case DateFilterType.thisWeek:
          dateLabel = 'This Week';
          break;
        case DateFilterType.thisMonth:
          dateLabel = 'This Month';
          break;
        case DateFilterType.overdue:
          dateLabel = 'Overdue';
          break;
        case DateFilterType.specific:
          if (filter.specificDate != null) {
            dateLabel = '${filter.specificDate!.day}/${filter.specificDate!.month}/${filter.specificDate!.year}';
          }
          break;
      }

      filterChips.add(_buildFilterChip(
        label: dateLabel,
        onRemove: () {
          final newFilter = filter.copyWith(dateFilter: null, specificDate: null);
          context.read<TaskBloc>().add(ApplyFiltersEvent(newFilter));
        },
      ));
    }

    if (filterChips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: filterChips,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(ClearFiltersEvent());
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFilterChip({
  required String label,
  required VoidCallback onRemove,
  Color? color,
}) {
  final chipColor = color ?? Colors.blue;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: chipColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: chipColor.withOpacity(0.5)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: chipColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRemove,
          child: Icon(
            Icons.close,
            color: chipColor,
            size: 16,
          ),
        ),
      ],
    ),
  );
}

  void _showFilterBottomSheet(BuildContext context, TaskFilter currentFilter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(currentFilter: currentFilter),
    );
  }

  Center notTaskFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: TextField(
          onChanged: (value) {
            context.read<TaskBloc>().add(SearchTaskEvent(value));
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search for your task...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}
