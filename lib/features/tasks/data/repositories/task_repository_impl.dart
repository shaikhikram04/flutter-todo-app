import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }

  @override
  Future<int> addTask(Task task) async {
    final taskModel = TaskModel(
      title: task.title,
      category: task.category,
      priority: task.priority,
      date: task.date,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );
    return await localDataSource.addTask(taskModel);
  }

  @override
  Future<int> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      category: task.category,
      priority: task.priority,
      date: task.date,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
    );
    return await localDataSource.updateTask(taskModel);
  }

  @override
  Future<int> deleteTask(int id) async {
    return await localDataSource.deleteTask(id);
  }
}
