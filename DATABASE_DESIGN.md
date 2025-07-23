# Database Design Documentation

## Overview
The Up Todo application uses SQLite for local data storage, implementing a well-structured relational database design that supports efficient task management and categorization.

## Database Schema

### Tables Structure

#### 1. Tasks Table
```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  priority INTEGER NOT NULL,
  date TEXT NOT NULL,                    -- Stored as ISO 8601 string
  isCompleted INTEGER NOT NULL DEFAULT 0, -- Boolean as INTEGER (0/1)
  createdAt TEXT NOT NULL               -- ISO 8601 timestamp
)
```

**Field Descriptions:**
- `id`: Auto-incrementing primary key for unique task identification
- `title`: Task title/description (required, user-defined)
- `category`: Category name (must match categories table entries)
- `priority`: Integer from 1-5 (1=highest priority, 5=lowest priority)
- `date`: Due date stored as ISO 8601 formatted string (YYYY-MM-DD)
- `isCompleted`: Task completion status (0=incomplete, 1=complete)
- `createdAt`: Task creation timestamp in ISO 8601 format

#### 2. Categories Table
```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  iconCodePoint INTEGER NOT NULL,       -- Flutter IconData.codePoint
  colorValue INTEGER NOT NULL,          -- Flutter Color.value
  isCustom INTEGER NOT NULL DEFAULT 1,  -- 0=default, 1=user-created
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
)
```

**Field Descriptions:**
- `id`: Auto-incrementing primary key
- `name`: Unique category name (used as foreign key in tasks)
- `iconCodePoint`: Flutter icon code point for UI display
- `colorValue`: Flutter color value for category theming
- `isCustom`: Distinguishes default (0) vs custom (1) categories
- `createdAt`: Category creation timestamp
- `updatedAt`: Last modification timestamp

## Database Operations

### Core CRUD Operations

#### Tasks Operations
```dart
// Create
Future<int> addTask(TaskModel task)

// Read
Future<List<TaskModel>> getTasks()

// Update
Future<int> updateTask(TaskModel task)

// Delete
Future<int> deleteTask(int id)
```

#### Categories Operations
```dart
// Read operations
Future<List<Map<String, dynamic>>> getCategories()
Future<Map<String, dynamic>?> getCategoryById(int id)
Future<Map<String, dynamic>?> getCategoryByName(String name)

// Create operations
Future<int> insertCategory({
  required String name,
  required int iconCodePoint,
  required int colorValue,
  bool isCustom = true,
})

// Update operations
Future<int> updateCategory({
  required int id,
  String? name,
  int? iconCodePoint,
  int? colorValue,
})

// Delete operations
Future<int> deleteCategory(String name)
```

### Advanced Query Operations

#### Category Usage Statistics
```sql
SELECT 
  c.id,
  c.name,
  c.iconCodePoint,
  c.colorValue,
  c.isCustom,
  COUNT(t.id) as taskCount
FROM categories c
LEFT JOIN tasks t ON c.name = t.category
GROUP BY c.id, c.name, c.iconCodePoint, c.colorValue, c.isCustom
ORDER BY c.isCustom ASC, c.name ASC
```

#### Database Statistics
```dart
Future<Map<String, int>> getDatabaseStats() async {
  return {
    'totalTasks': taskCount,
    'totalCategories': categoryCount,
    'customCategories': customCategoryCount,
  };
}
```

## Database Migration & Versioning

### Version Management
- **Current Version**: 2
- **Migration Strategy**: Incremental schema updates

### Migration History

#### Version 1 → 2
```dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Add categories table for existing databases
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        iconCodePoint INTEGER NOT NULL,
        colorValue INTEGER NOT NULL,
        isCustom INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
    
    await _insertDefaultCategories(db);
  }
}
```

## Default Data

### Predefined Categories
The database is initialized with 9 default categories:

| Name | Icon | Color (Hex) | Code Point |
|------|------|-------------|------------|
| Grocery | shopping_cart | #66BB6A | Material Icons |
| Work | work | #EF5350 | Material Icons |
| Sport | fitness_center | #42A5F5 | Material Icons |
| Home | home | #E57373 | Material Icons |
| University | school | #8875FF | Material Icons |
| Social | people | #AB47BC | Material Icons |
| Music | music_note | #BA68C8 | Material Icons |
| Health | favorite | #4CAF50 | Material Icons |
| Movie | movie | #29B6F6 | Material Icons |

