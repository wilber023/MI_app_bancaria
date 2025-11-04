import 'package:flutter/foundation.dart';
import '../../domain/entities/gasto_entidad.dart';
import '../../domain/usecases/caso_uso_gestionar_gastos.dart';

class ProveedorGastos extends ChangeNotifier {
  final CasoUsoGestionarGastos _casoUso;

  ProveedorGastos(this._casoUso);

  List<GastoEntidad> _gastos = [];
  bool _estaCargando = false;
  String? _mensajeError;
  ResumenGastos? _resumen;

  List<GastoEntidad> get gastos => _gastos;
  bool get estaCargando => _estaCargando;
  String? get mensajeError => _mensajeError;
  ResumenGastos? get resumen => _resumen;

  Future<void> cargarGastos(String usuarioId) async {
    _estaCargando = true;
    _mensajeError = null;
    notifyListeners();

    try {
      _gastos = await _casoUso.obtenerGastos(usuarioId);
      _resumen = await _casoUso.obtenerResumenGastos(usuarioId);
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<bool> crearGasto({
    required String usuarioId,
    required double monto,
    required String categoria,
    required String descripcion,
    DateTime? fecha,
  }) async {
    try {
      final gasto = await _casoUso.crearGasto(
        usuarioId: usuarioId,
        monto: monto,
        categoria: categoria,
        descripcion: descripcion,
        fecha: fecha,
      );

      if (gasto != null) {
        await cargarGastos(usuarioId);
        return true;
      }
      return false;
    } catch (e) {
      _mensajeError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarGasto(GastoEntidad gasto) async {
    try {
      final resultado = await _casoUso.actualizarGasto(gasto);
      if (resultado != null) {
        await cargarGastos(gasto.usuarioId);
        return true;
      }
      return false;
    } catch (e) {
      _mensajeError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarGasto(String gastoId, String usuarioId) async {
    try {
      final resultado = await _casoUso.eliminarGasto(gastoId);
      if (resultado) {
        await cargarGastos(usuarioId);
        return true;
      }
      return false;
    } catch (e) {
      _mensajeError = e.toString();
      notifyListeners();
      return false;
    }
  }

  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }
}
