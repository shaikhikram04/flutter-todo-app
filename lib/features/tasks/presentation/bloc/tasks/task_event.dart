import 'package:equatable/equatable.dart';
import 'package:up_todo/features/tasks/data/models/task_filter.dart';

import '../../../domain/entities/task.dart';

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
