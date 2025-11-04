class GastoEntidad {
  final String id;
  final String usuarioId;
  final double monto;
  final String categoria;
  final String descripcion;
  final DateTime fecha;
  final DateTime fechaCreacion;

  const GastoEntidad({
    required this.id,
    required this.usuarioId,
    required this.monto,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.fechaCreacion,
  });

  bool esGastoValido() {
    return monto > 0 &&
        categoria.isNotEmpty &&
        descripcion.isNotEmpty &&
        usuarioId.isNotEmpty;
  }

  String get montoFormateado => '\$${monto.toStringAsFixed(2)}';

  bool get esDeHoy {
    final hoy = DateTime.now();
    return fecha.year == hoy.year &&
        fecha.month == hoy.month &&
        fecha.day == hoy.day;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GastoEntidad && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
