import 'package:flutter/foundation.dart';

enum EstadoAutenticacion { desconocido, noAutenticado, autenticado }

class EstadoAplicacion extends ChangeNotifier {
  EstadoAutenticacion _estadoAutenticacion = EstadoAutenticacion.desconocido;

  EstadoAutenticacion get estadoAutenticacion => _estadoAutenticacion;

  void establecerEstadoAutenticacion(EstadoAutenticacion nuevoEstado) {
    if (_estadoAutenticacion != nuevoEstado) {
      _estadoAutenticacion = nuevoEstado;
      notifyListeners();
    }
  }

  void iniciarSesion() {
    establecerEstadoAutenticacion(EstadoAutenticacion.autenticado);
  }

  void cerrarSesion() {
    establecerEstadoAutenticacion(EstadoAutenticacion.noAutenticado);
  }

  void establecerDesconocido() {
    establecerEstadoAutenticacion(EstadoAutenticacion.desconocido);
  }
}
