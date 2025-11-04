class EstadisticaCategoria {
  final String categoria;
  final double monto;
  final int cantidadTransacciones;
  final double porcentaje;
  final String color;
  final String icono;

  const EstadisticaCategoria({
    required this.categoria,
    required this.monto,
    required this.cantidadTransacciones,
    required this.porcentaje,
    required this.color,
    required this.icono,
  });

  // Método para determinar si es la categoría con más gastos
  bool get esCategoriaConMasGastos => porcentaje > 0;

  // Formateo del monto
  String get montoFormateado => '\$${monto.toStringAsFixed(2)}';

  // Formateo del porcentaje
  String get porcentajeFormateado => '${porcentaje.toStringAsFixed(1)}%';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EstadisticaCategoria && other.categoria == categoria;
  }

  @override
  int get hashCode => categoria.hashCode;
}
