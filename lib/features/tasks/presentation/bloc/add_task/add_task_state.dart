import 'package:up_todo/core/utils/constants.dart';

abstract class AddTaskState {
  final DateTime? selectedDate;
  final CategoryItem? selectedCategory;
  final int? selectedPriority;

  const AddTaskState({this.selectedDate, this.selectedCategory, this.selectedPriority});
}

class AddTaskInitial extends AddTaskState {
  AddTaskInitial()
      : super(
          selectedDate: DateTime.now(),
          selectedCategory: CategoryConstants.categories.first,
          selectedPriority: 1,
        );
}

class AddTaskLoading extends AddTaskState {
  AddTaskLoading({super.selectedDate, super.selectedCategory, super.selectedPriority});
}

class AddTaskSuccess extends AddTaskState {}

class AddTaskFailure extends AddTaskState {
  final String error;
  AddTaskFailure(this.error);
}
