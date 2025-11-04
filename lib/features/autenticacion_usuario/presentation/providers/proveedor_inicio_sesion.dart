import 'package:flutter/foundation.dart';
import '../../domain/entities/credenciales_inicio_sesion.dart';
import '../../domain/entities/usuario_entidad.dart';
import '../../domain/usecases/caso_uso_iniciar_sesion.dart';
import '../../../../core/application/estado_aplicacion.dart';

class ProveedorInicioSesion extends ChangeNotifier {
  final CasoUsoIniciarSesion _casoUsoIniciarSesion;
  final EstadoAplicacion _estadoAplicacion;

  ProveedorInicioSesion(this._casoUsoIniciarSesion, this._estadoAplicacion);

  bool _estaCargando = false;
  bool _inicioSesionExitoso = false;
  String? _mensajeError;
  UsuarioEntidad? _usuarioAutenticado;
  bool _mostrarContrasena = false;

  bool get estaCargando => _estaCargando;
  bool get inicioSesionExitoso => _inicioSesionExitoso;
  String? get mensajeError => _mensajeError;
  UsuarioEntidad? get usuarioAutenticado => _usuarioAutenticado;
  bool get mostrarContrasena => _mostrarContrasena;

  Future<void> iniciarProcesoInicioSesion({
    required String nombreUsuario,
    required String contrasena,
  }) async {
    _establecerEstadoCargando(true);
    _limpiarMensajesError();

    try {
      final credenciales = CredencialesInicioSesion(
        nombreUsuario: nombreUsuario.trim(),
        contrasena: contrasena,
      );

      final resultado = await _casoUsoIniciarSesion.ejecutarInicioSesion(
        credenciales,
      );

      if (resultado.esExitoso) {
        _usuarioAutenticado = resultado.usuario;
        _inicioSesionExitoso = true;
        _mensajeError = null;
        _estadoAplicacion.iniciarSesion();
      } else {
        _inicioSesionExitoso = false;
        _mensajeError = resultado.mensajeError;
        _usuarioAutenticado = null;
      }
    } catch (e) {
      _inicioSesionExitoso = false;
      _mensajeError = 'Error inesperado durante el inicio de sesión';
      _usuarioAutenticado = null;
    } finally {
      _establecerEstadoCargando(false);
    }
  }

  void alternarVisibilidadContrasena() {
    _mostrarContrasena = !_mostrarContrasena;
    notifyListeners();
  }

  void limpiarEstado() {
    _inicioSesionExitoso = false;
    _mensajeError = null;
    _usuarioAutenticado = null;
    _mostrarContrasena = false;
    notifyListeners();
  }

  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  bool validarCredencialesIngresadas({
    required String nombreUsuario,
    required String contrasena,
  }) {
    if (nombreUsuario.trim().isEmpty) {
      _mensajeError = 'El nombre de usuario es requerido';
      notifyListeners();
      return false;
    }

    if (contrasena.isEmpty) {
      _mensajeError = 'La contraseña es requerida';
      notifyListeners();
      return false;
    }

    if (contrasena.length < 6) {
      _mensajeError = 'La contraseña debe tener al menos 6 caracteres';
      notifyListeners();
      return false;
    }

    _limpiarMensajesError();
    return true;
  }

  void _establecerEstadoCargando(bool cargando) {
    _estaCargando = cargando;
    notifyListeners();
  }

  void _limpiarMensajesError() {
    _mensajeError = null;
    notifyListeners();
  }
}
