import '../models/modelo_estadisticas_transacciones.dart';

abstract class EstadisticasDataSource {
  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasTransacciones(
    String usuarioId, {
    DateTime? fechaInicio,
    DateTime? fechaFin,
  });

  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  );

  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  );

  Future<ModeloEstadisticasTransacciones> obtenerEstadisticasAnuales(
    String usuarioId,
    int year,
  );
}
