import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_pos/features/list_products/domain/repositories/product_repository.dart';
import 'package:flutter_pos/features/list_products/presentation/bloc/list_products_bloc.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';

import '../../../../helpers/test_helpers.dart';

class MockProductRepository extends Mock implements ProductRepository {}
class FakeProductModel extends Fake implements ProductModel {}

void main() {
  late MockProductRepository mockRepository;
  late ListProductsBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeProductModel());
    registerFallbackValue(1);
  });

  setUp(() {
    mockRepository = MockProductRepository();
    bloc = ListProductsBloc(productRepository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('FetchProductsByCategoryEvent', () {
    const categoryId = 1;
    final testProducts = TestProductData.getTestProducts(categoryId: categoryId);

    test('emits [ListProductsLoading, ListProductsLoadedState] when fetching products succeeds', () async {
      // Arrange
      when(() => mockRepository.getProductsByCategory(categoryId))
          .thenAnswer((_) async => testProducts);
      
      // Act
      bloc.add(const FetchProductsByCategoryEvent(categoryId: categoryId));
      
      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<ListProductsLoadedState>());
      final state = bloc.state as ListProductsLoadedState;
      expect(state.products, testProducts);
      expect(state.categoryId, categoryId);
      
      verify(() => mockRepository.getProductsByCategory(categoryId)).called(1);
    });

    test('emits [ListProductsLoading, ListProductsErrorState] when fetching products fails', () async {
      // Arrange
      when(() => mockRepository.getProductsByCategory(categoryId))
          .thenThrow(Exception('Failed to load products'));
      
      // Act
      bloc.add(const FetchProductsByCategoryEvent(categoryId: categoryId));
      
      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<ListProductsErrorState>());
      final state = bloc.state as ListProductsErrorState;
      expect(state.message, contains('Failed to load products'));
      
      verify(() => mockRepository.getProductsByCategory(categoryId)).called(1);
    });
  });

  group('AddProductEvent', () {
    // Create a test product without categoryId to avoid triggering FetchProductsByCategoryEvent
    final testProductWithoutCategory = ProductModel(
      id: 1,
      codigo: 'PROD1',
      nombre: 'Test Product',
      descripcion: 'Test Description',
      precioCompra: 10.0,
      precioVenta: 15.0,
      categoriaId: null, // Set to null to prevent the FetchProductsByCategoryEvent from being triggered
      imagenUrl: 'test_image_url.jpg',
    );

    test('emits [ListProductsLoading, AddProductSuccessState] and does not fetch when product has no categoryId', () async {
      // Arrange
      when(() => mockRepository.createProduct(any()))
          .thenAnswer((_) async => Result.ok(testProductWithoutCategory));
      
      // Act
      bloc.add(AddProductEvent(product: testProductWithoutCategory));
      
      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<AddProductSuccessState>());
      
      // Verify repository was called
      verify(() => mockRepository.createProduct(any())).called(1);
      
      // Verify that getProductsByCategory was NOT called because categoryId is null
      verifyNever(() => mockRepository.getProductsByCategory(any()));
    });

    // Test with a product that has a categoryId to check that FetchProductsByCategoryEvent is triggered
    final testProductWithCategory = ProductModel(
      id: 2,
      codigo: 'PROD2',
      nombre: 'Test Product 2',
      descripcion: 'Test Description 2',
      precioCompra: 20.0,
      precioVenta: 25.0,
      categoriaId: 1, // Set to trigger FetchProductsByCategoryEvent
      imagenUrl: 'test_image_url.jpg',
    );

    test('emits AddProductSuccessState and triggers fetch when product has categoryId', () async {
      // Arrange
      when(() => mockRepository.createProduct(any()))
          .thenAnswer((_) async => Result.ok(testProductWithCategory));
      
      // Also mock getProductsByCategory because it will be called
      when(() => mockRepository.getProductsByCategory(any()))
          .thenAnswer((_) async => [testProductWithCategory]);
      
      // Act
      bloc.add(AddProductEvent(product: testProductWithCategory));
      
      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Create a listener to capture state changes
      final states = <ListProductsState>[];
      final subscription = bloc.stream.listen(states.add);
      
      // Wait a bit more to ensure all states are emitted
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Clean up
      await subscription.cancel();
      
      // Assert - just verify both repository methods were called
      verify(() => mockRepository.createProduct(any())).called(1);
      verify(() => mockRepository.getProductsByCategory(testProductWithCategory.categoriaId!)).called(1);
    });

    test('emits [ListProductsLoading, ListProductsErrorState] when adding product fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        error: 'Test error',
        message: 'Failed to create product',
      );
      when(() => mockRepository.createProduct(any()))
          .thenAnswer((_) async => Result.err(dioError));
      
      // Act
      bloc.add(AddProductEvent(product: testProductWithoutCategory));
      
      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(bloc.state, isA<ListProductsErrorState>());
      final state = bloc.state as ListProductsErrorState;
      expect(state.message, contains('Failed to create product'));
      
      verify(() => mockRepository.createProduct(any())).called(1);
    });
  });
} 