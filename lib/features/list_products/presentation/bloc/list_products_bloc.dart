import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pos/features/list_products/domain/repositories/product_repository.dart';
import 'package:flutter_pos/features/products_screen/domain/entities/product_entity.dart';

part 'list_products_event.dart';
part 'list_products_state.dart';

// BLoC
class ListProductsBloc extends Bloc<ListProductsEvent, ListProductsState> {
  final ProductRepository productRepository;

  ListProductsBloc({
    required this.productRepository,
  }) : super(ListProductsInitial()) {
    on<ListProductsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchProductsByCategoryEvent>(_onFetchProductsByCategory);
  }

  Future<void> _onFetchProductsByCategory(
    FetchProductsByCategoryEvent event,
    Emitter<ListProductsState> emit,
  ) async {
    emit(ListProductsLoading());
    try {
      final products = await productRepository.getProductsByCategory(event.categoryId);
      emit(ListProductsLoadedState(
        products: products,
        categoryId: event.categoryId,
      ));
    } catch (e) {
      emit(ListProductsErrorState(message: e.toString()));
    }
  }
}
