class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.precioCompra,
    required this.precioVenta,
    this.categoriaId,
    this.imagenUrl,
    this.fechaCreacion,
  });

  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final double precioCompra;
  final double precioVenta;
  final int? categoriaId;
  final String? imagenUrl;
  final DateTime? fechaCreacion;
} 