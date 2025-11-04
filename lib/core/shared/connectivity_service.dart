import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ServicioConectividad {
  final Connectivity _conectividad;

  ServicioConectividad(this._conectividad);

  Future<bool> tieneConexionInternet() async {
    try {
      final resultado = await _conectividad.checkConnectivity();
      if (resultado == ConnectivityResult.none) {
        return false;
      }
      return await _verificarConexionReal();
    } catch (e) {
      return false;
    }
  }

  Future<bool> _verificarConexionReal() async {
    try {
      final resultado = await InternetAddress.lookup('google.com');
      return resultado.isNotEmpty && resultado[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
