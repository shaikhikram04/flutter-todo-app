# Up Todo - Flutter Todo Application

## Project Overview

Up Todo is a comprehensive task management application built with Flutter that demonstrates clean architecture principles, state management using BLoC pattern, and local database storage with SQLite. The application provides users with an intuitive interface to manage their daily tasks with advanced features like categorization, priority levels, filtering, and search functionality.

## Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                           # Core functionality shared across features
│   ├── database/                   # Database layer
│   └── utils/                      # Utilities, themes, constants
├── features/                       # Feature-based modules
│   ├── splash/                     # Splash screen feature
│   └── tasks/                      # Task management feature
│       ├── data/                   # Data layer (repositories, datasources, models)
│       ├── domain/                 # Domain layer (entities, repositories, use cases)
│       └── presentation/           # Presentation layer (UI, BLoC, widgets)
└── main.dart                       # Application entry point
```

### Layer Responsibilities

- **Presentation Layer**: UI components, state management (BLoC), and user interaction handling
- **Domain Layer**: Business logic, entities, and use cases (independent of external frameworks)
- **Data Layer**: Data sources, repository implementations, and data models
- **Core Layer**: Shared utilities, database configuration, themes, and constants

## Features

### 🎯 Core Features

1. **Task Management**
   - Create new tasks with title, category, priority, and due date
   - Mark tasks as complete/incomplete
   - Delete tasks with confirmation dialog
   - Real-time task updates

2. **Task Organization**
   - **Categories**: 9 predefined categories (Grocery, Work, Sport, Home, University, Social, Music, Health, Movie)
   - **Priority Levels**: 5-level priority system (1=Highest, 5=Lowest)
   - **Due Dates**: Calendar-based date selection

3. **Advanced Filtering & Search**
   - **Search**: Real-time text search across task titles
   - **Priority Filter**: Filter by specific priority levels
   - **Category Filter**: Filter by task categories
   - **Date Filters**: Today, Tomorrow, This Week, This Month, Overdue, Specific Date
   - **Combined Filters**: Apply multiple filters simultaneously
   - **Filter Status**: Visual indicators for active filters

4. **User Interface**
   - **Dark Theme**: Modern dark theme with custom styling
   - **Responsive Design**: Optimized for various screen sizes
   - **Visual Feedback**: Loading states, error handling, empty states
   - **Smooth Animations**: Transitions and micro-interactions

## Database Schema

The application uses **SQLite** database with the following schema:

### Tasks Table
```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  priority INTEGER NOT NULL,
  date TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  createdAt TEXT NOT NULL
)
```

### Categories Table
```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  iconCodePoint INTEGER NOT NULL,
  colorValue INTEGER NOT NULL,
  isCustom INTEGER NOT NULL DEFAULT 1,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
)
```

### Default Categories
The application comes with 9 predefined categories:
- **Grocery** (Green, Shopping Cart Icon)
- **Work** (Red, Work Icon)
- **Sport** (Blue, Fitness Icon)
- **Home** (Light Red, Home Icon)
- **University** (Purple, School Icon)
- **Social** (Pink/Purple, People Icon)
- **Music** (Light Purple, Music Note Icon)
- **Health** (Green, Heart Icon)
- **Movie** (Light Blue, Movie Icon)

## Technical Implementation

### State Management (BLoC Pattern)

The application uses **flutter_bloc** for state management with the following components:

#### Task BLoC
- **Events**: LoadTasks, AddTaskEvent, UpdateTaskEvent, DeleteTaskEvent, ToggleTaskCompletion, SearchTaskEvent, ApplyFiltersEvent, ClearFiltersEvent
- **States**: TaskInitial, TaskLoading, TaskLoaded, TaskError

#### Task States
```dart
abstract class TaskState extends Equatable
class TaskInitial extends TaskState
class TaskLoading extends TaskState
class TaskLoaded extends TaskState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final String searchQuery;
  final TaskFilter activeFilter;
}
class TaskError extends TaskState
```

### Domain Entities

#### Task Entity
```dart
class Task extends Equatable {
  final int? id;
  final String title;
  final String category;
  final int priority;           // 1-5 (1=highest priority)
  final DateTime date;
  final bool isCompleted;
  final DateTime createdAt;
}
```

#### Task Filter
```dart
class TaskFilter extends Equatable {
  final int? priority;           // Priority level filter
  final String? category;        // Category name filter
  final DateFilterType? dateFilter;
  final DateTime? specificDate;
}
```

### Use Cases (Business Logic)

1. **GetTasks**: Retrieve all tasks from repository
2. **AddTask**: Add new task to repository
3. **UpdateTask**: Update existing task
4. **DeleteTask**: Remove task by ID

### Data Layer

#### Repository Pattern
- **TaskRepository** (Abstract): Defines contract for task operations
- **TaskRepositoryImpl**: Concrete implementation using local data source

#### Data Sources
- **TaskLocalDataSource**: Abstract interface for local data operations
- **TaskLocalDataSourceImpl**: SQLite implementation

#### Models
- **TaskModel**: Extends Task entity with database serialization methods

## User Interface Components

### Screens

1. **Splash Screen**
   - App logo display
   - 3-second delay before navigation
   - Automatic navigation to main screen

2. **Tasks Screen (Main)**
   - Task list display
   - Search bar
   - Filter button with active filter indicators
   - Floating action button for adding tasks
   - Empty state handling

3. **Add Task Screen**
   - Title input field
   - Date picker for due date
   - Category selection dialog
   - Priority level selector
   - Validation and error handling

### Widgets

1. **TaskCard**
   - Displays task information
   - Completion toggle checkbox
   - Category badge with color coding
   - Priority flag indicator
   - Delete functionality with confirmation

2. **FilterBottomSheet**
   - Priority level filters
   - Category filters with color coding
   - Date range filters
   - Apply/Clear actions

3. **CategoriesDialog**
   - Grid layout of available categories
   - Color-coded category selection
   - Icon representation for each category

4. **NoTaskWidget**
   - Empty state illustration
   - Motivational messaging
   - Call-to-action for adding first task

### Theme & Styling

#### Dark Theme Configuration
- **Primary Color**: Purple (`#8685E7`)
- **Background**: Black (`#000000`)
- **Surface**: Dark Gray (`#1E1E1E`)
- **Text**: White primary, gray secondary
- **Custom Font**: Inter (Regular, Medium, Bold, Light)

