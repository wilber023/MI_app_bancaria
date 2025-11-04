import '../../domain/entities/credenciales_inicio_sesion.dart';
import '../../domain/entities/datos_registro_usuario.dart';
import '../../domain/entities/resultado_inicio_sesion.dart';
import '../../domain/entities/usuario_entidad.dart';
import '../models/modelo_usuario.dart';
import '../../../../core/network/api_fetch_http.dart';

class FuenteDatosAutenticacionRemota {
  Future<ResultadoInicioSesion> iniciarSesion(
    CredencialesInicioSesion credenciales,
  ) async {
    try {
      final data = await ApiFetchHttp.post('/api/usuarios/login', {
        'nombreUsuario': credenciales.nombreUsuario,
        'contrasena': credenciales.contrasena,
      });

      if (data['esExitoso'] == true && data['usuario'] != null) {
        final usuario = ModeloUsuario.fromJson(data['usuario']).toEntity();
        return ResultadoInicioSesion.exitoso(usuario);
      } else {
        return ResultadoInicioSesion.fallido(
          data['mensajeError'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      return ResultadoInicioSesion.fallido(
        'Error de conexión: ${e.toString()}',
      );
    }
  }

  Future<ResultadoInicioSesion> registrarUsuario(
    DatosRegistroUsuario datosRegistro,
  ) async {
    try {
      final requestData = {
        'nombre': datosRegistro.nombre,
        'nombreUsuario': datosRegistro.nombreUsuario,
        'correoElectronico': datosRegistro.correoElectronico,
        'contrasena': datosRegistro.contrasena,
      };

      final data = await ApiFetchHttp.post(
        '/api/usuarios/registro',
        requestData,
      );

      if (data['esExitoso'] == true && data['usuario'] != null) {
        final usuario = ModeloUsuario.fromJson(data['usuario']).toEntity();
        return ResultadoInicioSesion.exitoso(usuario);
      } else {
        return ResultadoInicioSesion.fallido(
          data['mensajeError'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      return ResultadoInicioSesion.fallido(
        'Error de conexión: ${e.toString()}',
      );
    }
  }

  Future<UsuarioEntidad?> obtenerUsuarioPorId(String id) async {
    try {
      final data = await ApiFetchHttp.get('/api/usuarios/$id');

      if (data.isNotEmpty) {
        return ModeloUsuario.fromJson(data).toEntity();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> existeNombreUsuario(String nombreUsuario) async {
    return false;
  }

  Future<bool> cerrarSesion(String usuarioId) async {
    return true;
  }
}
