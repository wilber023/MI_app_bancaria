import '../entities/credenciales_inicio_sesion.dart';
import '../entities/resultado_inicio_sesion.dart';
import '../repositories/repositorio_autenticacion_usuario.dart';

class CasoUsoIniciarSesion {
  final RepositorioAutenticacionUsuario _repositorioAutenticacion;

  CasoUsoIniciarSesion(this._repositorioAutenticacion);

  Future<ResultadoInicioSesion> ejecutarInicioSesion(
    CredencialesInicioSesion credenciales,
  ) async {
    try {
      if (!credenciales.sonCredencialesValidas()) {
        return ResultadoInicioSesion.fallido(
          'Las credenciales proporcionadas no son válidas',
        );
      }

      final usuario = await _repositorioAutenticacion
          .iniciarSesionConCredenciales(credenciales);

      if (usuario == null) {
        return ResultadoInicioSesion.fallido(
          'Usuario o contraseña incorrectos',
        );
      }

      if (!usuario.estaActivo) {
        return ResultadoInicioSesion.fallido(
          'La cuenta de usuario está desactivada',
        );
      }

      return ResultadoInicioSesion.exitoso(usuario);
    } catch (e) {
      return ResultadoInicioSesion.fallido(
        'Error durante el inicio de sesión: ${e.toString()}',
      );
    }
  }
}
