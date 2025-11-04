import '../../../gestion_gastos/domain/entities/gasto_entidad.dart';
import 'estadistica_categoria.dart';

class EstadisticasTransacciones {
  final List<EstadisticaCategoria> estadisticasPorCategoria;
  final double totalGastos;
  final int totalTransacciones;
  final EstadisticaCategoria categoriaConMasGastos;
  final Map<String, List<GastoEntidad>> transaccionesPorCategoria;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  const EstadisticasTransacciones({
    required this.estadisticasPorCategoria,
    required this.totalGastos,
    required this.totalTransacciones,
    required this.categoriaConMasGastos,
    required this.transaccionesPorCategoria,
    required this.fechaInicio,
    required this.fechaFin,
  });

  // Obtener las top 5 categorías por monto
  List<EstadisticaCategoria> get top5CategoriasPorMonto {
    final lista = List<EstadisticaCategoria>.from(estadisticasPorCategoria);
    lista.sort((a, b) => b.monto.compareTo(a.monto));
    return lista.take(5).toList();
  }

  // Obtener las top 5 categorías por cantidad de transacciones
  List<EstadisticaCategoria> get top5CategoriasPorCantidad {
    final lista = List<EstadisticaCategoria>.from(estadisticasPorCategoria);
    lista.sort(
      (a, b) => b.cantidadTransacciones.compareTo(a.cantidadTransacciones),
    );
    return lista.take(5).toList();
  }

  // Promedio de gasto por transacción
  double get promedioGastoPorTransaccion {
    if (totalTransacciones == 0) return 0;
    return totalGastos / totalTransacciones;
  }

  // Formateo del total
  String get totalGastosFormateado => '\$${totalGastos.toStringAsFixed(2)}';

  // Formateo del promedio
  String get promedioFormateado =>
      '\$${promedioGastoPorTransaccion.toStringAsFixed(2)}';

  // Validar si hay datos para mostrar
  bool get tieneDatos =>
      totalTransacciones > 0 && estadisticasPorCategoria.isNotEmpty;
}
