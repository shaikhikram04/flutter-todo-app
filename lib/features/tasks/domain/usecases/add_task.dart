import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<int> call(Task task) async {
    return await repository.addTask(task);
  }
}