### Default Category Properties
- `isCustom = 0` (cannot be deleted)
- Names cannot be modified for default categories
- Colors and icons can be updated
- Used as fallback when custom categories are deleted

## Data Integrity & Constraints

### Referential Integrity
1. **Task → Category Relationship**
   - Tasks reference categories by name (not ID for simplicity)
   - Cascading updates handled in application logic
   - Prevents deletion of categories in use

2. **Category Name Uniqueness**
   - Enforced at database level with UNIQUE constraint
   - Prevents duplicate category names

### Business Rules Enforcement

#### Category Management
```dart
// Cannot delete default categories
if (category['isCustom'] == 0) {
  throw Exception('Cannot delete default categories');
}

// Cannot delete categories in use
final tasksUsingCategory = await db.query(
  tasksTableName,
  where: 'category = ?',
  whereArgs: [category['name']],
  limit: 1,
);

if (tasksUsingCategory.isNotEmpty) {
  throw Exception('Cannot delete category that is being used by tasks');
}
```

#### Data Validation
- Task titles cannot be empty
- Priority must be between 1-5
- Dates must be valid ISO 8601 format
- Category names must exist in categories table

## Performance Optimizations

### Indexing Strategy
```sql
-- Implicit indexes
-- Primary keys automatically indexed
-- UNIQUE constraints automatically indexed

-- Potential future indexes for optimization
CREATE INDEX idx_tasks_category ON tasks(category);
CREATE INDEX idx_tasks_date ON tasks(date);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_completed ON tasks(isCompleted);
```

### Query Optimization
1. **Efficient Ordering**: Tasks ordered by `createdAt DESC` for recent-first display
2. **Minimal Data Transfer**: Select only required columns in specific queries
3. **Connection Reuse**: Singleton pattern for database instance
4. **Prepared Statements**: Using parameterized queries for security and performance

## Data Types & Serialization

### DateTime Handling
```dart
// Storage format
date: DateFormat('yyyy-MM-dd').format(date)
createdAt: createdAt.toIso8601String()

// Retrieval format
date: DateTime.parse(map['date'])
createdAt: DateTime.parse(map['createdAt'])
```

### Boolean Handling
```dart
// Storage (Dart bool → SQLite INTEGER)
isCompleted: isCompleted ? 1 : 0

// Retrieval (SQLite INTEGER → Dart bool)
isCompleted: map['isCompleted'] == 1
```

### Color & Icon Serialization
```dart
// Storage
iconCodePoint: Icons.shopping_cart.codePoint
colorValue: Color(0xFF66BB6A).value

// Retrieval
icon: IconData(map['iconCodePoint'], fontFamily: 'MaterialIcons')
color: Color(map['colorValue'])
```

## Database Utilities

### Database Management
```dart
// Close connection
Future<void> closeDatabase()

// Delete database (testing/reset)
Future<void> deleteDatabase()

// Check table existence
Future<bool> hasCategoriesTable()
```

### Category Reset Functionality
```dart
// Reset to default categories only
Future<void> resetCategoriesToDefault() async {
  // Delete custom categories
  await db.delete(categoriesTableName, where: 'isCustom = 1');
  
  // Update orphaned tasks to default category
  await db.update(
    tasksTableName,
    {'category': 'Grocery'},
    where: 'category NOT IN (SELECT name FROM categories)',
  );
}
```

## Security Considerations

1. **SQL Injection Prevention**: All queries use parameterized statements
2. **Data Validation**: Input validation at application layer
3. **Local Storage**: Data remains on device, no network transmission
4. **File Permissions**: SQLite database protected by Android/iOS sandbox

## Backup & Recovery

### Current Implementation
- Data persists in app's private storage
- Survives app updates (on same device)
- Lost on app uninstall or device reset

### Future Enhancements
- Export functionality for data backup
- Import capability for data restoration
- Cloud synchronization options
- Database encryption for sensitive data

## Testing Database Operations

### Unit Testing Approach
```dart
// Test database operations
testWidgets('should add task to database', (tester) async {
  final helper = DatabaseHelper();
  final task = TaskModel(...);
  
  final id = await helper.addTask(task);
  expect(id, greaterThan(0));
  
  final tasks = await helper.getTasks();
  expect(tasks.length, 1);
  expect(tasks.first.title, task.title);
});
```

### Integration Testing
- Database creation and migration
- CRUD operations with real data
- Constraint enforcement validation
- Performance benchmarking

This database design provides a solid foundation for the task management application while maintaining flexibility for future enhancements and maintaining data integrity throughout the application lifecycle.
