import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/local_storage_service.dart';

class ServicioInactividad {
  Timer? _inactivityTimer;
  static const int _inactivityTimeout = 300;
  bool _usuarioAutenticado = false;
  final ServicioAlmacenamientoLocal _almacenamientoSeguro;

  ServicioInactividad({required ServicioAlmacenamientoLocal almacenamientoLocal})
      : _almacenamientoSeguro = almacenamientoLocal;

  void setUsuarioAutenticado(bool autenticado) {
    _usuarioAutenticado = autenticado;
    if (!autenticado) {
      stopTimer();
    }
  }

  Future<void> iniciarSesionConToken(String token) async {
    try {
      await _almacenamientoSeguro.guardarDatoSeguro('token_usuario', token);
      await _almacenamientoSeguro.guardarPreferenciaEntera('timeout_inactividad', _inactivityTimeout);
      _usuarioAutenticado = true;
      debugPrint('Sesión iniciada con token guardado');
    } catch (e) {
      debugPrint('Error al guardar datos de sesión: $e');
    }
  }

  void resetTimer(BuildContext context) {
    if (!_usuarioAutenticado) return;

    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(
      const Duration(seconds: _inactivityTimeout),
      () async {
        if (_usuarioAutenticado) {
          debugPrint(
            'Sesión expirada por inactividad ($_inactivityTimeout segundos)',
          );

          // Limpiar datos almacenados antes de cerrar sesión
          await _limpiarDatosAlmacenados();

          // Marcar como no autenticado para detener timers
          _usuarioAutenticado = false;

          // Navegar al login usando go_router
          if (context.mounted) {
            context.go('/login');
            
            // Mostrar mensaje de sesión expirada
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sesión cerrada por inactividad'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
    debugPrint(
      'Timer de inactividad reiniciado ($_inactivityTimeout segundos)',
    );
  }

  // Método para limpiar datos almacenados
  Future<void> _limpiarDatosAlmacenados() async {
    try {
      await _almacenamientoSeguro.eliminarDatoSeguro('token_usuario');
      await _almacenamientoSeguro.eliminarPreferencia('timeout_inactividad');
      debugPrint('Datos limpiados');
    } catch (e) {
      debugPrint('Error al limpiar datos: $e');
    }
  }

  // Método para verificar sesión existente al iniciar app
  Future<bool> verificarSesionExistente() async {
    try {
      final token = await _almacenamientoSeguro.obtenerDatoSeguro('token_usuario');
      final timeout = _almacenamientoSeguro.obtenerPreferenciaEntera('timeout_inactividad');

      if (token != null && timeout > 0) {
        _usuarioAutenticado = true;
        debugPrint('Sesión encontrada con token y timeout');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error al verificar sesión: $e');
      return false;
    }
  }

  void stopTimer() {
    _inactivityTimer?.cancel();
    debugPrint('⏹️ Timer de inactividad detenido');
  }

  void dispose() {
    _inactivityTimer?.cancel();
  }
}
