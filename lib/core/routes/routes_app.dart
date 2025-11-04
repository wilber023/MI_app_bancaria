import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../application/estado_aplicacion.dart';
import '../router/rutas.dart';
import '../presentation/pantalla_splash.dart';
import '../presentation/pantalla_configuracion.dart';
import '../../features/autenticacion_usuario/presentation/pages/pagina_inicio_sesion.dart';
import '../../features/autenticacion_usuario/presentation/pages/pagina_registro_usuario.dart';
import '../../features/gestion_gastos/presentation/pages/pagina_gastos.dart';
import '../../features/estadisticas/presentation/pages/pagina_estadisticas.dart';

class RouterAplicacion {
  final EstadoAplicacion estadoAplicacion;

  RouterAplicacion({required this.estadoAplicacion});

  late final GoRouter router = GoRouter(
    initialLocation: RutasAplicacion.splashRuta,
    refreshListenable: estadoAplicacion,
    routes: [
      GoRoute(
        path: RutasAplicacion.splashRuta,
        name: RutasAplicacion.splash,
        builder: (context, state) => const PantallaSplash(),
      ),
      GoRoute(
        path: RutasAplicacion.inicioSesionRuta,
        name: RutasAplicacion.inicioSesion,
        builder: (context, state) => const PaginaInicioSesion(),
      ),
      GoRoute(
        path: RutasAplicacion.registroRuta,
        name: RutasAplicacion.registro,
        builder: (context, state) => const PaginaRegistroUsuario(),
      ),
      GoRoute(
        path: RutasAplicacion.gastosRuta,
        name: RutasAplicacion.gastos,
        builder: (context, state) => const PaginaGastos(),
        routes: [
          GoRoute(
            path: 'configuracion',
            name: RutasAplicacion.configuracion,
            builder: (context, state) => const PantallaConfiguracion(),
          ),
        ],
      ),
      GoRoute(
        path: RutasAplicacion.estadisticasRuta,
        name: RutasAplicacion.estadisticas,
        builder: (context, state) => const PaginaEstadisticas(),
      ),
    ],
    redirect: (context, state) {
      final estadoAuth = estadoAplicacion.estadoAutenticacion;
      final ubicacionActual = state.matchedLocation;

      switch (estadoAuth) {
        case EstadoAutenticacion.desconocido:
          return ubicacionActual == RutasAplicacion.splashRuta
              ? null
              : RutasAplicacion.splashRuta;

        case EstadoAutenticacion.noAutenticado:
          if (ubicacionActual == RutasAplicacion.gastosRuta ||
              ubicacionActual == RutasAplicacion.estadisticasRuta ||
              ubicacionActual == RutasAplicacion.configuracionRuta) {
            return RutasAplicacion.inicioSesionRuta;
          }
          return ubicacionActual == RutasAplicacion.inicioSesionRuta ||
                  ubicacionActual == RutasAplicacion.registroRuta
              ? null
              : RutasAplicacion.inicioSesionRuta;

        case EstadoAutenticacion.autenticado:
          if (ubicacionActual == RutasAplicacion.inicioSesionRuta ||
              ubicacionActual == RutasAplicacion.registroRuta ||
              ubicacionActual == RutasAplicacion.splashRuta) {
            return RutasAplicacion.gastosRuta;
          }
          return null;
      }
    },
  );
}

class NavegacionHelper {
  static void irA(
    BuildContext context,
    String nombreRuta, {
    Map<String, String>? parametros,
  }) {
    context.goNamed(nombreRuta, pathParameters: parametros ?? {});
  }

  static void empujar(
    BuildContext context,
    String nombreRuta, {
    Map<String, String>? parametros,
  }) {
    context.pushNamed(nombreRuta, pathParameters: parametros ?? {});
  }

  static void reemplazar(
    BuildContext context,
    String nombreRuta, {
    Map<String, String>? parametros,
  }) {
    context.pushReplacementNamed(nombreRuta, pathParameters: parametros ?? {});
  }

  static void regresar(BuildContext context) {
    context.pop();
  }

  static void irAInicioSesion(BuildContext context) {
    context.goNamed(RutasAplicacion.inicioSesion);
  }

  static void irARegistro(BuildContext context) {
    context.goNamed(RutasAplicacion.registro);
  }

  static void irAGastos(BuildContext context) {
    context.goNamed(RutasAplicacion.gastos);
  }

  static void irAEstadisticas(BuildContext context) {
    context.goNamed(RutasAplicacion.estadisticas);
  }

  static void irAConfiguracion(BuildContext context) {
    context.goNamed(RutasAplicacion.configuracion);
  }
}
