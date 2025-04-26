part of 'list_products_bloc.dart';

sealed class ListProductsEvent extends Equatable {
  const ListProductsEvent();

}

class FetchProductsByCategoryEvent extends ListProductsEvent {
  final int categoryId;

  const FetchProductsByCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}
