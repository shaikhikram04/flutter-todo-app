import '../../../../core/database/database_helper.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<int> addTask(TaskModel task);
  Future<int> updateTask(TaskModel task);
  Future<int> deleteTask(int id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;

  TaskLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<TaskModel>> getTasks() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableName,
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  @override
  Future<int> addTask(TaskModel task) async {
    final db = await databaseHelper.database;
    return await db.insert(DatabaseHelper.tableName, task.toMap());
  }

  @override
  Future<int> updateTask(TaskModel task) async {
    final db = await databaseHelper.database;
    return await db.update(
      DatabaseHelper.tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<int> deleteTask(int id) async {
    final db = await databaseHelper.database;
    return await db.delete(
      DatabaseHelper.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
