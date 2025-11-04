class DatosRegistroUsuario {
  final String nombreUsuario;
  final String correoElectronico;
  final String contrasena;
  final String confirmarContrasena;
  final String nombre;

  const DatosRegistroUsuario({
    required this.nombreUsuario,
    required this.correoElectronico,
    required this.contrasena,
    required this.confirmarContrasena,
    required this.nombre,
  });

  bool sonDatosValidosParaRegistro() {
    return _esNombreUsuarioValido() &&
        _esCorreoElectronicoValido() &&
        _esContrasenaValida() &&
        _lasContrasenasCoinciden() &&
        _sonNombresValidos();
  }

  bool _esNombreUsuarioValido() {
    return nombreUsuario.trim().length >= 3 &&
        nombreUsuario.trim().length <= 20;
  }

  bool _esCorreoElectronicoValido() {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(correoElectronico.trim());
  }

  bool _esContrasenaValida() {
    return contrasena.length >= 6 && contrasena.length <= 50;
  }

  bool _lasContrasenasCoinciden() {
    return contrasena == confirmarContrasena;
  }

  bool _sonNombresValidos() {
    return nombre.trim().isNotEmpty && nombre.trim().length >= 2;
  }

  List<String> obtenerErroresValidacion() {
    final errores = <String>[];

    if (!_esNombreUsuarioValido()) {
      errores.add('El nombre de usuario debe tener entre 3 y 20 caracteres');
    }

    if (!_esCorreoElectronicoValido()) {
      errores.add('El correo electrónico no tiene un formato válido');
    }

    if (!_esContrasenaValida()) {
      errores.add('La contraseña debe tener entre 6 y 50 caracteres');
    }

    if (!_lasContrasenasCoinciden()) {
      errores.add('Las contraseñas no coinciden');
    }

    if (!_sonNombresValidos()) {
      errores.add('El nombre debe tener al menos 2 caracteres');
    }

    return errores;
  }

  @override
  String toString() {
    return 'DatosRegistroUsuario{nombreUsuario: $nombreUsuario, correoElectronico: $correoElectronico, nombre: $nombre}';
  }
}
