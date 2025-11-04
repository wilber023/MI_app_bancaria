import 'usuario_entidad.dart';

class ResultadoInicioSesion {
  final bool esExitoso;
  final UsuarioEntidad? usuario;
  final String? mensajeError;

  const ResultadoInicioSesion({
    required this.esExitoso,
    this.usuario,
    this.mensajeError,
  });

  factory ResultadoInicioSesion.exitoso(UsuarioEntidad usuario) {
    return ResultadoInicioSesion(
      esExitoso: true,
      usuario: usuario,
      mensajeError: null,
    );
  }

  factory ResultadoInicioSesion.fallido(String mensajeError) {
    return ResultadoInicioSesion(
      esExitoso: false,
      usuario: null,
      mensajeError: mensajeError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResultadoInicioSesion &&
        other.esExitoso == esExitoso &&
        other.usuario == usuario &&
        other.mensajeError == mensajeError;
  }

  @override
  int get hashCode => Object.hash(esExitoso, usuario, mensajeError);

  @override
  String toString() {
    return 'ResultadoInicioSesion(esExitoso: $esExitoso, usuario: $usuario, mensajeError: $mensajeError)';
  }
}
