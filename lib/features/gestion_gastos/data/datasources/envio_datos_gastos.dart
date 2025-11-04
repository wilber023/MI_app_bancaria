import '../../domain/entities/gasto_entidad.dart';
import '../models/modelo_gasto.dart';
import '../../../../core/network/api_fetch_http.dart';

class EnvioDatosGastos {
  Future<List<GastoEntidad>> obtenerGastosUsuario(String usuarioId) async {
    try {
      final respuesta = await ApiFetchHttp.get(
        '/api/gastos/usuario/$usuarioId',
      );

      if (respuesta['data'] != null && respuesta['data'] is List) {
        final List<dynamic> gastosJson = respuesta['data'];
        return gastosJson
            .map((json) => ModeloGasto.desdeJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error al cargar los gastos: $e');
    }
  }

  Future<GastoEntidad> crearGasto(GastoEntidad gasto) async {
    try {
      final gastoModelo = ModeloGasto.desdeEntidad(gasto);
      final datosEnvio = gastoModelo.aJson();
      datosEnvio.remove('id');

      final respuesta = await ApiFetchHttp.post('/api/gastos', datosEnvio);

      if (respuesta.containsKey('id')) {
        return ModeloGasto.desdeJson(respuesta);
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GastoEntidad> actualizarGasto(GastoEntidad gasto) async {
    try {
      final gastoModelo = ModeloGasto.desdeEntidad(gasto);
      final datosEnvio = gastoModelo.aJson();

      final respuesta = await ApiFetchHttp.put(
        '/api/gastos/${gasto.id}',
        datosEnvio,
      );

      if (respuesta.containsKey('id')) {
        return ModeloGasto.desdeJson(respuesta);
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      throw Exception('Error al actualizar el gasto: $e');
    }
  }

  Future<bool> eliminarGasto(String gastoId) async {
    try {
      final respuesta = await ApiFetchHttp.delete('/api/gastos/$gastoId');
      return respuesta['mensaje'] != null;
    } catch (e) {
      throw Exception('Error al eliminar el gasto: $e');
    }
  }
}
