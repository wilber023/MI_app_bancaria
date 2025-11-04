import 'package:flutter/foundation.dart';
import '../../domain/entities/datos_registro_usuario.dart';
import '../../domain/entities/usuario_entidad.dart';
import '../../domain/usecases/caso_uso_registrar_usuario.dart';
import '../../../../core/application/estado_aplicacion.dart';

class ProveedorRegistroUsuario extends ChangeNotifier {
  final CasoUsoRegistrarUsuario _casoUsoRegistrarUsuario;
  final EstadoAplicacion _estadoAplicacion;

  ProveedorRegistroUsuario(
    this._casoUsoRegistrarUsuario,
    this._estadoAplicacion,
  );

  bool _estaCargando = false;
  bool _registroExitoso = false;
  String? _mensajeError;
  UsuarioEntidad? _usuarioCreado;
  bool _mostrarContrasena = false;
  bool _mostrarConfirmarContrasena = false;
  List<String> _erroresValidacion = [];

  bool get estaCargando => _estaCargando;
  bool get registroExitoso => _registroExitoso;
  String? get mensajeError => _mensajeError;
  UsuarioEntidad? get usuarioCreado => _usuarioCreado;
  bool get mostrarContrasena => _mostrarContrasena;
  bool get mostrarConfirmarContrasena => _mostrarConfirmarContrasena;
  List<String> get erroresValidacion => _erroresValidacion;

  Future<void> iniciarProcesoRegistroUsuario({
    required String nombreUsuario,
    required String correoElectronico,
    required String contrasena,
    required String confirmarContrasena,
    required String nombre,
  }) async {
    _establecerEstadoCargando(true);
    _limpiarMensajesError();

    try {
      final datosRegistro = DatosRegistroUsuario(
        nombreUsuario: nombreUsuario.trim(),
        correoElectronico: correoElectronico.trim(),
        contrasena: contrasena,
        confirmarContrasena: confirmarContrasena,
        nombre: nombre.trim(),
      );
      final resultado = await _casoUsoRegistrarUsuario.ejecutarRegistroUsuario(
        datosRegistro,
      );

      if (resultado.esExitoso) {
        _usuarioCreado = resultado.usuario;
        _registroExitoso = true;
        _mensajeError = null;
        _erroresValidacion = [];
        _estadoAplicacion.iniciarSesion();
      } else {
        _registroExitoso = false;
        _mensajeError = resultado.mensajeError;
        _usuarioCreado = null;

        if (resultado.mensajeError?.contains('Datos de registro inválidos') ==
            true) {
          _erroresValidacion = _extraerErroresDeValidacion(datosRegistro);
        }
      }
    } catch (e) {
      _registroExitoso = false;
      _mensajeError = 'Error inesperado durante el registro';
      _usuarioCreado = null;
      _erroresValidacion = [];
    } finally {
      _establecerEstadoCargando(false);
    }
  }

  void alternarVisibilidadContrasena() {
    _mostrarContrasena = !_mostrarContrasena;
    notifyListeners();
  }

  void alternarVisibilidadConfirmarContrasena() {
    _mostrarConfirmarContrasena = !_mostrarConfirmarContrasena;
    notifyListeners();
  }

  void limpiarEstado() {
    _registroExitoso = false;
    _mensajeError = null;
    _usuarioCreado = null;
    _mostrarContrasena = false;
    _mostrarConfirmarContrasena = false;
    _erroresValidacion = [];
    notifyListeners();
  }

  void limpiarError() {
    _mensajeError = null;
    _erroresValidacion = [];
    notifyListeners();
  }

  bool validarDatosRegistroIngresados({
    required String nombreUsuario,
    required String correoElectronico,
    required String contrasena,
    required String confirmarContrasena,
    required String nombre,
  }) {
    final errores = <String>[];

    if (nombreUsuario.trim().isEmpty) {
      errores.add('El nombre de usuario es requerido');
    } else if (nombreUsuario.trim().length < 3) {
      errores.add('El nombre de usuario debe tener al menos 3 caracteres');
    }

    if (correoElectronico.trim().isEmpty) {
      errores.add('El correo electrónico es requerido');
    } else if (!_esCorreoValido(correoElectronico)) {
      errores.add('El correo electrónico no tiene un formato válido');
    }

    if (contrasena.isEmpty) {
      errores.add('La contraseña es requerida');
    } else if (contrasena.length < 6) {
      errores.add('La contraseña debe tener al menos 6 caracteres');
    }

    if (confirmarContrasena.isEmpty) {
      errores.add('Debe confirmar la contraseña');
    } else if (contrasena != confirmarContrasena) {
      errores.add('Las contraseñas no coinciden');
    }

    if (nombre.trim().isEmpty) {
      errores.add('El nombre es requerido');
    }

    if (errores.isNotEmpty) {
      _erroresValidacion = errores;
      _mensajeError = errores.first;
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
    _erroresValidacion = [];
    notifyListeners();
  }

  bool _esCorreoValido(String correo) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(correo.trim());
  }

  List<String> _extraerErroresDeValidacion(DatosRegistroUsuario datos) {
    return datos.obtenerErroresValidacion();
  }
}
