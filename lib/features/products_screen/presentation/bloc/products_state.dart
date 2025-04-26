part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();
  
  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class CategoriesLoadingState extends ProductsState {}

final class CategoriesLoadedState extends ProductsState {
  final List<CategoryModel> categories;

  const CategoriesLoadedState({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoriesErrorState extends ProductsState {
  final String message;

  const CategoriesErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
