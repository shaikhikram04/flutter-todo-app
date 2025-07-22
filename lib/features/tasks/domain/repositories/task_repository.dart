import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<int> addTask(Task task);
  Future<int> updateTask(Task task);
  Future<int> deleteTask(int id);
}
