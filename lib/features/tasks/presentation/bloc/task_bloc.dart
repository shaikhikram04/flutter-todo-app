import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/entities/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<SearchTaskEvent>(_onSearchTasks);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTask(event.id);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTask(updatedTask);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onSearchTasks(SearchTaskEvent event, Emitter<TaskState> emit) {
    final currentState = state;
    if (currentState is TaskLoaded) {
      final newState = currentState.copyWith(searchQuery: event.query);
      final filtered = _applyFiltersAndSearch(
        newState.allTasks,
        newState.searchQuery,
        newState.activeFilter,
      );
      emit(newState.copyWith(filteredTasks: filtered));
    }
  }

  void _onApplyFilters(ApplyFiltersEvent event, Emitter<TaskState> emit) {
    final currentState = state;
    if (currentState is TaskLoaded) {
      final newState = currentState.copyWith(activeFilter: event.filter);
      final filtered = _applyFiltersAndSearch(
        newState.allTasks,
        newState.searchQuery,
        newState.activeFilter,
      );
      emit(newState.copyWith(filteredTasks: filtered));
    }
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<TaskState> emit) {
    final currentState = state;
    if (currentState is TaskLoaded) {
      const emptyFilter = TaskFilter();
      final newState = currentState.copyWith(activeFilter: emptyFilter);
      final filtered = _applyFiltersAndSearch(
        newState.allTasks,
        newState.searchQuery,
        newState.activeFilter,
      );
      emit(newState.copyWith(filteredTasks: filtered));
    }
  }

  List<Task> _applyFiltersAndSearch(
      List<Task> tasks,
      String searchQuery,
      TaskFilter filter,
      ) {
    List<Task> filtered = List.from(tasks);

    // Apply search filter
    if (searchQuery.trim().isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            task.category.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply priority filter - Direct int comparison
    if (filter.priority != null) {
      filtered = filtered.where((task) {
        return task.priority == filter.priority;
      }).toList();
    }

    // Apply category filter
    if (filter.category != null) {
      filtered = filtered.where((task) {
        return task.category.toLowerCase() == filter.category?.toLowerCase();
      }).toList();
    }

    // Apply date filter
    if (filter.dateFilter != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      filtered = filtered.where((task) {
        final taskDate = DateTime(
          task.date.year,
          task.date.month,
          task.date.day,
        );

        switch (filter.dateFilter!) {
          case DateFilterType.today:
            return taskDate.isAtSameMomentAs(today);

          case DateFilterType.tomorrow:
            final tomorrow = today.add(const Duration(days: 1));
            return taskDate.isAtSameMomentAs(tomorrow);

          case DateFilterType.thisWeek:
            final weekStart = today.subtract(Duration(days: today.weekday - 1));
            final weekEnd = weekStart.add(const Duration(days: 6));
            return taskDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                taskDate.isBefore(weekEnd.add(const Duration(days: 1)));

          case DateFilterType.thisMonth:
            return taskDate.year == today.year && taskDate.month == today.month;

          case DateFilterType.overdue:
            return taskDate.isBefore(today) && !task.isCompleted;

          case DateFilterType.specific:
            if (filter.specificDate != null) {
              final specificDate = DateTime(
                filter.specificDate!.year,
                filter.specificDate!.month,
                filter.specificDate!.day,
              );
              return taskDate.isAtSameMomentAs(specificDate);
            }
            return false;
        }
      }).toList();
    }

    return filtered;
  }

}