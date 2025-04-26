import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';

import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _dio;
  final String _baseUrl;

  CategoryRepositoryImpl({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  @override
  Future<Result<List<CategoryModel>, DioException>> getAllCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/api/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final categories = data.map((item) => CategoryModel.fromJson(item)).toList();
        return Result.ok(categories);
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$_baseUrl/api/categories'),
          error: 'Failed to load categories. Status: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Result<CategoryModel, DioException>> getCategoryById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/api/categories/$id');
      
      if (response.statusCode == 200) {
        return Result.ok(CategoryModel.fromJson(response.data));
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$_baseUrl/api/categories/$id'),
          error: 'Failed to load category. Status: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Result<CategoryModel, DioException>> createCategory(CategoryModel category) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/api/categories',
        data: category.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Result.ok(CategoryModel.fromJson(response.data));
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$_baseUrl/api/categories'),
          error: 'Failed to create category. Status: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Result<CategoryModel, DioException>> updateCategory(String id, CategoryModel category) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/api/categories/$id',
        data: category.toJson(),
      );
      
      if (response.statusCode == 200) {
        return Result.ok(CategoryModel.fromJson(response.data));
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$_baseUrl/api/categories/$id'),
          error: 'Failed to update category. Status: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    }
  }

  @override
  Future<Result<bool, DioException>> deleteCategory(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/api/categories/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Result.ok(true);
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$_baseUrl/api/categories/$id'),
          error: 'Failed to delete category. Status: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    }
  }
} 