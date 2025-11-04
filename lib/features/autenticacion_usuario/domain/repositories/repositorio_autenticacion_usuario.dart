import '../entities/credenciales_inicio_sesion.dart';
import '../entities/datos_registro_usuario.dart';
import '../entities/usuario_entidad.dart';

abstract class RepositorioAutenticacionUsuario {
  Future<UsuarioEntidad?> iniciarSesionConCredenciales(
    CredencialesInicioSesion credenciales,
  );

  Future<UsuarioEntidad?> registrarNuevoUsuario(
    DatosRegistroUsuario datosRegistro,
  );

  Future<bool> cerrarSesionUsuario();

  Future<bool> existeUsuarioAutenticado();

  Future<UsuarioEntidad?> obtenerUsuarioAutenticadoActual();

  Future<bool> verificarDisponibilidadNombreUsuario(String nombreUsuario);

  Future<bool> verificarDisponibilidadCorreoElectronico(String correo);
}
