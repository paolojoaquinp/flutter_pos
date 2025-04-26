import 'package:flutter_pos/features/products_screen/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
  });

  Map<String, dynamic> toJson() { 
    return {
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['categoria_id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
    );
  }

  CategoryModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}
