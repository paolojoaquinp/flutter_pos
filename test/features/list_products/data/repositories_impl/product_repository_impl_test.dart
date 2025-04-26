import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/list_products/data/repositories_impl/product_repository_impl.dart';
import 'package:oxidized/oxidized.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRepositoryImpl repository;
  late MockDio mockDio;
  const String baseUrl = 'http://192.168.1.13:3000';

  setUp(() {
    mockDio = MockDio();
    repository = ProductRepositoryImpl(
      dio: mockDio,
      baseUrl: baseUrl,
    );
  });

  group('getProductsByCategory', () {
    final expectedProducts = [
      {
        'producto_id': 1,
        'codigo': 'PROD1',
        'nombre': 'Product 1',
        'descripcion': 'Description 1',
        'precio_compra': '10.0',
        'precio_venta': '15.0',
        'categoria_id': 1,
        'imagen_url': 'image1.jpg',
        'fecha_creacion': '2023-01-01T00:00:00Z',
      },
      {
        'producto_id': 2,
        'codigo': 'PROD2',
        'nombre': 'Product 2',
        'descripcion': 'Description 2',
        'precio_compra': '20.0',
        'precio_venta': '25.0',
        'categoria_id': 1,
        'imagen_url': 'image2.jpg',
        'fecha_creacion': '2023-01-02T00:00:00Z',
      },
    ];

    test('should return list of products when the call is successful', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/products/category/1')).thenAnswer(
        (_) async => Response(
          data: {'data': expectedProducts},
          statusCode: 200,
          requestOptions: RequestOptions(path: '$baseUrl/api/products/category/1'),
        ),
      );

      // Act
      final result = await repository.getProductsByCategory(1);

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].nombre, 'Product 1');
      expect(result[1].id, 2);
      expect(result[1].nombre, 'Product 2');
      verify(() => mockDio.get('$baseUrl/api/products/category/1')).called(1);
    });

    test('should throw exception when the call fails', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/products/category/1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '$baseUrl/api/products/category/1'),
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getProductsByCategory(1),
        throwsA(isA<Exception>()),
      );
      verify(() => mockDio.get('$baseUrl/api/products/category/1')).called(1);
    });
  });

  group('getProductById', () {
    final expectedProduct = {
      'producto_id': 1,
      'codigo': 'PROD1',
      'nombre': 'Product 1',
      'descripcion': 'Description 1',
      'precio_compra': '10.0',
      'precio_venta': '15.0',
      'categoria_id': 1,
      'imagen_url': 'image1.jpg',
      'fecha_creacion': '2023-01-01T00:00:00Z',
    };

    test('should return a product when the call is successful', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/products/1')).thenAnswer(
        (_) async => Response(
          data: expectedProduct,
          statusCode: 200,
          requestOptions: RequestOptions(path: '$baseUrl/api/products/1'),
        ),
      );

      // Act
      final result = await repository.getProductById(1);

      // Assert
      expect(result.id, 1);
      expect(result.nombre, 'Product 1');
      expect(result.precioCompra, 10.0);
      expect(result.precioVenta, 15.0);
      verify(() => mockDio.get('$baseUrl/api/products/1')).called(1);
    });

    test('should throw exception when the call fails', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/products/1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '$baseUrl/api/products/1'),
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => repository.getProductById(1),
        throwsA(isA<Exception>()),
      );
      verify(() => mockDio.get('$baseUrl/api/products/1')).called(1);
    });
  });

  group('createProduct', () {
    final productToCreate = ProductModel(
      id: 0, // ID will be assigned by server
      codigo: 'NEWPROD',
      nombre: 'New Product',
      descripcion: 'New Description',
      precioCompra: 30.0,
      precioVenta: 40.0,
      categoriaId: 1,
      imagenUrl: 'new_image.jpg',
    );

    test('should return success result when product is created successfully', () async {
      // Arrange
      final createdProductResponse = {
        'data': {
          'producto_id': 3,
          'codigo': 'NEWPROD',
          'nombre': 'New Product',
          'descripcion': 'New Description',
          'precio_compra': '30.0',
          'precio_venta': '40.0',
          'categoria_id': 1,
          'imagen_url': 'new_image.jpg',
          'fecha_creacion': '2023-01-03T00:00:00Z',
        }
      };

      when(() => mockDio.post(
            '$baseUrl/api/products',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          data: createdProductResponse,
          statusCode: 201,
          requestOptions: RequestOptions(path: '$baseUrl/api/products'),
        ),
      );

      // Act
      final result = await repository.createProduct(productToCreate);

      // Assert
      expect(result.isOk(), isTrue);
      final product = result.unwrap();
      expect(product.id, 3);
      expect(product.nombre, 'New Product');
      verify(() => mockDio.post(
            '$baseUrl/api/products',
            data: any(named: 'data'),
          )).called(1);
    });

    test('should return error result when product creation fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/products'),
        error: 'Network error',
        message: 'Failed to create product',
      );

      when(() => mockDio.post(
            '$baseUrl/api/products',
            data: any(named: 'data'),
          )).thenThrow(dioError);

      // Act
      final result = await repository.createProduct(productToCreate);

      // Assert
      expect(result.isErr(), isTrue);
      expect(result.unwrapErr().message, 'Failed to create product');
      verify(() => mockDio.post(
            '$baseUrl/api/products',
            data: any(named: 'data'),
          )).called(1);
    });
  });
} 