#### Custom Theme Components
- **Elevated Button Theme**: Purple primary with rounded corners
- **App Bar Theme**: Dark with white text
- **Text Field Theme**: Dark background with border styling
- **Chip Theme**: Category-specific styling
- **Checkbox Theme**: Custom completion indicators

## Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  flutter_bloc: ^9.1.1          # State management
  sqflite: ^2.4.1               # SQLite database
  path: ^1.9.0                  # Path utilities
  intl: ^0.20.2                 # Internationalization
  equatable: ^2.0.7             # Value equality
  cupertino_icons: ^1.0.8       # iOS-style icons
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0         # Lint rules
```

## File Structure Details

### Core Module

#### Database Helper (`database_helper.dart`)
- Singleton pattern for database instance
- Database versioning and migration support
- CRUD operations for tasks and categories
- Default category initialization
- Database statistics and utility methods

#### Theme System
- `theme.dart`: Main theme configuration
- `colors.dart`: Color palette definitions
- `custom-theme/`: Component-specific themes
- `constants.dart`: App-wide constants

### Tasks Feature Module

#### Domain Layer
- `entities/task.dart`: Task business entity
- `repositories/task_repository.dart`: Repository contract
- `usecases/`: Individual use case implementations

#### Data Layer
- `models/task_model.dart`: Task data model with serialization
- `datasources/task_local_datasource.dart`: Local storage abstraction
- `repositories/task_repository_impl.dart`: Repository implementation

#### Presentation Layer
- `screens/`: Main UI screens
- `widgets/`: Reusable UI components
- `bloc/`: State management components

## Advanced Features

### Filter System
The application provides sophisticated filtering capabilities:

1. **Priority Filtering**: Filter tasks by priority levels (1-5)
2. **Category Filtering**: Filter by predefined categories
3. **Date Filtering**: Multiple date filter options
4. **Combined Filtering**: Apply multiple filters simultaneously
5. **Filter Persistence**: Maintain filter state during session
6. **Visual Indicators**: Show active filters with badges

### Search Functionality
- **Real-time Search**: Instant results as user types
- **Case-insensitive**: Flexible search matching
- **Combined with Filters**: Search within filtered results
- **No Results State**: Helpful messaging when no matches found

### Data Management
- **Local Storage**: All data stored locally using SQLite
- **Data Persistence**: Tasks survive app restarts
- **Optimistic Updates**: Immediate UI updates with background sync
- **Error Handling**: Graceful error recovery

## Performance Considerations

1. **Database Optimization**
   - Indexed queries for better performance
   - Efficient database schema design
   - Connection pooling and reuse

2. **State Management**
   - Minimal state rebuilds
   - Efficient data flow with BLoC
   - Proper state disposal

3. **UI Performance**
   - ListView.builder for large lists
   - Efficient widget rebuilding
   - Image optimization and caching

## Future Enhancement Opportunities

1. **Task Categories**
   - Custom category creation
   - Category management interface
   - Icon and color customization

2. **Advanced Features**
   - Task subtasks and dependencies
   - Recurring task support
   - Task reminders and notifications
   - Data export/import functionality

3. **User Experience**
   - Light theme option
   - Accessibility improvements
   - Gesture-based interactions
   - Offline synchronization

4. **Data Features**
   - Cloud synchronization
   - Cross-device support
   - Data backup and restore
   - Analytics and insights

## Testing Strategy

The project includes basic testing setup:
- **Widget Tests**: UI component testing
- **Unit Tests**: Business logic validation
- **Integration Tests**: End-to-end functionality testing

## Getting Started

### Prerequisites
- Flutter SDK (^3.6.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

### Building
- **Debug**: `flutter run`
- **Release**: `flutter build apk` or `flutter build ios`

## Conclusion

Up Todo demonstrates modern Flutter development practices with clean architecture, efficient state management, and thoughtful user experience design. The application serves as an excellent example of building scalable, maintainable mobile applications with Flutter while providing practical task management functionality for end users.
