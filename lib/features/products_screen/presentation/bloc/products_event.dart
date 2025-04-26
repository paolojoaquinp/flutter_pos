part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesInitialEvent extends ProductsEvent {
  const FetchCategoriesInitialEvent();
}

final class AddCategoryEvent extends ProductsEvent {
  final CategoryEntity category;
  
  const AddCategoryEvent({required this.category});
  
  @override
  List<Object> get props => [category];
}
