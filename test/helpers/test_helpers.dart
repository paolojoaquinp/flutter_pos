import 'package:mocktail/mocktail.dart';
import 'package:flutter_pos/features/list_products/domain/repositories/product_repository.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/products_screen/domain/repositories/category_repository.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';
import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';

// Mock classes
class MockProductRepository extends Mock implements ProductRepository {}
class MockCategoryRepository extends Mock implements CategoryRepository {}
class MockDio extends Mock implements Dio {}

// Fallback value classes
class FakeCategoryModel extends Fake implements CategoryModel {}
class FakeProductModel extends Fake implements ProductModel {}

// Test data generators
class TestProductData {
  static List<ProductEntity> getTestProducts({int count = 3, int categoryId = 1}) {
    return List.generate(
      count,
      (index) => ProductModel(
        id: index + 1,
        codigo: 'PROD${index + 1}',
        nombre: 'Test Product ${index + 1}',
        descripcion: 'Test Description ${index + 1}',
        precioCompra: (10.0 * (index + 1)),
        precioVenta: (15.0 * (index + 1)),
        categoriaId: categoryId,
        imagenUrl: 'test_image_url.jpg',
      ),
    );
  }

  static ProductModel getSingleTestProduct({
    int id = 1,
    String name = 'Test Product',
    double purchasePrice = 10.0,
    double salePrice = 15.0,
    int categoryId = 1,
  }) {
    return ProductModel(
      id: id,
      codigo: 'PROD$id',
      nombre: name,
      descripcion: 'Test Description',
      precioCompra: purchasePrice,
      precioVenta: salePrice,
      categoriaId: categoryId,
      imagenUrl: 'test_image_url.jpg',
    );
  }

  static Result<ProductModel, DioException> getSuccessResult() {
    return Result.ok(getSingleTestProduct());
  }

  static Result<ProductModel, DioException> getErrorResult() {
    return Result.err(
      DioException(
        requestOptions: RequestOptions(path: '/test'),
        error: 'Test error',
        message: 'Test error message',
      ),
    );
  }
}

class TestCategoryData {
  static List<CategoryModel> getTestCategories({int count = 3}) {
    return List.generate(
      count,
      (index) => CategoryModel(
        id: index + 1,
        nombre: 'Test Category ${index + 1}',
        descripcion: 'Test Description ${index + 1}',
      ),
    );
  }

  static CategoryModel getSingleTestCategory({int id = 1, String name = 'Test Category'}) {
    return CategoryModel(
      id: id,
      nombre: name,
      descripcion: 'Test Description',
    );
  }
} 