import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/usuario_entidad.dart';
import '../../domain/usecases/caso_uso_cerrar_sesion.dart';
import '../../../../core/application/estado_aplicacion.dart';

class ProveedorEstadoAutenticacion extends ChangeNotifier {
  final CasoUsoCerrarSesion _casoUsoCerrarSesion;
  final EstadoAplicacion _estadoAplicacion;

  ProveedorEstadoAutenticacion(
    this._casoUsoCerrarSesion,
    this._estadoAplicacion,
  );

  bool _estaAutenticado = false;
  bool _estaCargandoEstadoInicial = true;
  UsuarioEntidad? _usuarioActual;
  String? _mensajeError;

  bool get estaAutenticado => _estaAutenticado;
  bool get estaCargandoEstadoInicial => _estaCargandoEstadoInicial;
  UsuarioEntidad? get usuarioActual => _usuarioActual;
  String? get mensajeError => _mensajeError;

  Future<void> inicializarEstadoAutenticacion() async {
    _estaCargandoEstadoInicial = true;
    notifyListeners();

    try {
      final tieneUsuario = await _casoUsoCerrarSesion
          .verificarUsuarioAutenticado();

      if (tieneUsuario) {
        final usuario = await _casoUsoCerrarSesion.obtenerUsuarioActual();
        if (usuario != null) {
          _establecerUsuarioAutenticado(usuario);
        } else {
          _limpiarEstado();
        }
      } else {
        _limpiarEstado();
      }
    } catch (e) {
      _mensajeError = 'Error al verificar la autenticación.';
      _limpiarEstado();
    } finally {
      _estaCargandoEstadoInicial = false;
      notifyListeners();
    }
  }

  Future<void> iniciarSesion(UsuarioEntidad usuario) async {
    _establecerUsuarioAutenticado(usuario);
    _estadoAplicacion.iniciarSesion();
    debugPrint('Sesion iniciada - Timer de inactividad activo');
  }

  Future<bool> cerrarSesion() async {
    try {
      final resultado = await _casoUsoCerrarSesion.ejecutarCierreSesion();

      if (resultado.esExitoso) {
        _limpiarEstado();
        _estadoAplicacion.cerrarSesion();
        debugPrint('Sesion cerrada - Navegando al login');
        return true;
      } else {
        _mensajeError = resultado.mensajeError ?? 'Error al cerrar sesión.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _mensajeError = 'Error inesperado al cerrar sesión.';
      notifyListeners();
      return false;
    }
  }

  void actualizarInformacionUsuario(UsuarioEntidad usuarioActualizado) {
    if (_estaAutenticado && _usuarioActual?.id == usuarioActualizado.id) {
      _usuarioActual = usuarioActualizado;
      notifyListeners();
    }
  }

  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  void _establecerUsuarioAutenticado(UsuarioEntidad usuario) {
    _usuarioActual = usuario;
    _estaAutenticado = true;
    _mensajeError = null;
    notifyListeners();
  }

  void _limpiarEstado() {
    _usuarioActual = null;
    _estaAutenticado = false;
    _mensajeError = null;
    notifyListeners();
  }
}
