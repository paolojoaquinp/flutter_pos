import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';
import 'package:flutter_pos/features/products_screen/data/repositories_impl/category_repository_impl.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late CategoryRepositoryImpl repository;
  late MockDio mockDio;
  const String baseUrl = 'https://api.example.com';

  setUp(() {
    mockDio = MockDio();
    repository = CategoryRepositoryImpl(
      dio: mockDio,
      baseUrl: baseUrl,
    );
  });

  group('getAllCategories', () {
    final expectedCategories = [
      {
        'categoria_id': 1,
        'nombre': 'Category 1',
        'descripcion': 'Description 1',
      },
      {
        'categoria_id': 2,
        'nombre': 'Category 2',
        'descripcion': 'Description 2',
      },
    ];

    test('should return list of categories when API call is successful', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/categories')).thenAnswer(
        (_) async => Response(
          data: {'data': expectedCategories},
          statusCode: 200,
          requestOptions: RequestOptions(path: '$baseUrl/api/categories'),
        ),
      );

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isOk(), true);
      final categories = result.unwrap();
      expect(categories.length, 2);
      expect(categories[0].id, 1);
      expect(categories[0].nombre, 'Category 1');
      expect(categories[1].id, 2);
      expect(categories[1].nombre, 'Category 2');
      verify(() => mockDio.get('$baseUrl/api/categories')).called(1);
    });

    test('should return error result when API call fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/categories'),
        error: 'Network error',
        message: 'Failed to fetch categories',
      );

      when(() => mockDio.get('$baseUrl/api/categories')).thenThrow(dioError);

      // Act
      final result = await repository.getAllCategories();

      // Assert
      expect(result.isErr(), true);
      verify(() => mockDio.get('$baseUrl/api/categories')).called(1);
    });
  });

  group('createCategory', () {
    final categoryToCreate = CategoryModel(
      id: 0,
      nombre: 'New Category',
      descripcion: 'New Description',
    );

    final createdCategoryResponse = {
      'categoria_id': 3,
      'nombre': 'New Category',
      'descripcion': 'New Description',
    };

    test('should return a category when creation is successful', () async {
      // Arrange
      when(() => mockDio.post(
            '$baseUrl/api/categories',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          data: createdCategoryResponse,
          statusCode: 201,
          requestOptions: RequestOptions(path: '$baseUrl/api/categories'),
        ),
      );

      // Act
      final result = await repository.createCategory(categoryToCreate);

      // Assert
      expect(result.isOk(), true);
      final createdCategory = result.unwrap();
      expect(createdCategory.id, 3);
      expect(createdCategory.nombre, 'New Category');
      expect(createdCategory.descripcion, 'New Description');
      verify(() => mockDio.post(
            '$baseUrl/api/categories',
            data: any(named: 'data'),
          )).called(1);
    });

    test('should return error result when creation fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/categories'),
        error: 'Network error',
        message: 'Failed to create category',
      );

      when(() => mockDio.post(
            '$baseUrl/api/categories',
            data: any(named: 'data'),
          )).thenThrow(dioError);

      // Act
      final result = await repository.createCategory(categoryToCreate);

      // Assert
      expect(result.isErr(), true);
      expect(result.unwrapErr().message, 'Failed to create category');
      verify(() => mockDio.post(
            '$baseUrl/api/categories',
            data: any(named: 'data'),
          )).called(1);
    });
  });

  group('getCategoryById', () {
    const categoryId = '1';
    final expectedCategory = {
      'categoria_id': 1,
      'nombre': 'Category 1',
      'descripcion': 'Description 1',
    };

    test('should return a category when the call is successful', () async {
      // Arrange
      when(() => mockDio.get('$baseUrl/api/categories/$categoryId')).thenAnswer(
        (_) async => Response(
          data: expectedCategory,
          statusCode: 200,
          requestOptions: RequestOptions(path: '$baseUrl/api/categories/$categoryId'),
        ),
      );

      // Act
      final result = await repository.getCategoryById(categoryId);

      // Assert
      expect(result.isOk(), true);
      final category = result.unwrap();
      expect(category.id, 1);
      expect(category.nombre, 'Category 1');
      expect(category.descripcion, 'Description 1');
      verify(() => mockDio.get('$baseUrl/api/categories/$categoryId')).called(1);
    });

    test('should return error result when the call fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/categories/$categoryId'),
        error: 'Network error',
        message: 'Failed to fetch category',
      );

      when(() => mockDio.get('$baseUrl/api/categories/$categoryId')).thenThrow(dioError);

      // Act
      final result = await repository.getCategoryById(categoryId);

      // Assert
      expect(result.isErr(), true);
      verify(() => mockDio.get('$baseUrl/api/categories/$categoryId')).called(1);
    });
  });

  group('deleteCategory', () {
    const categoryId = '1';

    test('should return true when deletion is successful', () async {
      // Arrange
      when(() => mockDio.delete('$baseUrl/api/categories/$categoryId')).thenAnswer(
        (_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(path: '$baseUrl/api/categories/$categoryId'),
        ),
      );

      // Act
      final result = await repository.deleteCategory(categoryId);

      // Assert
      expect(result.isOk(), true);
      expect(result.unwrap(), true);
      verify(() => mockDio.delete('$baseUrl/api/categories/$categoryId')).called(1);
    });

    test('should return error result when deletion fails', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/categories/$categoryId'),
        error: 'Network error',
        message: 'Failed to delete category',
      );

      when(() => mockDio.delete('$baseUrl/api/categories/$categoryId')).thenThrow(dioError);

      // Act
      final result = await repository.deleteCategory(categoryId);

      // Assert
      expect(result.isErr(), true);
      verify(() => mockDio.delete('$baseUrl/api/categories/$categoryId')).called(1);
    });
  });
} 