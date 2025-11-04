import '../../doamin/entities/estadisticas_transacciones.dart';
import '../../doamin/repositories/repositorio_estadisticas.dart';
import '../datasources/estadisticas_data_source.dart';

class RepositorioEstadisticasImpl implements RepositorioEstadisticas {
  final EstadisticasDataSource dataSource;

  RepositorioEstadisticasImpl(this.dataSource);

  @override
  Future<EstadisticasTransacciones> obtenerEstadisticasTransacciones(
    String usuarioId, {
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final modelo = await dataSource.obtenerEstadisticasTransacciones(
        usuarioId,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      return modelo; // El modelo ya extiende la entidad
    } catch (e) {
      throw Exception('Error en repositorio de estadísticas: $e');
    }
  }

  @override
  Future<EstadisticasTransacciones> obtenerEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final modelo = await dataSource.obtenerEstadisticasPorPeriodo(
        usuarioId,
        fechaInicio,
        fechaFin,
      );
      return modelo;
    } catch (e) {
      throw Exception('Error en repositorio de estadísticas por período: $e');
    }
  }

  @override
  Future<EstadisticasTransacciones> obtenerEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  ) async {
    try {
      final modelo = await dataSource.obtenerEstadisticasMensuales(
        usuarioId,
        year,
        month,
      );
      return modelo;
    } catch (e) {
      throw Exception('Error en repositorio de estadísticas mensuales: $e');
    }
  }

  @override
  Future<EstadisticasTransacciones> obtenerEstadisticasAnuales(
    String usuarioId,
    int year,
  ) async {
    try {
      final modelo = await dataSource.obtenerEstadisticasAnuales(
        usuarioId,
        year,
      );
      return modelo;
    } catch (e) {
      throw Exception('Error en repositorio de estadísticas anuales: $e');
    }
  }
}
