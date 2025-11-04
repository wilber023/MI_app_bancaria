import 'package:dio/dio.dart';
import '../shared/connectivity_service.dart';

abstract class ExcepcionApp implements Exception {
  final String mensaje;
  final String? detalles;

  ExcepcionApp(this.mensaje, [this.detalles]);

  @override
  String toString() => mensaje;
}

class ExcepcionSinConexionInternet extends ExcepcionApp {
  ExcepcionSinConexionInternet() : super('No hay conexion a internet');
}

class ExcepcionTiempoEsperaConexion extends ExcepcionApp {
  ExcepcionTiempoEsperaConexion()
    : super('Tiempo de espera agotado para la conexion');
}

class ExcepcionTiempoEsperaEnvio extends ExcepcionApp {
  ExcepcionTiempoEsperaEnvio()
    : super('Tiempo de espera agotado al enviar datos');
}

class ExcepcionTiempoEsperaRecepcion extends ExcepcionApp {
  ExcepcionTiempoEsperaRecepcion()
    : super('Tiempo de espera agotado al recibir datos');
}

class ExcepcionSolicitudCancelada extends ExcepcionApp {
  ExcepcionSolicitudCancelada() : super('Solicitud cancelada');
}

class ExcepcionErrorConexion extends ExcepcionApp {
  ExcepcionErrorConexion() : super('Error de conexion al servidor');
}

class ExcepcionCertificadoInvalido extends ExcepcionApp {
  ExcepcionCertificadoInvalido() : super('Certificado de seguridad invalido');
}

class ExcepcionRedDesconocida extends ExcepcionApp {
  ExcepcionRedDesconocida(String detalles)
    : super('Error de red desconocido', detalles);
}

class ExcepcionSolicitudIncorrecta extends ExcepcionApp {
  ExcepcionSolicitudIncorrecta(String mensaje)
    : super('Solicitud incorrecta: $mensaje');
}

class ExcepcionNoAutorizado extends ExcepcionApp {
  ExcepcionNoAutorizado(String mensaje) : super('No autorizado: $mensaje');
}

class ExcepcionAccesoDenegado extends ExcepcionApp {
  ExcepcionAccesoDenegado(String mensaje) : super('Acceso denegado: $mensaje');
}

class ExcepcionNoEncontrado extends ExcepcionApp {
  ExcepcionNoEncontrado(String mensaje) : super('No encontrado: $mensaje');
}

class ExcepcionErrorServidor extends ExcepcionApp {
  ExcepcionErrorServidor(String mensaje)
    : super('Error interno del servidor: $mensaje');
}

class ManejadorErroresGlobal {
  final ServicioConectividad servicioConectividad;

  ManejadorErroresGlobal(this.servicioConectividad);

  void manejarErrorDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        _registrarError('Tiempo de conexion agotado');
        break;
      case DioExceptionType.sendTimeout:
        _registrarError('Tiempo de envio agotado');
        break;
      case DioExceptionType.receiveTimeout:
        _registrarError('Tiempo de recepcion agotado');
        break;
      case DioExceptionType.badResponse:
        _registrarError('Respuesta incorrecta: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        _registrarError('Solicitud cancelada');
        break;
      case DioExceptionType.connectionError:
        _registrarError('Error de conexion');
        break;
      case DioExceptionType.badCertificate:
        _registrarError('Error de certificado');
        break;
      case DioExceptionType.unknown:
        _registrarError('Error desconocido: ${error.message}');
        break;
    }
  }

  void manejarExcepcionGeneral(Exception excepcion) {
    if (excepcion is ExcepcionApp) {
      _registrarError('Excepcion de aplicacion: ${excepcion.mensaje}');
    } else {
      _registrarError('Excepcion general: ${excepcion.toString()}');
    }
  }

  Future<void> manejarErrorConectividad() async {
    final tieneConexion = await servicioConectividad.tieneConexionInternet();
    if (!tieneConexion) {
      _registrarError('No hay conexion a internet disponible');
    }
  }

  void _registrarError(String mensaje) {
    print('[ERROR] $mensaje');
  }

  String obtenerMensajeErrorLegible(Exception excepcion) {
    if (excepcion is ExcepcionSinConexionInternet) {
      return 'Verifica tu conexion a internet e intenta nuevamente';
    } else if (excepcion is ExcepcionTiempoEsperaConexion) {
      return 'La conexion esta tardando demasiado. Intenta nuevamente';
    } else if (excepcion is ExcepcionNoAutorizado) {
      return 'Tu sesion ha expirado. Inicia sesion nuevamente';
    } else if (excepcion is ExcepcionNoEncontrado) {
      return 'El recurso solicitado no fue encontrado';
    } else if (excepcion is ExcepcionErrorServidor) {
      return 'Error del servidor. Intenta mas tarde';
    } else if (excepcion is ExcepcionApp) {
      return excepcion.mensaje;
    } else {
      return 'Ha ocurrido un error inesperado';
    }
  }
}
