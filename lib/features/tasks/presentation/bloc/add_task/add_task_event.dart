
import 'package:up_todo/features/tasks/domain/entities/task.dart';

abstract class AddTaskEvent {}

class AddTaskButtonPressed extends AddTaskEvent {
  final Task task;
  AddTaskButtonPressed(this.task);
}
