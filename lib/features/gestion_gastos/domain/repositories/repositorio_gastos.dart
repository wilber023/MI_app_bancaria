import '../entities/gasto_entidad.dart';

abstract class RepositorioGastos {
  Future<List<GastoEntidad>> obtenerGastosUsuario(String usuarioId);

  Future<List<GastoEntidad>> obtenerGastosPorFecha(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  );

  Future<GastoEntidad?> crearGasto(GastoEntidad gasto);

  Future<GastoEntidad?> actualizarGasto(GastoEntidad gasto);

  Future<bool> eliminarGasto(String gastoId);

  Future<double> obtenerTotalGastado(String usuarioId);

  Future<Map<String, double>> obtenerGastosPorCategoria(String usuarioId);
}
