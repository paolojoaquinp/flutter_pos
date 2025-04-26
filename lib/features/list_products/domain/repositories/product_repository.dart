import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProductsByCategory(int categoryId);
  Future<ProductEntity> getProductById(int productId);
  Future<Result<ProductModel, DioException>> createProduct(ProductModel product);
} 