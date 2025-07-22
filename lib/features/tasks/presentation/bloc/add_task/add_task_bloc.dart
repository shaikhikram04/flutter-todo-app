import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_task_event.dart';
import 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskInitial()) {
    on<AddTaskButtonPressed>(_onAddTask);
  }

  Future<void> _onAddTask(
    AddTaskButtonPressed event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(AddTaskLoading());
    try {
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskFailure(e.toString()));
    }
  }
}
