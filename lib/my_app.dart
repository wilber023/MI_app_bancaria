import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/di/injection_dependencie.dart';

import 'features/autenticacion_usuario/data/repositories/implementacion_repositorio_autenticacion_remoto.dart';
import 'features/autenticacion_usuario/domain/usecases/caso_uso_iniciar_sesion.dart';
import 'features/autenticacion_usuario/domain/usecases/caso_uso_registrar_usuario.dart';
import 'features/autenticacion_usuario/domain/usecases/caso_uso_cerrar_sesion.dart';
import 'features/autenticacion_usuario/presentation/providers/proveedor_inicio_sesion.dart';
import 'features/autenticacion_usuario/presentation/providers/proveedor_registro_usuario.dart';
import 'features/autenticacion_usuario/presentation/providers/proveedor_estado_autenticacion.dart';

import 'features/gestion_gastos/data/repositories/implementacion_repositorio_gastos_remoto.dart';
import 'features/gestion_gastos/domain/usecases/caso_uso_gestionar_gastos.dart';
import 'features/gestion_gastos/presentation/providers/proveedor_gastos.dart';

import 'features/estadisticas/data/datasources/estadisticas_data_source_local.dart';
import 'features/estadisticas/data/repositories/repositorio_estadisticas_impl.dart';
import 'features/estadisticas/doamin/usecases/caso_uso_estadisticas.dart';
import 'features/estadisticas/presentation/providers/proveedor_estadisticas.dart';

import 'core/providers/proveedor_tema.dart';
import 'core/security/servicio_timeout_avanzado.dart';
import 'core/detector/detector_actividad.dart';
import 'core/application/estado_aplicacion.dart';
import 'core/routes/routes_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _configurarProviders(),
      child: DetectorActividad(
        child: Consumer2<ProveedorTema, EstadoAplicacion>(
          builder: (context, proveedorTema, estadoApp, child) {
            final router = RouterAplicacion(estadoAplicacion: estadoApp);

            return MaterialApp.router(
              title: 'Mi App Bancaria',
              debugShowCheckedModeBanner: false,
              theme: proveedorTema.themeData,
              routerConfig: router.router,
            );
          },
        ),
      ),
    );
  }
}

List<SingleChildWidget> _configurarProviders() {
  final repositorioAuth = ImplementacionRepositorioAutenticacionRemoto();
  final repositorioGastos = ImplementacionRepositorioGastosRemoto();

  final dataSourceEstadisticas = EstadisticasDataSourceLocal(repositorioGastos);
  final repositorioEstadisticas = RepositorioEstadisticasImpl(
    dataSourceEstadisticas,
  );

  return [
    ChangeNotifierProvider<ProveedorTema>(create: (_) => ProveedorTema()),
    ChangeNotifierProvider<EstadoAplicacion>(create: (_) => EstadoAplicacion()),
    Provider<ServicioInactividad>(
      create: (context) => ServicioInactividad(
        almacenamientoLocal: LocalizadorServicios.servicioAlmacenamiento,
      ),
    ),
    ChangeNotifierProvider<ProveedorEstadoAutenticacion>(
      create: (context) => ProveedorEstadoAutenticacion(
        CasoUsoCerrarSesion(repositorioAuth),
        context.read<EstadoAplicacion>(),
      )..inicializarEstadoAutenticacion(),
    ),
    ChangeNotifierProvider<ProveedorInicioSesion>(
      create: (context) => ProveedorInicioSesion(
        CasoUsoIniciarSesion(repositorioAuth),
        context.read<EstadoAplicacion>(),
      ),
    ),
    ChangeNotifierProvider<ProveedorRegistroUsuario>(
      create: (context) => ProveedorRegistroUsuario(
        CasoUsoRegistrarUsuario(repositorioAuth),
        context.read<EstadoAplicacion>(),
      ),
    ),
    ChangeNotifierProvider<ProveedorGastos>(
      create: (_) => ProveedorGastos(CasoUsoGestionarGastos(repositorioGastos)),
    ),
    ChangeNotifierProvider<ProveedorEstadisticas>(
      create: (_) =>
          ProveedorEstadisticas(CasoUsoEstadisticas(repositorioEstadisticas)),
    ),
  ];
}
