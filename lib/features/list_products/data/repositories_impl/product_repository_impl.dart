import 'package:dio/dio.dart';
import 'package:oxidized/oxidized.dart';
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
  
  @override
  Future<Result<ProductModel, DioException>> createProduct(ProductModel product) async {
    try {
      final productModel = ProductModel(
              id: product.id,
              codigo: product.codigo,
              nombre: product.nombre,
              descripcion: product.descripcion,
              precioCompra: product.precioCompra,
              precioVenta: product.precioVenta,
              categoriaId: product.categoriaId,
              imagenUrl: product.imagenUrl,
              fechaCreacion: DateTime.now(),
            );
      
      final response = await dio.post(
        '$baseUrl/api/products',
        data: productModel.toJson(),
      );
      
      if (response.statusCode == 201) {
        return Result.ok(ProductModel.fromJson(response.data['data']));
      } else {
        return Result.err(DioException(
          requestOptions: RequestOptions(path: '$baseUrl/api/products'),
          error: 'Failed to create product: ${response.statusCode}',
        ));
      }
    } on DioException catch (e) {
      return Result.err(e);
    } catch (e) {
      return Result.err(DioException(
        requestOptions: RequestOptions(path: '$baseUrl/api/products'),
        error: 'Error creating product: $e',
      ));
    }
  }
} 