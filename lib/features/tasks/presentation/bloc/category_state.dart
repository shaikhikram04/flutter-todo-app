import 'package:equatable/equatable.dart';

import '../../../../core/utils/constants.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryItem> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryAdded extends CategoryState {
  final CategoryItem addedCategory;

  const CategoryAdded(this.addedCategory);

  @override
  List<Object?> get props => [addedCategory];
}
