import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/features/products_screen/domain/entities/category_entity.dart';
import 'package:flutter_pos/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:flutter_pos/features/products_screen/presentation/children/category_form/presentation/widgets/form_field_widget.dart';

class CategoryFormScreen extends StatelessWidget {
  CategoryFormScreen({
    super.key,
    this.onSubmit,
  });

  final Function(CategoryEntity)? onSubmit;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
            ),
            title: Text(
              'Nueva categoría',
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
                              label: 'Nombre',
                              hint: 'Ej: Impresiones',
                              controller: _nameController,
                            ),
                            SizedBox(height: 16),
                            FormFieldWidget(
                              label: 'Descripción',
                              hint: 'Ej: Servicios de impresión de documentos',
                              maxLines: 4,
                              controller: _descriptionController,
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
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                // Create a new CategoryEntity from the form data
                                // Note: typically the ID would be generated on the server side
                                // Here we're passing 0 as a placeholder
                                final newCategory = CategoryEntity(
                                  id: 0,
                                  nombre: _nameController.text,
                                  descripcion: _descriptionController.text,
                                );

                                // Add the event to the bloc
                                context.read<ProductsBloc>().add(
                                      AddCategoryEvent(category: newCategory),
                                    );
                                
                                // Call the onSubmit callback if provided
                                // if (onSubmit != null) {
                                //   onSubmit!(newCategory);
                                // }

                                // Navigate back
                                Navigator.pop(context);
                              }
                            },
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
      },
    );
  }
}
