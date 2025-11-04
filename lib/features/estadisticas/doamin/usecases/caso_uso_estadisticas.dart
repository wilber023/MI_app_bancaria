import '../entities/estadisticas_transacciones.dart';
import '../repositories/repositorio_estadisticas.dart';

class CasoUsoEstadisticas {
  final RepositorioEstadisticas _repositorio;

  CasoUsoEstadisticas(this._repositorio);

  Future<EstadisticasTransacciones> obtenerEstadisticasGenerales(
    String usuarioId,
  ) async {
    try {
      return await _repositorio.obtenerEstadisticasTransacciones(usuarioId);
    } catch (e) {
      throw Exception('Error al obtener estadísticas generales: $e');
    }
  }

  Future<EstadisticasTransacciones> obtenerEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      return await _repositorio.obtenerEstadisticasPorPeriodo(
        usuarioId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas por período: $e');
    }
  }

  Future<EstadisticasTransacciones> obtenerEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  ) async {
    try {
      return await _repositorio.obtenerEstadisticasMensuales(
        usuarioId,
        year,
        month,
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas mensuales: $e');
    }
  }

  Future<EstadisticasTransacciones> obtenerEstadisticasAnuales(
    String usuarioId,
    int year,
  ) async {
    try {
      return await _repositorio.obtenerEstadisticasAnuales(usuarioId, year);
    } catch (e) {
      throw Exception('Error al obtener estadísticas anuales: $e');
    }
  }

  Future<EstadisticasTransacciones> obtenerEstadisticasUltimoMes(
    String usuarioId,
  ) async {
    try {
      final ahora = DateTime.now();
      final inicioMes = DateTime(ahora.year, ahora.month, 1);
      final finMes = DateTime(ahora.year, ahora.month + 1, 0);

      return await _repositorio.obtenerEstadisticasPorPeriodo(
        usuarioId,
        inicioMes,
        finMes,
      );
    } catch (e) {
      throw Exception('Error al obtener estadísticas del último mes: $e');
    }
  }

  Future<EstadisticasTransacciones> obtenerEstadisticasUltimos3Meses(
    String usuarioId,
  ) async {
    try {
      final ahora = DateTime.now();
      final fechaInicio = DateTime(ahora.year, ahora.month - 2, 1);
      final fechaFin = DateTime(ahora.year, ahora.month + 1, 0);

      return await _repositorio.obtenerEstadisticasPorPeriodo(
        usuarioId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      throw Exception(
        'Error al obtener estadísticas de los últimos 3 meses: $e',
      );
    }
  }
}
