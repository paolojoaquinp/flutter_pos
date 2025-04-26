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
    final testProduct = TestProductData.getSingleTestProduct();
    final testProducts = [testProduct];

    // Create a special mock that doesn't trigger the categoriaId-based refresh
    ProductModel createTestProductWithoutCategoryId() {
      return ProductModel(
        id: 1,
        codigo: 'PROD1',
        nombre: 'Test Product',
        descripcion: 'Test Description',
        precioCompra: 10.0,
        precioVenta: 15.0,
        categoriaId: null, // Set to null to prevent the FetchProductsByCategoryEvent from being triggered
        imagenUrl: 'test_image_url.jpg',
      );
    }

    blocTest<ListProductsBloc, ListProductsState>(
      'emits states in order when adding product succeeds',
      build: () {
        final testProductWithoutCategory = createTestProductWithoutCategoryId();
        when(() => mockRepository.createProduct(any()))
            .thenAnswer((_) async => Result.ok(testProductWithoutCategory));
        return bloc;
      },
      act: (bloc) => bloc.add(AddProductEvent(product: testProduct)),
      expect: () => [
        isA<ListProductsLoading>(),
        isA<AddProductSuccessState>(),
      ],
      verify: (_) {
        verify(() => mockRepository.createProduct(any())).called(1);
      },
    );

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
      bloc.add(AddProductEvent(product: testProduct));
      
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