import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';
import 'package:flutter_pos/features/products_screen/domain/entities/category_entity.dart';
import 'package:flutter_pos/features/products_screen/domain/repositories/category_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final CategoryRepository categoryRepository;

   ProductsBloc({required this.categoryRepository}) : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchCategoriesInitialEvent>(_onFetchCategoriesInitialEvent);
    on<AddCategoryEvent>(_onAddCategoryEvent);
  }

  Future<void> _onFetchCategoriesInitialEvent(
    FetchCategoriesInitialEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(CategoriesLoadingState());
    
    final result = await categoryRepository.getAllCategories();
    
    result.match(
      (categories) => emit(CategoriesLoadedState(categories: categories)),
      (error) => emit(CategoriesErrorState(message: error.message ?? 'Error fetching categories')),
    );
  }
  
  Future<void> _onAddCategoryEvent(
    AddCategoryEvent event,
    Emitter<ProductsState> emit,
  ) async {   
    // Convert CategoryEntity to CategoryModel
    final newCategoryModel = CategoryModel(
      id: event.category.id,
      nombre: event.category.nombre,
      descripcion: event.category.descripcion,
    );
    
    final result = await categoryRepository.createCategory(newCategoryModel);
    
    result.match(
      (category) {
        // Fetch updated categories list after successful creation
        add(const FetchCategoriesInitialEvent());
        emit(CategoryAddedSuccessState(category: category));
      },
      (error) => emit(CategoriesErrorState(message: error.message ?? 'Error creating category')),
    );
  }
}
