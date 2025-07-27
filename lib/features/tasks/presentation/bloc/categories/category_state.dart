import '../../../../../core/utils/constants.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryItem> categories;

  const CategoryLoaded(this.categories);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryLoaded &&
        other.categories.length == categories.length &&
        other.categories.every((cat) => categories.any((c) => c.name == cat.name));
  }

  @override
  int get hashCode => categories.hashCode;
}

class CategoryUsageLoaded extends CategoryState {
  final List<Map<String, dynamic>> categoryUsage;

  const CategoryUsageLoaded(this.categoryUsage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryUsageLoaded && other.categoryUsage == categoryUsage;
  }

  @override
  int get hashCode => categoryUsage.hashCode;
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
