part of 'list_products_bloc.dart';

sealed class ListProductsState extends Equatable {
  const ListProductsState();
  
}

final class ListProductsInitial extends ListProductsState {
  @override
  List<Object?> get props => [];
}


final class ListProductsLoading extends ListProductsState {
  @override
  List<Object?> get props => [];
}

class ListProductsLoadedState extends ListProductsState {
  final List<ProductEntity> products;
  final int categoryId;

  const ListProductsLoadedState({
    required this.products,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [products, categoryId];
}

class ListProductsErrorState extends ListProductsState {
  final String message;

  const ListProductsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddProductSuccessState extends ListProductsState {
  final ProductModel product;

  const AddProductSuccessState({required this.product});

  @override
  List<Object?> get props => [product];
}