import '../entities/usuario_entidad.dart';
import '../repositories/repositorio_autenticacion_usuario.dart';

class CasoUsoCerrarSesion {
  final RepositorioAutenticacionUsuario _repositorioAutenticacion;

  CasoUsoCerrarSesion(this._repositorioAutenticacion);

  Future<ResultadoCerrarSesion> ejecutarCierreSesion() async {
    try {
      final resultado = await _repositorioAutenticacion.cerrarSesionUsuario();

      if (resultado) {
        return ResultadoCerrarSesion.exito();
      } else {
        return ResultadoCerrarSesion.error('No se pudo cerrar la sesión');
      }
    } catch (e) {
      return ResultadoCerrarSesion.error(
        'Error al cerrar sesión: ${e.toString()}',
      );
    }
  }

  Future<bool> verificarUsuarioAutenticado() async {
    try {
      return await _repositorioAutenticacion.existeUsuarioAutenticado();
    } catch (e) {
      return false;
    }
  }

  Future<UsuarioEntidad?> obtenerUsuarioActual() async {
    try {
      return await _repositorioAutenticacion.obtenerUsuarioAutenticadoActual();
    } catch (e) {
      return null;
    }
  }
}

class ResultadoCerrarSesion {
  final bool esExitoso;
  final String? mensajeError;

  const ResultadoCerrarSesion._({required this.esExitoso, this.mensajeError});

  factory ResultadoCerrarSesion.exito() {
    return const ResultadoCerrarSesion._(esExitoso: true);
  }

  factory ResultadoCerrarSesion.error(String mensaje) {
    return ResultadoCerrarSesion._(esExitoso: false, mensajeError: mensaje);
  }
}
