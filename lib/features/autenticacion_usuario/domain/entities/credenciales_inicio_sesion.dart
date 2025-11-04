class CredencialesInicioSesion {
  final String nombreUsuario;
  final String contrasena;

  const CredencialesInicioSesion({
    required this.nombreUsuario,
    required this.contrasena,
  });
  bool sonCredencialesValidas() {
    return nombreUsuario.trim().isNotEmpty &&
        contrasena.trim().isNotEmpty &&
        contrasena.length >= 6;
  }

  @override
  String toString() {
    return 'CredencialesInicioSesion{nombreUsuario: $nombreUsuario}';
  }
}
