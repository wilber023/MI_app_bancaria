import '../../domain/entities/gasto_entidad.dart';

class ModeloGasto extends GastoEntidad {
  const ModeloGasto({
    required super.id,
    required super.usuarioId,
    required super.monto,
    required super.categoria,
    required super.descripcion,
    required super.fecha,
    required super.fechaCreacion,
  });

  factory ModeloGasto.desdeJson(Map<String, dynamic> json) {
    return ModeloGasto(
      id: json['id'] as String,
      usuarioId: json['usuarioId'] as String,
      monto: (json['monto'] as num).toDouble(),
      categoria: json['categoria'] as String,
      descripcion: json['descripcion'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'monto': monto,
      'categoria': categoria,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  factory ModeloGasto.desdeEntidad(GastoEntidad entidad) {
    return ModeloGasto(
      id: entidad.id,
      usuarioId: entidad.usuarioId,
      monto: entidad.monto,
      categoria: entidad.categoria,
      descripcion: entidad.descripcion,
      fecha: entidad.fecha,
      fechaCreacion: entidad.fechaCreacion,
    );
  }

  GastoEntidad aEntidad() {
    return GastoEntidad(
      id: id,
      usuarioId: usuarioId,
      monto: monto,
      categoria: categoria,
      descripcion: descripcion,
      fecha: fecha,
      fechaCreacion: fechaCreacion,
    );
  }
}
