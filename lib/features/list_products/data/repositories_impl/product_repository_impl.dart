import 'package:dio/dio.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/list_products/domain/repositories/product_repository.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio dio;
  final String baseUrl;

  ProductRepositoryImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<List<ProductEntity>> getProductsByCategory(int categoryId) async {
    try {
      final response = await dio.get('$baseUrl/api/products/category/$categoryId');
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['data'];
        return productsJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Future<ProductEntity> getProductById(int productId) async {
    try {
      final response = await dio.get('$baseUrl/api/products/$productId');
      
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }
} 