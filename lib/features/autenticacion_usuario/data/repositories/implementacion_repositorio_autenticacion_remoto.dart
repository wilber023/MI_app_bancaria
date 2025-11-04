import '../../domain/entities/credenciales_inicio_sesion.dart';
import '../../domain/entities/datos_registro_usuario.dart';
import '../../domain/entities/usuario_entidad.dart';
import '../../domain/repositories/repositorio_autenticacion_usuario.dart';
import '../datasources/fuente_datos_autenticacion_remota.dart';
import '../../../../core/security/servicio_almacenamiento_seguro.dart';

/// Repositorio de autenticación conectado a la API
class ImplementacionRepositorioAutenticacionRemoto
    implements RepositorioAutenticacionUsuario {
  final FuenteDatosAutenticacionRemota _fuenteDatos =
      FuenteDatosAutenticacionRemota();
  final ServicioAlmacenamientoSeguro _almacenamientoSeguro =
      ServicioAlmacenamientoSeguro();
  UsuarioEntidad? _usuarioAutenticado;

  @override
  Future<UsuarioEntidad?> iniciarSesionConCredenciales(
    CredencialesInicioSesion credenciales,
  ) async {
    try {
      final resultado = await _fuenteDatos.iniciarSesion(credenciales);

      if (resultado.esExitoso && resultado.usuario != null) {
        _usuarioAutenticado = resultado.usuario;
        // Asumimos que el ID del usuario es el token
        await _almacenamientoSeguro.guardarToken(resultado.usuario!.id);
        return resultado.usuario;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UsuarioEntidad?> registrarNuevoUsuario(
    DatosRegistroUsuario datosRegistro,
  ) async {
    try {
      final resultado = await _fuenteDatos.registrarUsuario(datosRegistro);

      if (resultado.esExitoso && resultado.usuario != null) {
        return resultado.usuario;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> cerrarSesionUsuario() async {
    try {
      final token = await _almacenamientoSeguro.leerToken();
      final usuarioId = token ?? _usuarioAutenticado?.id ?? '';

      final resultado = await _fuenteDatos.cerrarSesion(usuarioId);

      if (resultado) {
        _usuarioAutenticado = null;
        await _almacenamientoSeguro.eliminarToken();
      }

      return resultado;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> existeUsuarioAutenticado() async {
    final token = await _almacenamientoSeguro.leerToken();
    return token != null;
  }

  @override
  Future<UsuarioEntidad?> obtenerUsuarioAutenticadoActual() async {
    if (_usuarioAutenticado != null) return _usuarioAutenticado;

    final token = await _almacenamientoSeguro.leerToken();
    if (token != null) {
      // En una app real, aquí se haría una llamada a la API para obtener los datos del usuario
      // usando el token. Como no tenemos ese endpoint, creamos un usuario de placeholder.
      _usuarioAutenticado = UsuarioEntidad(
        id: token,
        nombreUsuario: 'usuario_cargado',
        correoElectronico: 'usuario@cargado.com',
        nombre: 'Usuario Cargado',
        fechaRegistro: DateTime.now(),
      );
      return _usuarioAutenticado;
    }
    return null;
  }

  @override
  Future<bool> verificarDisponibilidadNombreUsuario(
    String nombreUsuario,
  ) async {
    try {
      final existe = await _fuenteDatos.existeNombreUsuario(nombreUsuario);
      return !existe;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<bool> verificarDisponibilidadCorreoElectronico(String correo) async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
