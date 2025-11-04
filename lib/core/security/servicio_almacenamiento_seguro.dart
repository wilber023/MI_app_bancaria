import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServicioAlmacenamientoSeguro {
  final _storage = const FlutterSecureStorage();

  Future<void> guardarToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> leerToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> eliminarToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> guardarTimeout(int timeout) async {
    await _storage.write(key: 'timeout_duration', value: timeout.toString());
  }

  Future<int?> leerTimeout() async {
    final timeoutString = await _storage.read(key: 'timeout_duration');
    if (timeoutString != null) {
      return int.tryParse(timeoutString);
    }
    return null;
  }
}
