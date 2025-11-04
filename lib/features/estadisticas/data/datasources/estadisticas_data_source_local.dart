import '../../../gestion_gastos/domain/entities/categoria_gasto.dart';
import '../../../gestion_gastos/domain/entities/gasto_entidad.dart';
import '../../../gestion_gastos/domain/repositories/repositorio_gastos.dart';
import '../models/modelo_estadisticas_transacciones.dart';
import 'estadisticas_data_source.dart';

class EstadisticasDataSourceLocal implements EstadisticasDataSource {
  final RepositorioGastos repositorioGastos;

  EstadisticasDataSourceLocal(this.repositorioGastos);

  @override
  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasTransacciones(
    String usuarioId, {
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      List<GastoEntidad> gastos;

      if (fechaInicio != null && fechaFin != null) {
        gastos = await repositorioGastos.obtenerGastosPorFecha(
          usuarioId,
          fechaInicio,
          fechaFin,
        );
      } else {
        gastos = await repositorioGastos.obtenerGastosUsuario(usuarioId);
      }

      return _procesarEstadisticas(
        gastos,
        fechaInicio ?? _obtenerFechaMinima(gastos),
        fechaFin ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  @override
  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    return obtenerEstadisticasTransacciones(
      usuarioId,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  @override
  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  ) async {
    final fechaInicio = DateTime(year, month, 1);
    final fechaFin = DateTime(year, month + 1, 0);

    return obtenerEstadisticasPorPeriodo(usuarioId, fechaInicio, fechaFin);
  }

  @override
  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasAnuales(
    String usuarioId,
    int year,
  ) async {
    final fechaInicio = DateTime(year, 1, 1);
    final fechaFin = DateTime(year, 12, 31);

    return obtenerEstadisticasPorPeriodo(usuarioId, fechaInicio, fechaFin);
  }

  ModeloEstadisticasTransacciones _procesarEstadisticas(
    List<GastoEntidad> gastos,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) {
    if (gastos.isEmpty) {
      return ModeloEstadisticasTransacciones(
        estadisticasPorCategoria: [],
        totalGastos: 0,
        totalTransacciones: 0,
        categoriaConMasGastos: _crearCategoriaVacia(),
        transaccionesPorCategoria: {},
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
    }

    // Agrupar gastos por categoría
    final Map<String, List<GastoEntidad>> transaccionesPorCategoria = {};
    final Map<String, double> montosPorCategoria = {};

    for (final gasto in gastos) {
      transaccionesPorCategoria[gasto.categoria] =
          (transaccionesPorCategoria[gasto.categoria] ?? [])..add(gasto);

      montosPorCategoria[gasto.categoria] =
          (montosPorCategoria[gasto.categoria] ?? 0) + gasto.monto;
    }

    final totalGastos = gastos.fold(0.0, (sum, gasto) => sum + gasto.monto);
    final totalTransacciones = gastos.length;

    // Crear estadísticas por categoría
    final List<ModeloEstadisticaCategoria> estadisticasPorCategoria = [];
    String categoriaConMayorGasto = '';
    double mayorMonto = 0;

    for (final categoria in montosPorCategoria.keys) {
      final monto = montosPorCategoria[categoria]!;
      final cantidadTransacciones =
          transaccionesPorCategoria[categoria]!.length;
      final porcentaje = (monto / totalGastos) * 100;

      // Buscar información de la categoría
      final categoriaInfo = CategoriaGasto.categoriasDefault.firstWhere(
        (cat) => cat.nombre == categoria,
        orElse: () => const CategoriaGasto(
          nombre: 'Otros',
          icono: '📝',
          color: 'FF9E9E9E',
        ),
      );

      final estadisticaCategoria = ModeloEstadisticaCategoria(
        categoria: categoria,
        monto: monto,
        cantidadTransacciones: cantidadTransacciones,
        porcentaje: porcentaje,
        color: categoriaInfo.color,
        icono: categoriaInfo.icono,
      );

      estadisticasPorCategoria.add(estadisticaCategoria);

      // Determinar categoría con más gastos
      if (monto > mayorMonto) {
        mayorMonto = monto;
        categoriaConMayorGasto = categoria;
      }
    }

    // Ordenar por monto descendiente
    estadisticasPorCategoria.sort((a, b) => b.monto.compareTo(a.monto));

    final categoriaConMasGastos = estadisticasPorCategoria.firstWhere(
      (cat) => cat.categoria == categoriaConMayorGasto,
      orElse: () => _crearCategoriaVacia(),
    );

    return ModeloEstadisticasTransacciones(
      estadisticasPorCategoria: estadisticasPorCategoria,
      totalGastos: totalGastos,
      totalTransacciones: totalTransacciones,
      categoriaConMasGastos: categoriaConMasGastos,
      transaccionesPorCategoria: transaccionesPorCategoria,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
    );
  }

  ModeloEstadisticaCategoria _crearCategoriaVacia() {
    return const ModeloEstadisticaCategoria(
      categoria: 'Sin datos',
      monto: 0.0,
      cantidadTransacciones: 0,
      porcentaje: 0.0,
      color: 'FF9E9E9E',
      icono: '📝',
    );
  }

  DateTime _obtenerFechaMinima(List<GastoEntidad> gastos) {
    if (gastos.isEmpty) return DateTime.now();

    DateTime fechaMinima = gastos.first.fecha;
    for (final gasto in gastos) {
      if (gasto.fecha.isBefore(fechaMinima)) {
        fechaMinima = gasto.fecha;
      }
    }
    return fechaMinima;
  }
}
