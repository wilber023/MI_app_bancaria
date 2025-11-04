import '../entities/datos_registro_usuario.dart';
import '../entities/resultado_inicio_sesion.dart';
import '../repositories/repositorio_autenticacion_usuario.dart';

class CasoUsoRegistrarUsuario {
  final RepositorioAutenticacionUsuario _repositorioAutenticacion;

  CasoUsoRegistrarUsuario(this._repositorioAutenticacion);

  Future<ResultadoInicioSesion> ejecutarRegistroUsuario(
    DatosRegistroUsuario datosRegistro,
  ) async {
    try {
      if (!datosRegistro.sonDatosValidosParaRegistro()) {
        final errores = datosRegistro.obtenerErroresValidacion();
        return ResultadoInicioSesion.fallido(
          'Datos de registro incorrectos: ${errores.join(', ')}',
        );
      }

      final nombreUsuarioDisponible = await _repositorioAutenticacion
          .verificarDisponibilidadNombreUsuario(datosRegistro.nombreUsuario);

      if (!nombreUsuarioDisponible) {
        return ResultadoInicioSesion.fallido(
          'El nombre de usuario ya está en uso',
        );
      }

      final correoDisponible = await _repositorioAutenticacion
          .verificarDisponibilidadCorreoElectronico(
            datosRegistro.correoElectronico,
          );

      if (!correoDisponible) {
        return ResultadoInicioSesion.fallido(
          'El correo electrónico ya está registrado',
        );
      }

      final usuarioCreado = await _repositorioAutenticacion
          .registrarNuevoUsuario(datosRegistro);

      if (usuarioCreado == null) {
        return ResultadoInicioSesion.fallido(
          'No se pudo crear el usuario. Intenta nuevamente.',
        );
      }

      return ResultadoInicioSesion.exitoso(usuarioCreado);
    } catch (e) {
      return ResultadoInicioSesion.fallido(
        'Error durante el registro: ${e.toString()}',
      );
    }
  }
}
