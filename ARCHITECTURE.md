# Architecture Documentation

## Overview
The Up Todo application follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability. This document provides an in-depth analysis of the architectural decisions and patterns implemented.

## Clean Architecture Layers

### Architecture Diagram
```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │   Widgets   │  │    BLoC/Cubit       │ │
│  │             │  │             │  │  (State Management) │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Entities   │  │  Use Cases  │  │   Repositories      │ │
│  │             │  │             │  │   (Interfaces)      │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Models    │  │ Data Sources│  │   Repositories      │ │
│  │             │  │             │  │ (Implementations)   │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Core Layer                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Database   │  │   Themes    │  │     Utilities       │ │
│  │             │  │             │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Layer Implementation Details

### 1. Presentation Layer
**Location**: `lib/features/*/presentation/`

#### Responsibilities
- User interface components
- State management with BLoC pattern
- User input handling
- Navigation logic
- UI state representation

#### Components

##### Screens
```dart
// Main task management screen
class TasksScreen extends StatelessWidget {
  // Displays task list, search, filters, FAB
}

// Task creation/editing screen
class AddTaskScreen extends StatefulWidget {
  // Form for task input with validation
}

// Initial application screen
class SplashScreen extends StatefulWidget {
  // App logo with navigation delay
}
```

##### Widgets
```dart
// Individual task display component
class TaskCard extends StatelessWidget {
  // Task information, completion toggle, delete action
}

// Advanced filtering interface
class FilterBottomSheet extends StatefulWidget {
  // Priority, category, date filtering options
}

// Category selection interface
class CategoriesDialog extends StatelessWidget {
  // Grid-based category picker
}

// Empty state display
class NoTaskWidget extends StatelessWidget {
  // Motivational empty state with call-to-action
}
```

##### State Management (BLoC)
```dart
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  
  // Event handlers for all task operations
}
```

**Events**:
- `LoadTasks`: Initial data loading
- `AddTaskEvent`: New task creation
- `UpdateTaskEvent`: Task modification
- `DeleteTaskEvent`: Task removal
- `ToggleTaskCompletion`: Completion status toggle
- `SearchTaskEvent`: Text-based search
- `ApplyFiltersEvent`: Filter application
- `ClearFiltersEvent`: Filter reset

**States**:
- `TaskInitial`: Initial state
- `TaskLoading`: Data loading indicator
- `TaskLoaded`: Data available with filtering
- `TaskError`: Error state with message

### 2. Domain Layer
**Location**: `lib/features/*/domain/`

#### Responsibilities
- Business logic implementation
- Core entities definition
- Use case orchestration
- Repository interfaces
- Framework-independent code

#### Components

##### Entities
```dart
class Task extends Equatable {
  final int? id;
  final String title;
  final String category;
  final int priority;        // 1-5 priority scale
  final DateTime date;       // Due date
  final bool isCompleted;    // Completion status
  final DateTime createdAt;  // Creation timestamp
  
  // Immutable entity with copyWith method
}
```

##### Use Cases
```dart
class GetTasks {
  final TaskRepository repository;
  
  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}

class AddTask {
  final TaskRepository repository;
  
  Future<int> call(Task task) async {
    return await repository.addTask(task);
  }
}

class UpdateTask {
  final TaskRepository repository;
  
  Future<int> call(Task task) async {
    return await repository.updateTask(task);
  }
}

class DeleteTask {
  final TaskRepository repository;
  
