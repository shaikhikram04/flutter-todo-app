import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final int id;

  const DeleteTaskEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleTaskCompletion extends TaskEvent {
  final Task task;

  const ToggleTaskCompletion(this.task);

  @override
  List<Object> get props => [task];
}

class SearchTaskEvent extends TaskEvent {
  final String query;

  const SearchTaskEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ApplyFiltersEvent extends TaskEvent {
  final TaskFilter filter;

  const ApplyFiltersEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class ClearFiltersEvent extends TaskEvent {}

// Filter model
class TaskFilter extends Equatable {
  final int? priority; // 1-5 (1=highest, 5=lowest)
  final String? category; // Add this field
  final DateFilterType? dateFilter;
  final DateTime? specificDate;

  const TaskFilter({
    this.priority,
    this.category, // Add this parameter
    this.dateFilter,
    this.specificDate,
  });

  TaskFilter copyWith({
    int? priority,
    String? category, // Add this parameter
    DateFilterType? dateFilter,
    DateTime? specificDate,
  }) {
    return TaskFilter(
      priority: priority ?? this.priority,
      category: category ?? this.category, // Add this line
      dateFilter: dateFilter ?? this.dateFilter,
      specificDate: specificDate ?? this.specificDate,
    );
  }

  bool get hasFilters =>
      priority != null ||
          category != null || // Add this condition
          dateFilter != null ||
          specificDate != null;

  @override
  List<Object?> get props => [priority, category, dateFilter, specificDate]; // Add category
}

enum DateFilterType {
  today,
  tomorrow,
  thisWeek,
  thisMonth,
  overdue,
  specific,
}