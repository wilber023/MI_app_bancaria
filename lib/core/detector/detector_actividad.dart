import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../security/servicio_timeout_avanzado.dart';
import '../../features/autenticacion_usuario/presentation/providers/proveedor_estado_autenticacion.dart';

class DetectorActividad extends StatelessWidget {
  final Widget child;

  const DetectorActividad({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _registrarActividad(context),
      onPanDown: (_) => _registrarActividad(context),
      onScaleStart: (_) => _registrarActividad(context),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _registrarActividad(context),
        onPointerMove: (_) => _registrarActividad(context),
        onPointerUp: (_) => _registrarActividad(context),
        child: child,
      ),
    );
  }

  void _registrarActividad(BuildContext context) {
    try {
      final authProvider = Provider.of<ProveedorEstadoAutenticacion>(
        context,
        listen: false,
      );

      final servicioInactividad = Provider.of<ServicioInactividad>(
        context,
        listen: false,
      );

      // Informar al servicio sobre el estado de autenticación
      servicioInactividad.setUsuarioAutenticado(authProvider.estaAutenticado);

      if (authProvider.estaAutenticado) {
        servicioInactividad.resetTimer(context);
        debugPrint('👆 Actividad detectada - Timer reiniciado');
      }
    } catch (e) {
      debugPrint('⚠️ Error al registrar actividad: $e');
    }
  }
}
