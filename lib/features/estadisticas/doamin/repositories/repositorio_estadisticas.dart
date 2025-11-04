import '../entities/estadisticas_transacciones.dart';

abstract class RepositorioEstadisticas {
  Future<EstadisticasTransacciones> obtenerEstadisticasTransacciones(
    String usuarioId, {
    DateTime? fechaInicio,
    DateTime? fechaFin,
  });

  Future<EstadisticasTransacciones> obtenerEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  );

  Future<EstadisticasTransacciones> obtenerEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  );

  Future<EstadisticasTransacciones> obtenerEstadisticasAnuales(
    String usuarioId,
    int year,
  );
}
