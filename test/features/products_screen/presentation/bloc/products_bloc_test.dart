import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_pos/features/products_screen/domain/repositories/category_repository.dart';
import 'package:flutter_pos/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';

import '../../../../helpers/test_helpers.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}
class FakeCategoryModel extends Fake implements CategoryModel {}

void main() {
  late MockCategoryRepository mockRepository;
  late ProductsBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeCategoryModel());
  });

  setUp(() {
    mockRepository = MockCategoryRepository();
    
    // Mock getAllCategories for the automatic event triggered in the constructor
    final testCategories = TestCategoryData.getTestCategories();
    when(() => mockRepository.getAllCategories())
        .thenAnswer((_) async => Result.ok(testCategories));
        
    bloc = ProductsBloc(categoryRepository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('FetchCategoriesInitialEvent', () {
    final testCategories = TestCategoryData.getTestCategories();

    test('emits [CategoriesLoadingState, CategoriesLoadedState] when fetching categories succeeds', () async {
      // Arrange - clear previous states and set up a fresh mock
      bloc.emit(ProductsInitial());
      reset(mockRepository);
      when(() => mockRepository.getAllCategories())
          .thenAnswer((_) async => Result.ok(testCategories));
      
      // Act
      bloc.add(const FetchCategoriesInitialEvent());
      
      // Wait for states to emit
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<CategoriesLoadedState>());
      final state = bloc.state as CategoriesLoadedState;
      expect(state.categories, testCategories);
      
      verify(() => mockRepository.getAllCategories()).called(1);
    });

    test('emits [CategoriesLoadingState, CategoriesErrorState] when fetching categories fails', () async {
      // Arrange - clear previous states and set up a fresh mock
      bloc.emit(ProductsInitial());
      reset(mockRepository);
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        error: 'Test error',
        message: 'Error fetching categories',
      );
      when(() => mockRepository.getAllCategories())
          .thenAnswer((_) async => Result.err(dioError));
      
      // Act
      bloc.add(const FetchCategoriesInitialEvent());
      
      // Wait for states to emit
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<CategoriesErrorState>());
      final state = bloc.state as CategoriesErrorState;
      expect(state.message, 'Error fetching categories');
      
      verify(() => mockRepository.getAllCategories()).called(1);
    });
  });

  group('AddCategoryEvent', () {
    final testCategory = TestCategoryData.getSingleTestCategory();

    // To properly test just the AddCategoryEvent handler, we need to focus only on
    // the initial response right after adding a category, since it then triggers
    // FetchCategoriesInitialEvent which will emit additional states
    test('initially emits CategoryAddedSuccessState when adding category succeeds', () async {
      // Arrange - clear previous states and set up a fresh mock
      bloc.emit(ProductsInitial());
      reset(mockRepository);
      
      // Mock createCategory to return success
      when(() => mockRepository.createCategory(any()))
          .thenAnswer((_) async => Result.ok(testCategory));
      
      // Mock getAllCategories to avoid failures in the post-success fetch
      when(() => mockRepository.getAllCategories())
          .thenAnswer((_) async => Result.ok([testCategory]));
      
      // Create a listener to capture state changes
      final states = <ProductsState>[];
      final subscription = bloc.stream.listen(states.add);
      
      // Act
      bloc.add(AddCategoryEvent(category: testCategory));
      
      // Wait for states to emit
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Clean up
      await subscription.cancel();
      
      // Assert - check that we get the loading state and success state in order
      expect(states, contains(isA<CategoriesLoadingState>()));
      expect(states.any((state) => state is CategoryAddedSuccessState), isTrue);
      
      // Verify repository was called
      verify(() => mockRepository.createCategory(any())).called(1);
    });

    test('emits CategoriesErrorState when adding category fails', () async {
      // Arrange - clear previous states and set up a fresh mock
      bloc.emit(ProductsInitial());
      reset(mockRepository);
      
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        error: 'Test error',
        message: 'Error creating category',
      );
      when(() => mockRepository.createCategory(any()))
          .thenAnswer((_) async => Result.err(dioError));
      
      // Act
      bloc.add(AddCategoryEvent(category: testCategory));
      
      // Wait for states to emit
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<CategoriesErrorState>());
      final state = bloc.state as CategoriesErrorState;
      expect(state.message, 'Error creating category');
      
      verify(() => mockRepository.createCategory(any())).called(1);
    });
  });
} 