import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/config/api_config.dart';
import 'package:flutter_pos/features/list_products/data/repositories_impl/product_repository_impl.dart';
import 'package:flutter_pos/features/list_products/presentation/bloc/list_products_bloc.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';
import 'package:flutter_pos/features/list_products/presentation/page/product_form_screen.dart';

class ListProductsScreen extends StatelessWidget {
  static const String route = '/list-products';

  final CategoryModel category;

  const ListProductsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListProductsBloc>(
      create: (context) => ListProductsBloc(
        productRepository: ProductRepositoryImpl(
          dio: Dio(),
          baseUrl: ApiConfig.baseUrl,
        ),
      )..add(FetchProductsByCategoryEvent(categoryId: category.id)),
      child: _Page(
        category: category,
      ),
    );
  }
}
class _Page extends StatelessWidget {
  const _Page({
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListProductsBloc, ListProductsState>(
      listener: (context, state) {
        if(state is AddProductSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if(state is ListProductsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: _Body(category: category),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<ListProductsBloc, ListProductsState>(
            builder: (context, state) {
              if (state is ListProductsLoadedState) {
                return Text('Productos (${state.products.length})');
              }
              return const Text('Productos');
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.nombre,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to product form screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductFormScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                    ),
                    label: const Text('Añadir producto'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ListProductsBloc, ListProductsState>(
                builder: (context, state) {
                  if (state is ListProductsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ListProductsLoadedState) {
                    return state.products.isEmpty
                        ? const Center(
                            child: Text('No hay productos en esta categoría'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              return _ProductCard(product: state.products[index]);
                            },
                          );
                  } else if (state is ListProductsErrorState) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      );
  }
}
class _ProductCard extends StatelessWidget {
  final ProductEntity product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imagenUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imagenUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.codigo,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  if (product.descripcion != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      product.descripcion!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio venta',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${product.precioVenta.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio compra',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${product.precioCompra.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
