import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/config/api_config.dart';
import 'package:flutter_pos/features/list_products/data/models/product_model.dart';
import 'package:flutter_pos/features/list_products/data/repositories_impl/product_repository_impl.dart';
import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';
import 'package:flutter_pos/features/list_products/presentation/bloc/list_products_bloc.dart';
import 'package:flutter_pos/features/products_screen/data/models/category_model.dart';
import 'package:flutter_pos/features/products_screen/presentation/children/category_form/presentation/widgets/form_field_widget.dart';

class ProductFormScreen extends StatelessWidget {
  static const String route = '/product-form';

  final CategoryModel category;

  const ProductFormScreen({
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
      ),
      child: _ProductFormPage(category: category),
    );
  }
}

class _ProductFormPage extends StatefulWidget {
  final CategoryModel category;

  const _ProductFormPage({
    required this.category,
  });

  @override
  State<_ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<_ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Nuevo producto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'Código',
                          hint: 'Ej: PROD-001',
                          controller: _codeController,
                        ),
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'Nombre',
                          hint: 'Ej: Smartphone XYZ',
                          controller: _nameController,
                        ),
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'Descripción',
                          hint: 'Ej: Smartphone de última generación',
                          maxLines: 4,
                          controller: _descriptionController,
                        ),
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'Precio de compra',
                          hint: 'Ej: 300.00',
                          controller: _purchasePriceController,
                        ),
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'Precio de venta',
                          hint: 'Ej: 450.00',
                          controller: _salePriceController,
                        ),
                        SizedBox(height: 16),
                        FormFieldWidget(
                          label: 'URL de imagen (opcional)',
                          hint: 'Ej: https://example.com/images/product.jpg',
                          controller: _imageUrlController,
                        ),
                        SizedBox(
                          height: 130,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -10),
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 5,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: FilledButton(
                        onPressed: _saveProduct,
                        style: FilledButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          "Guardar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate numeric fields
      double? purchasePrice = double.tryParse(_purchasePriceController.text);
      double? salePrice = double.tryParse(_salePriceController.text);

      if (purchasePrice == null || salePrice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Los precios deben ser valores numéricos válidos'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create the product entity (ID will be assigned by the server)
      final newProduct = ProductModel(
        id: 0, // ID assigned by server
        codigo: _codeController.text,
        nombre: _nameController.text,
        descripcion: _descriptionController.text,
        precioCompra: purchasePrice,
        precioVenta: salePrice,
        categoriaId: widget.category.id,
        imagenUrl: _imageUrlController.text.isNotEmpty 
            ? _imageUrlController.text 
            : null,
      );

      // Add the event to create the product
      context.read<ListProductsBloc>().add(
        AddProductEvent(product: newProduct),
      );
      
      // Navigate back after adding product
      Navigator.pop(context);      
    }
  }
} 