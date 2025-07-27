import 'package:equatable/equatable.dart';
import 'package:up_todo/features/tasks/data/models/task_filter.dart';
import '../../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final String searchQuery;
  final TaskFilter activeFilter;

  const TaskLoaded(
      this.allTasks, {
        List<Task>? filtered,
        this.searchQuery = '',
        this.activeFilter = const TaskFilter(),
      }) : filteredTasks = filtered ?? allTasks;

  TaskLoaded copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    String? searchQuery,
    TaskFilter? activeFilter,
  }) {
    return TaskLoaded(
      allTasks ?? this.allTasks,
      filtered: filteredTasks ?? this.filteredTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object> get props => [allTasks, filteredTasks, searchQuery, activeFilter];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}