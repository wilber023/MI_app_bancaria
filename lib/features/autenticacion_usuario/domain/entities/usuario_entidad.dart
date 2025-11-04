class UsuarioEntidad {
  final String id;
  final String nombreUsuario;
  final String correoElectronico;
  final String nombre;
  final DateTime fechaRegistro;
  final bool estaActivo;

  const UsuarioEntidad({
    required this.id,
    required this.nombreUsuario,
    required this.correoElectronico,
    required this.nombre,
    required this.fechaRegistro,
    this.estaActivo = true,
  });

  bool tieneInformacionCompleta() {
    return nombreUsuario.isNotEmpty &&
        correoElectronico.isNotEmpty &&
        nombre.isNotEmpty;
  }

  String get nombreCompleto => nombre;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsuarioEntidad &&
        other.id == id &&
        other.nombreUsuario == nombreUsuario &&
        other.correoElectronico == correoElectronico;
  }

  @override
  int get hashCode => Object.hash(id, nombreUsuario, correoElectronico);

  @override
  String toString() {
    return 'UsuarioEntidad{id: $id, nombreUsuario: $nombreUsuario, correoElectronico: $correoElectronico}';
  }
}
