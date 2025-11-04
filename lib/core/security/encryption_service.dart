import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class ServicioCifrado {
  late final Encrypter cifrador;
  late final IV vectorInicializacion;

  ServicioCifrado() {
    final clave = Key.fromSecureRandom(32);
    vectorInicializacion = IV.fromSecureRandom(16);
    cifrador = Encrypter(AES(clave));
  }

  String cifrarTexto(String textoPlano) {
    final cifrado = cifrador.encrypt(textoPlano, iv: vectorInicializacion);
    return cifrado.base64;
  }

  String descifrarTexto(String textoCifrado) {
    final cifrado = Encrypted.fromBase64(textoCifrado);
    return cifrador.decrypt(cifrado, iv: vectorInicializacion);
  }

  String cifrarMapaACadena(Map<String, dynamic> datos) {
    final cadenaJson = json.encode(datos);
    return cifrarTexto(cadenaJson);
  }

  Map<String, dynamic> descifrarCadenaAMapa(String cadenaCifrada) {
    final cadenaDescifrada = descifrarTexto(cadenaCifrada);
    return json.decode(cadenaDescifrada) as Map<String, dynamic>;
  }

  String generarHashSeguro(String entrada) {
    final bytes = utf8.encode(entrada);
    final cadenaBase64 = base64.encode(bytes);
    return cifrarTexto(cadenaBase64);
  }

  bool verificarHashSeguro(String entrada, String hash) {
    try {
      final hashDescifrado = descifrarTexto(hash);
      final bytes = utf8.encode(entrada);
      final base64Esperado = base64.encode(bytes);
      return hashDescifrado == base64Esperado;
    } catch (e) {
      return false;
    }
  }
}