  Future<int> call(int id) async {
    return await repository.deleteTask(id);
  }
}
```

##### Repository Interfaces
```dart
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<int> addTask(Task task);
  Future<int> updateTask(Task task);
  Future<int> deleteTask(int id);
}
```

### 3. Data Layer
**Location**: `lib/features/*/data/`

#### Responsibilities
- Data source management
- Repository implementation
- Data transformation
- External service integration
- Caching strategies

#### Components

##### Models
```dart
class TaskModel extends Task {
  // Extends domain entity
  
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    // Database deserialization
  }
  
  Map<String, dynamic> toMap() {
    // Database serialization
  }
}
```

##### Data Sources
```dart
abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<int> addTask(TaskModel task);
  Future<int> updateTask(TaskModel task);
  Future<int> deleteTask(int id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;
  
  // SQLite implementation
}
```

##### Repository Implementation
```dart
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  
  @override
  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }
  
  // Converts between domain entities and data models
}
```

### 4. Core Layer
**Location**: `lib/core/`

#### Responsibilities
- Shared utilities and constants
- Database configuration
- Theme and styling
- Common functionality
- Cross-cutting concerns

#### Components

##### Database
```dart
class DatabaseHelper {
  static Database? _database;
  static const String tasksTableName = 'tasks';
  static const String categoriesTableName = 'categories';
  static const int _databaseVersion = 2;
  
  // Singleton pattern implementation
  // Database creation and migration
  // CRUD operations
}
```

##### Utilities
```dart
class CategoryConstants {
  static final List<CategoryItem> categories = [
    // Predefined category definitions
  ];
  
  static CategoryItem getCategoryByName(String categoryName) {
    // Category lookup utility
  }
}

class TodoColors {
  // Application color palette
}
```

##### Theme System
```dart
class TodoAppTheme {
  static ThemeData darkTheme = ThemeData(
    // Custom dark theme configuration
  );
}
```

## Design Patterns Implementation

### 1. Repository Pattern
**Purpose**: Encapsulate data access logic and provide a uniform interface.

```dart
// Interface (Domain Layer)
abstract class TaskRepository {
  Future<List<Task>> getTasks();
  // ...other methods
}

// Implementation (Data Layer)
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  
  @override
  Future<List<Task>> getTasks() async {
    return await localDataSource.getTasks();
  }
}
```

**Benefits**:
- Decouples business logic from data access
- Enables easy testing with mock implementations
- Supports multiple data sources (local, remote)
- Provides clean abstraction over data complexity

### 2. Use Case Pattern
**Purpose**: Encapsulate business logic into single-responsibility classes.

```dart
class AddTask {
  final TaskRepository repository;
  
  AddTask(this.repository);
  
  Future<int> call(Task task) async {
    // Business logic validation could go here
    return await repository.addTask(task);
  }
}
```

**Benefits**:
- Single responsibility principle
- Reusable business logic
- Easy to test in isolation
- Clear intention and naming

### 3. BLoC Pattern
**Purpose**: Separate business logic from UI and manage application state.

```dart
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  // ...other use cases
  
  TaskBloc({required this.getTasks, required this.addTask}) 
      : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    // ...other event handlers
  }
}
```

**Benefits**:
- Predictable state management
- Separation of concerns
- Testable business logic
- Reactive programming model

### 4. Singleton Pattern
**Purpose**: Ensure single database instance throughout the application.

```dart
class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
}
```

**Benefits**:
- Resource management
- Consistent database access
- Prevents multiple connections
- Memory efficiency

## Dependency Injection

### Manual Dependency Injection
The application uses manual dependency injection for simplicity:

```dart
// In main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
      child: MaterialApp(/* ... */),
    );
  }
}
```

**Benefits**:
- Simple and explicit
- No additional dependencies
- Easy to understand
- Suitable for small applications

**Considerations for Scaling**:
- Consider using `get_it` or `injectable` for larger applications
- Dependency graphs can become complex
- Manual wiring increases boilerplate

## Error Handling Strategy

### Layer-Specific Error Handling

#### Data Layer
```dart
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(/* ... */);
      return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
    } catch (e) {
      throw DataSourceException('Failed to retrieve tasks: ${e.toString()}');
    }
  }
}
```

#### Domain Layer
```dart
class GetTasks {
  Future<List<Task>> call() async {
    try {
      return await repository.getTasks();
    } catch (e) {
      throw UseCaseException('Failed to get tasks: ${e.toString()}');
    }
  }
}
```

#### Presentation Layer
```dart
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
```

## Testing Architecture

### Unit Testing Strategy

#### Domain Layer Tests
```dart
group('GetTasks Use Case', () {
  test('should return list of tasks from repository', () async {
    // Given
    final mockRepository = MockTaskRepository();
    final useCase = GetTasks(mockRepository);
    final expectedTasks = [Task(/* ... */)];
    
    when(mockRepository.getTasks()).thenAnswer((_) async => expectedTasks);
    
    // When
    final result = await useCase();
    
    // Then
    expect(result, expectedTasks);
    verify(mockRepository.getTasks());
  });
});
```

#### Presentation Layer Tests
```dart
group('TaskBloc', () {
  testBloc<TaskBloc, TaskState>(
    'emits [TaskLoading, TaskLoaded] when LoadTasks is added',
    build: () => TaskBloc(getTasks: mockGetTasks, /* ... */),
    act: (bloc) => bloc.add(LoadTasks()),
    expect: () => [TaskLoading(), TaskLoaded(mockTasks)],
  );
});
```

### Integration Testing
- Database operations with real SQLite
- Full feature workflows
- End-to-end user scenarios

## Performance Considerations

### Memory Management
1. **BLoC State**: Efficient state objects with immutable data
2. **Database Connections**: Singleton pattern prevents multiple connections
3. **Widget Building**: Efficient ListView.builder for large lists

### Data Loading
1. **Lazy Loading**: Load data only when needed
2. **Caching**: BLoC maintains state during navigation
3. **Optimistic Updates**: Immediate UI feedback

### State Management Optimization
1. **Selective Rebuilds**: BlocBuilder with specific state types
2. **Event Debouncing**: Search input debouncing for performance
3. **State Comparison**: Equatable for efficient state comparison

## Scalability Considerations

### Horizontal Scaling
1. **Feature Modules**: Each feature in separate module
2. **Shared Core**: Common functionality in core module
3. **Plugin Architecture**: Easy to add new features

### Vertical Scaling
1. **Layer Separation**: Clear boundaries enable independent scaling
2. **Interface Abstractions**: Easy to swap implementations
3. **Use Case Composition**: Complex operations from simple use cases

## Security Considerations

### Data Protection
1. **Local Storage**: SQLite database in app sandbox
2. **Input Validation**: Sanitization at data layer
3. **SQL Injection**: Parameterized queries only

### Code Security
1. **Immutable Entities**: Prevent unintended state mutations
2. **Access Control**: Private implementation details
3. **Error Handling**: No sensitive information in error messages

## Future Architecture Enhancements

### Potential Improvements
1. **Dependency Injection**: Migrate to `get_it` for better scalability
2. **Result Types**: Implement Result<T> pattern for better error handling
3. **Event Sourcing**: Consider for complex state management
4. **CQRS**: Separate read/write operations for optimization

### Additional Layers
1. **Network Layer**: For cloud synchronization
2. **Cache Layer**: For offline-first functionality
3. **Security Layer**: For data encryption and authentication

This architecture provides a solid foundation for the Up Todo application while maintaining flexibility for future enhancements and ensuring code quality, testability, and maintainability.
