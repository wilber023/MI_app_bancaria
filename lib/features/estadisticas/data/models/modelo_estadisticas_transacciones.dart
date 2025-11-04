import '../../doamin/entities/estadisticas_transacciones.dart';
import '../../doamin/entities/estadistica_categoria.dart';
import '../../../gestion_gastos/domain/entities/gasto_entidad.dart';

class ModeloEstadisticasTransacciones extends EstadisticasTransacciones {
  const ModeloEstadisticasTransacciones({
    required super.estadisticasPorCategoria,
    required super.totalGastos,
    required super.totalTransacciones,
    required super.categoriaConMasGastos,
    required super.transaccionesPorCategoria,
    required super.fechaInicio,
    required super.fechaFin,
  });

  factory ModeloEstadisticasTransacciones.desdeJson(Map<String, dynamic> json) {
    return ModeloEstadisticasTransacciones(
      estadisticasPorCategoria: (json['estadisticasPorCategoria'] as List)
          .map((e) => ModeloEstadisticaCategoria.desdeJson(e))
          .toList(),
      totalGastos: (json['totalGastos'] as num).toDouble(),
      totalTransacciones: json['totalTransacciones'] as int,
      categoriaConMasGastos: ModeloEstadisticaCategoria.desdeJson(
        json['categoriaConMasGastos'],
      ),
      transaccionesPorCategoria: Map<String, List<GastoEntidad>>.from(
        json['transaccionesPorCategoria'],
      ),
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'estadisticasPorCategoria': estadisticasPorCategoria
          .map((e) => (e as ModeloEstadisticaCategoria).aJson())
          .toList(),
      'totalGastos': totalGastos,
      'totalTransacciones': totalTransacciones,
      'categoriaConMasGastos':
          (categoriaConMasGastos as ModeloEstadisticaCategoria).aJson(),
      'transaccionesPorCategoria': transaccionesPorCategoria,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
    };
  }
}

class ModeloEstadisticaCategoria extends EstadisticaCategoria {
  const ModeloEstadisticaCategoria({
    required super.categoria,
    required super.monto,
    required super.cantidadTransacciones,
    required super.porcentaje,
    required super.color,
    required super.icono,
  });

  factory ModeloEstadisticaCategoria.desdeJson(Map<String, dynamic> json) {
    return ModeloEstadisticaCategoria(
      categoria: json['categoria'] as String,
      monto: (json['monto'] as num).toDouble(),
      cantidadTransacciones: json['cantidadTransacciones'] as int,
      porcentaje: (json['porcentaje'] as num).toDouble(),
      color: json['color'] as String,
      icono: json['icono'] as String,
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'categoria': categoria,
      'monto': monto,
      'cantidadTransacciones': cantidadTransacciones,
      'porcentaje': porcentaje,
      'color': color,
      'icono': icono,
    };
  }
}
