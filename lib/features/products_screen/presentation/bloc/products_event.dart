part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesInitialEvent extends ProductsEvent {
  const FetchCategoriesInitialEvent();
}
