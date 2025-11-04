import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFetchHttp {
  static const String _baseUrl = 'http://100.26.172.198';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(url, headers: _headers);
      return _procesarRespuesta(response);
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final body = json.encode(data);

      final response = await http.post(url, headers: _headers, body: body);

      return _procesarRespuesta(response);
    } catch (e) {
      if (e is String) {
        throw e;
      } else {
        throw 'Error de conexión: $e';
      }
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final body = json.encode(data);

      final response = await http.put(url, headers: _headers, body: body);

      return _procesarRespuesta(response);
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.delete(url, headers: _headers);
      return _procesarRespuesta(response);
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Map<String, dynamic> _procesarRespuesta(http.Response response) {
    if (response.body.isEmpty) {
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    }

    try {
      final dynamic decodedData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decodedData is List) {
          return {'data': decodedData};
        }
        return decodedData as Map<String, dynamic>;
      } else {
        if (decodedData is Map<String, dynamic>) {
          return decodedData;
        } else {
          return {
            'esExitoso': false,
            'mensajeError': 'Error ${response.statusCode}: ${response.body}',
          };
        }
      }
    } catch (e) {
      if (e is FormatException) {
        throw 'Respuesta del servidor no es JSON válido: ${response.body}';
      } else {
        rethrow;
      }
    }
  }
}
