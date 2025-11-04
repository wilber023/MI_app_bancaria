import '../../domain/entities/gasto_entidad.dart';
import '../../domain/repositories/repositorio_gastos.dart';
import '../datasources/envio_datos_gastos.dart';

class ImplementacionRepositorioGastosRemoto implements RepositorioGastos {
  final EnvioDatosGastos _envioDatos = EnvioDatosGastos();

  @override
  Future<List<GastoEntidad>> obtenerGastosUsuario(String usuarioId) async {
    try {
      return await _envioDatos.obtenerGastosUsuario(usuarioId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GastoEntidad>> obtenerGastosPorFecha(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    try {
      final todosLosGastos = await _envioDatos.obtenerGastosUsuario(usuarioId);
      return todosLosGastos.where((gasto) {
        return gasto.fecha.isAfter(
              fechaInicio.subtract(const Duration(days: 1)),
            ) &&
            gasto.fecha.isBefore(fechaFin.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GastoEntidad?> crearGasto(GastoEntidad gasto) async {
    try {
      if (!gasto.esGastoValido()) {
        throw Exception('Datos del gasto no válidos');
      }
      return await _envioDatos.crearGasto(gasto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GastoEntidad?> actualizarGasto(GastoEntidad gasto) async {
    try {
      if (!gasto.esGastoValido()) {
        throw Exception('Datos del gasto no válidos');
      }
      return await _envioDatos.actualizarGasto(gasto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> eliminarGasto(String gastoId) async {
    try {
      return await _envioDatos.eliminarGasto(gastoId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> obtenerTotalGastado(String usuarioId) async {
    try {
      final gastos = await obtenerGastosUsuario(usuarioId);
      return gastos.fold<double>(0.0, (sum, gasto) => sum + gasto.monto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> obtenerGastosPorCategoria(
    String usuarioId,
  ) async {
    try {
      final gastos = await obtenerGastosUsuario(usuarioId);
      final Map<String, double> gastosPorCategoria = {};

      for (final gasto in gastos) {
        final categoria = gasto.categoria;
        gastosPorCategoria[categoria] =
            (gastosPorCategoria[categoria] ?? 0.0) + gasto.monto;
      }

      return gastosPorCategoria;
    } catch (e) {
      rethrow;
    }
  }
}
