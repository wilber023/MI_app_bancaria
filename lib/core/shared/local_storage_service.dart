import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServicioAlmacenamientoLocal {
  final SharedPreferences preferenciasPersistentes;
  final FlutterSecureStorage almacenamientoSeguro;

  ServicioAlmacenamientoLocal(
    this.preferenciasPersistentes,
    this.almacenamientoSeguro,
  );

  Future<void> guardarDatoSeguro(String clave, String valor) async {
    await almacenamientoSeguro.write(key: clave, value: valor);
  }

  Future<String?> obtenerDatoSeguro(String clave) async {
    return await almacenamientoSeguro.read(key: clave);
  }

  Future<void> eliminarDatoSeguro(String clave) async {
    await almacenamientoSeguro.delete(key: clave);
  }

  Future<void> guardarPreferencia(String clave, String valor) async {
    await preferenciasPersistentes.setString(clave, valor);
  }

  String? obtenerPreferencia(String clave) {
    return preferenciasPersistentes.getString(clave);
  }

  Future<void> guardarPreferenciaBooleana(String clave, bool valor) async {
    await preferenciasPersistentes.setBool(clave, valor);
  }

  bool obtenerPreferenciaBooleana(
    String clave, {
    bool valorPorDefecto = false,
  }) {
    return preferenciasPersistentes.getBool(clave) ?? valorPorDefecto;
  }

  Future<void> guardarPreferenciaEntera(String clave, int valor) async {
    await preferenciasPersistentes.setInt(clave, valor);
  }

  int obtenerPreferenciaEntera(String clave, {int valorPorDefecto = 0}) {
    return preferenciasPersistentes.getInt(clave) ?? valorPorDefecto;
  }

  Future<void> eliminarPreferencia(String clave) async {
    await preferenciasPersistentes.remove(clave);
  }

  bool contienePreferencia(String clave) {
    return preferenciasPersistentes.containsKey(clave);
  }

  Future<void> limpiarTodasLasPreferencias() async {
    await preferenciasPersistentes.clear();
  }

  Future<void> limpiarAlmacenamientoSeguro() async {
    await almacenamientoSeguro.deleteAll();
  }

  Future<void> limpiarTodosLosDatos() async {
    await limpiarTodasLasPreferencias();
    await limpiarAlmacenamientoSeguro();
  }
}
