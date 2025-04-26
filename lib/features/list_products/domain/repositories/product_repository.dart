import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProductsByCategory(int categoryId);
  Future<ProductEntity> getProductById(int productId);
} 