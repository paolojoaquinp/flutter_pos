import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';

import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Result<List<CategoryModel>, DioException>> getAllCategories();
  Future<Result<CategoryModel, DioException>> getCategoryById(String id);
  Future<Result<CategoryModel, DioException>> createCategory(CategoryModel category);
  Future<Result<CategoryModel, DioException>> updateCategory(String id, CategoryModel category);
  Future<Result<bool, DioException>> deleteCategory(String id);
}
