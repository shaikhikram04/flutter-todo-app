import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    super.id,
    required super.title,
    required super.category,
    required super.priority,
    required super.date,
    required super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      priority: map['priority'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }


}
