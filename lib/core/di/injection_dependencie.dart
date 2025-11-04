import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../error/error_app.dart';
import '../security/encryption_service.dart';
import '../shared/local_storage_service.dart';
import '../shared/connectivity_service.dart';

final GetIt getIt = GetIt.instance;

class InyeccionDependencias {
  static Future<void> inicializar() async {
    await _registrarDependenciasExternas();
    _registrarNucleo();
    _registrarServicios();
    _registrarManejoErrores();

    print('Inyeccion de dependencias inicializada correctamente');
  }

  static Future<void> _registrarDependenciasExternas() async {
    final preferenciasPersistentes = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(preferenciasPersistentes);

    getIt.registerLazySingleton<Connectivity>(() => Connectivity());

    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      ),
    );
  }

  static void _registrarNucleo() {
    getIt.registerLazySingleton<http.Client>(() => http.Client());

    getIt.registerLazySingleton<Dio>(() {
      final dio = Dio();

      dio.options = BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => print('[DIO] $object'),
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onError: (DioException error, ErrorInterceptorHandler handler) {
            final manejadorErrores = getIt<ManejadorErroresGlobal>();
            manejadorErrores.manejarErrorDio(error);
            handler.next(error);
          },
        ),
      );

      return dio;
    });
  }

  static void _registrarServicios() {
    getIt.registerLazySingleton<ServicioConectividad>(
      () => ServicioConectividad(getIt<Connectivity>()),
    );

    getIt.registerLazySingleton<ServicioAlmacenamientoLocal>(
      () => ServicioAlmacenamientoLocal(
        getIt<SharedPreferences>(),
        getIt<FlutterSecureStorage>(),
      ),
    );

    getIt.registerLazySingleton<ServicioCifrado>(() => ServicioCifrado());
  }

  static void _registrarManejoErrores() {
    getIt.registerLazySingleton<ManejadorErroresGlobal>(
      () => ManejadorErroresGlobal(getIt<ServicioConectividad>()),
    );
  }

  static Future<void> limpiar() async {
    await getIt.reset();
    print('Dependencias limpiadas');
  }
}

extension AccesoDependencias on Object {
  T dependencia<T extends Object>() => getIt<T>();
  T obtener<T extends Object>() => getIt<T>();
}

class LocalizadorServicios {
  static ServicioAlmacenamientoLocal get servicioAlmacenamiento =>
      getIt<ServicioAlmacenamientoLocal>();
  static ServicioConectividad get servicioConectividad =>
      getIt<ServicioConectividad>();
  static ServicioCifrado get servicioCifrado => getIt<ServicioCifrado>();
  static ManejadorErroresGlobal get manejadorErrores =>
      getIt<ManejadorErroresGlobal>();
  static Dio get dio => getIt<Dio>();
  static SharedPreferences get preferencias => getIt<SharedPreferences>();
  static FlutterSecureStorage get almacenamientoSeguro =>
      getIt<FlutterSecureStorage>();
}
