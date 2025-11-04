import 'package:flutter/foundation.dart';
import '../../doamin/entities/estadisticas_transacciones.dart';
import '../../doamin/usecases/caso_uso_estadisticas.dart';

enum PeriodoEstadisticas { general, ultimoMes, ultimos3Meses, personalizado }

class ProveedorEstadisticas extends ChangeNotifier {
  final CasoUsoEstadisticas _casoUso;

  ProveedorEstadisticas(this._casoUso);

  // Estado
  EstadisticasTransacciones? _estadisticas;
  bool _estaCargando = false;
  String? _mensajeError;
  PeriodoEstadisticas _periodoSeleccionado = PeriodoEstadisticas.general;
  DateTime? _fechaInicioPersonalizada;
  DateTime? _fechaFinPersonalizada;

  // Getters
  EstadisticasTransacciones? get estadisticas => _estadisticas;
  bool get estaCargando => _estaCargando;
  String? get mensajeError => _mensajeError;
  PeriodoEstadisticas get periodoSeleccionado => _periodoSeleccionado;
  DateTime? get fechaInicioPersonalizada => _fechaInicioPersonalizada;
  DateTime? get fechaFinPersonalizada => _fechaFinPersonalizada;

  // Métodos para cargar estadísticas
  Future<void> cargarEstadisticasGenerales(String usuarioId) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.general;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasGenerales(usuarioId);
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadisticasUltimoMes(String usuarioId) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.ultimoMes;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasUltimoMes(usuarioId);
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadisticasUltimos3Meses(String usuarioId) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.ultimos3Meses;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasUltimos3Meses(
        usuarioId,
      );
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadisticasPorPeriodo(
    String usuarioId,
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.personalizado;
    _fechaInicioPersonalizada = fechaInicio;
    _fechaFinPersonalizada = fechaFin;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasPorPeriodo(
        usuarioId,
        fechaInicio,
        fechaFin,
      );
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadisticasMensuales(
    String usuarioId,
    int year,
    int month,
  ) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.personalizado;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasMensuales(
        usuarioId,
        year,
        month,
      );
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadisticasAnuales(String usuarioId, int year) async {
    _estaCargando = true;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.personalizado;
    notifyListeners();

    try {
      _estadisticas = await _casoUso.obtenerEstadisticasAnuales(
        usuarioId,
        year,
      );
    } catch (e) {
      _mensajeError = e.toString();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  // Método para refrescar estadísticas según el período actual
  Future<void> refrescarEstadisticas(String usuarioId) async {
    switch (_periodoSeleccionado) {
      case PeriodoEstadisticas.general:
        await cargarEstadisticasGenerales(usuarioId);
        break;
      case PeriodoEstadisticas.ultimoMes:
        await cargarEstadisticasUltimoMes(usuarioId);
        break;
      case PeriodoEstadisticas.ultimos3Meses:
        await cargarEstadisticasUltimos3Meses(usuarioId);
        break;
      case PeriodoEstadisticas.personalizado:
        if (_fechaInicioPersonalizada != null &&
            _fechaFinPersonalizada != null) {
          await cargarEstadisticasPorPeriodo(
            usuarioId,
            _fechaInicioPersonalizada!,
            _fechaFinPersonalizada!,
          );
        } else {
          await cargarEstadisticasGenerales(usuarioId);
        }
        break;
    }
  }

  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  void limpiarDatos() {
    _estadisticas = null;
    _estaCargando = false;
    _mensajeError = null;
    _periodoSeleccionado = PeriodoEstadisticas.general;
    _fechaInicioPersonalizada = null;
    _fechaFinPersonalizada = null;
    notifyListeners();
  }

  // Getters de conveniencia
  String get nombrePeriodoActual {
    switch (_periodoSeleccionado) {
      case PeriodoEstadisticas.general:
        return 'Todas las transacciones';
      case PeriodoEstadisticas.ultimoMes:
        return 'Último mes';
      case PeriodoEstadisticas.ultimos3Meses:
        return 'Últimos 3 meses';
      case PeriodoEstadisticas.personalizado:
        if (_fechaInicioPersonalizada != null &&
            _fechaFinPersonalizada != null) {
          return 'Período personalizado';
        }
        return 'Período seleccionado';
    }
  }

  bool get tieneDatos => _estadisticas?.tieneDatos ?? false;
}
