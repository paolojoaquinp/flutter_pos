import 'package:flutter_pos/features/list_products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.codigo,
    required super.nombre,
    super.descripcion,
    required super.precioCompra,
    required super.precioVenta,
    super.categoriaId,
    super.imagenUrl,
    super.fechaCreacion,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['producto_id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioCompra: double.parse(json['precio_compra'].toString()),
      precioVenta: double.parse(json['precio_venta'].toString()),
      categoriaId: json['categoria_id'],
      imagenUrl: json['imagen_url'],
      fechaCreacion: json['fecha_creacion'] != null 
          ? DateTime.parse(json['fecha_creacion']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto_id': id,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'categoria_id': categoriaId,
      'imagen_url': imagenUrl,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
    };
  }
} 