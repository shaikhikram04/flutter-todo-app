import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

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

  const TaskLoaded(this.allTasks, {List<Task>? filtered})
      : filteredTasks = filtered ?? allTasks;

  @override
  List<Object> get props => [allTasks, filteredTasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}



