import 'package:equatable/equatable.dart';

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
