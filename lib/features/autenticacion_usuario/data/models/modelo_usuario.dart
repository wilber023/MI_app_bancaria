import '../../domain/entities/usuario_entidad.dart';

class ModeloUsuario extends UsuarioEntidad {
  const ModeloUsuario({
    required super.id,
    required super.nombreUsuario,
    required super.correoElectronico,
    required super.nombre,
    required super.fechaRegistro,
    super.estaActivo,
  });

  factory ModeloUsuario.fromJson(Map<String, dynamic> json) {
    return ModeloUsuario(
      id: json['id'] as String,
      nombreUsuario: json['nombreUsuario'] as String,
      correoElectronico: json['correoElectronico'] as String,
      nombre: json['nombre'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      estaActivo: json['estaActivo'] == 1 || json['estaActivo'] == true,
    );
  }

  factory ModeloUsuario.desdeJson(Map<String, dynamic> json) {
    return ModeloUsuario.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreUsuario': nombreUsuario,
      'correoElectronico': correoElectronico,
      'nombre': nombre,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'estaActivo': estaActivo,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  factory ModeloUsuario.desdeEntidad(UsuarioEntidad entidad) {
    return ModeloUsuario(
      id: entidad.id,
      nombreUsuario: entidad.nombreUsuario,
      correoElectronico: entidad.correoElectronico,
      nombre: entidad.nombre,
      fechaRegistro: entidad.fechaRegistro,
      estaActivo: entidad.estaActivo,
    );
  }

  UsuarioEntidad toEntity() {
    return UsuarioEntidad(
      id: id,
      nombreUsuario: nombreUsuario,
      correoElectronico: correoElectronico,
      nombre: nombre,
      fechaRegistro: fechaRegistro,
      estaActivo: estaActivo,
    );
  }

  UsuarioEntidad aEntidad() => toEntity();
}
