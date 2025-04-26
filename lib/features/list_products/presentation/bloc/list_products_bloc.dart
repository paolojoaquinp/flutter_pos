import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/list_products/domain/repositories/product_repository.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';

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
    on<AddProductEvent>(_onAddProduct);
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

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ListProductsState> emit,
  ) async {
    try {
      // Loading state while creating product
      emit(ListProductsLoading());
      
      // Create the product
      final result = await productRepository.createProduct(event.product);
      
      // Handle the result
      result.match(
        (product) {
          // Refresh products list for current category
          if (product.categoriaId != null) {
            add(FetchProductsByCategoryEvent(categoryId: product.categoriaId!));
          }
          // Emit success state
          emit(AddProductSuccessState(product: product));
        },
        (error) => emit(ListProductsErrorState(message: error.message ?? 'Failed to create product')),
      );
    } catch (e) {
      emit(ListProductsErrorState(message: e.toString()));
    }
  }
}
