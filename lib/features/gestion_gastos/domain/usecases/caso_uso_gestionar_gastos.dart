import '../entities/gasto_entidad.dart';
import '../repositories/repositorio_gastos.dart';

class CasoUsoGestionarGastos {
  final RepositorioGastos _repositorio;

  CasoUsoGestionarGastos(this._repositorio);

  Future<List<GastoEntidad>> obtenerGastos(String usuarioId) async {
    try {
      return await _repositorio.obtenerGastosUsuario(usuarioId);
    } catch (e) {
      throw Exception('Error al obtener gastos: $e');
    }
  }

  Future<GastoEntidad?> crearGasto({
    required String usuarioId,
    required double monto,
    required String categoria,
    required String descripcion,
    DateTime? fecha,
  }) async {
    try {
      final gasto = GastoEntidad(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        usuarioId: usuarioId,
        monto: monto,
        categoria: categoria,
        descripcion: descripcion,
        fecha: fecha ?? DateTime.now(),
        fechaCreacion: DateTime.now(),
      );

      if (!gasto.esGastoValido()) {
        throw Exception('Datos de gasto inválidos');
      }

      return await _repositorio.crearGasto(gasto);
    } catch (e) {
      throw Exception('Error al crear gasto: $e');
    }
  }

  Future<GastoEntidad?> actualizarGasto(GastoEntidad gasto) async {
    try {
      if (!gasto.esGastoValido()) {
        throw Exception('Datos de gasto inválidos');
      }
      return await _repositorio.actualizarGasto(gasto);
    } catch (e) {
      throw Exception('Error al actualizar gasto: $e');
    }
  }

  Future<bool> eliminarGasto(String gastoId) async {
    try {
      return await _repositorio.eliminarGasto(gastoId);
    } catch (e) {
      throw Exception('Error al eliminar gasto: $e');
    }
  }

  Future<ResumenGastos> obtenerResumenGastos(String usuarioId) async {
    try {
      final gastos = await _repositorio.obtenerGastosUsuario(usuarioId);
      final total = await _repositorio.obtenerTotalGastado(usuarioId);
      final gastosPorCategoria = await _repositorio.obtenerGastosPorCategoria(
        usuarioId,
      );

      return ResumenGastos(
        totalGastos: total,
        cantidadGastos: gastos.length,
        gastosPorCategoria: gastosPorCategoria,
        gastosRecientes: gastos.take(5).toList(),
      );
    } catch (e) {
      throw Exception('Error al obtener resumen: $e');
    }
  }
}

class ResumenGastos {
  final double totalGastos;
  final int cantidadGastos;
  final Map<String, double> gastosPorCategoria;
  final List<GastoEntidad> gastosRecientes;

  ResumenGastos({
    required this.totalGastos,
    required this.cantidadGastos,
    required this.gastosPorCategoria,
    required this.gastosRecientes,
  });
}
