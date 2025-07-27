import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/core/database/database_helper.dart';
import 'package:up_todo/core/utils/theme/theme.dart';
import 'package:up_todo/features/splash/splash.dart';
import 'package:up_todo/features/tasks/data/datasources/category_local_datasource.dart';
import 'package:up_todo/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:up_todo/features/tasks/data/repositories/category_repository_impl.dart';
import 'package:up_todo/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:up_todo/features/tasks/domain/usecases/add_task.dart';
import 'package:up_todo/features/tasks/domain/usecases/delete_task.dart';
import 'package:up_todo/features/tasks/domain/usecases/get_tasks.dart';
import 'package:up_todo/features/tasks/domain/usecases/update_task.dart';
import 'package:up_todo/features/tasks/presentation/bloc/categories/category_bloc.dart';
import 'package:up_todo/features/tasks/presentation/bloc/categories/category_event.dart';
import 'package:up_todo/features/tasks/presentation/bloc/tasks/task_bloc.dart';
import 'package:up_todo/features/tasks/presentation/bloc/tasks/task_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final database = DatabaseHelper();
            final localDataSource = TaskLocalDataSourceImpl(database);
            final repository = TaskRepositoryImpl(localDataSource);

            return TaskBloc(
              getTasks: GetTasks(repository),
              addTask: AddTask(repository),
              updateTask: UpdateTask(repository),
              deleteTask: DeleteTask(repository),
            )..add(LoadTasks());
          },
        ),
        BlocProvider(
          create: (context) {
            final database = DatabaseHelper();
            final localDataSource = CategoryLocalDataSourceImpl(database);
            final repository = CategoryRepositoryImpl(localDataSource);

            return CategoryBloc(repository)..add(LoadCategories());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Up Todo',
        debugShowCheckedModeBanner: false,
        theme: TodoAppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
