import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String category;
  final int priority;
  final DateTime date;
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.date,
    required this.isCompleted,
    required this.createdAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? category,
    int? priority,
    DateTime? date,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, category, priority, date, isCompleted, createdAt];
}
