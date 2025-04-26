import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/config/api_config.dart';
import 'package:flutter_pos/features/list_products/presentation/page/list_products_screen.dart';
import 'package:flutter_pos/features/products_screen/data/repositories_impl/category_repository_impl.dart';
import 'package:flutter_pos/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:flutter_pos/features/products_screen/presentation/page/widgets/product_category_card.dart';
import 'package:flutter_pos/features/products_screen/presentation/page/widgets/stats_card_widget.dart';
import 'package:flutter_svg/svg.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsBloc>(
      create: (context) => ProductsBloc(
        categoryRepository: CategoryRepositoryImpl(
          dio: Dio(),
          baseUrl: ApiConfig.baseUrl,
        ),
      )..add(const FetchCategoriesInitialEvent()),
      child: const _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Productos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.content_paste_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats Cards
                  const Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          title: 'Total Productos',
                          value: '128',
                          percentage: '+8.00%',
                          isPositive: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StatsCard(
                          title: 'Productos en mano',
                          value: '2,350',
                          percentage: '+2.34%',
                          isPositive: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categorias',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        iconSize: 24,
                        icon: SvgPicture.asset('assets/svgs/icon-filter.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state is CategoriesLoadedState)
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: ListView.builder(
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final category = state.categories[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListProductsScreen(
                                    category: category,
                                  ),
                                ),
                              ),
                              child: ProductCategoryCard(
                                color: Colors.green.shade50,
                                title: category.nombre,
                                // positiveCount: 267,
                                // negativeCount: 140,
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Center(child: CircularProgressIndicator(),),
                    ),
                  // Product Categories List
                  // ProductCategoryCard(
                  //   color: Colors.green.shade50,
                  //   title: 'Escaneos',
                  //   positiveCount: 267,
                  //   negativeCount: 140,
                  // ),
                  // const SizedBox(height: 12),
                  // ProductCategoryCard(
                  //   color: Colors.blue.shade50,
                  //   title: 'Impresiones',
                  //   positiveCount: 124,
                  //   negativeCount: 87,
                  // ),
                  // const SizedBox(height: 12),
                  // ProductCategoryCard(
                  //   color: Colors.orange.shade50,
                  //   title: 'Folder',
                  //   positiveCount: 88,
                  //   negativeCount: 27,
                  //   tag: 'Pocas Existencia',
                  // ),
                  // const SizedBox(height: 12),
                  // ProductCategoryCard(
                  //   color: Colors.green.shade50,
                  //   title: 'Tramites en Linea',
                  //   positiveCount: 450,
                  //   negativeCount: 234,
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
