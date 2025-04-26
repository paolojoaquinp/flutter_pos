import 'package:flutter_pos/features/products_screen/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProductsByCategory(int categoryId);
  Future<ProductEntity> getProductById(int productId);
} 