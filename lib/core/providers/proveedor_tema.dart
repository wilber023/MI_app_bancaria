import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/theme/app_tema_base.dart';
import '../shared/theme/gestor_temas.dart';

class ProveedorTema extends ChangeNotifier {
  static const String _clavePreferencias = 'tema_seleccionado';

  TipoTema _tipoTemaActual = GestorTemas.temaDefault;
  AppTema _temaActual = GestorTemas.obtenerTema(GestorTemas.temaDefault);
  bool _estaCargando = false;

  // Getters
  TipoTema get tipoTemaActual => _tipoTemaActual;
  AppTema get temaActual => _temaActual;
  bool get estaCargando => _estaCargando;
  List<TipoTema> get tiposDisponibles => GestorTemas.tiposDisponibles;

  // Constructor
  ProveedorTema() {
    _cargarTemaGuardado();
  }

  // Cambiar tema
  Future<void> cambiarTema(TipoTema nuevoTipo) async {
    if (_tipoTemaActual == nuevoTipo) return;

    _estaCargando = true;
    notifyListeners();

    // Simular una pequeña carga para animación suave
    await Future.delayed(const Duration(milliseconds: 200));

    _tipoTemaActual = nuevoTipo;
    _temaActual = GestorTemas.obtenerTema(nuevoTipo);

    await _guardarTema(nuevoTipo);

    _estaCargando = false;
    notifyListeners();
  }

  // Alternar entre tema claro y oscuro más cercano
  Future<void> alternarModoOscuro() async {
    final esOscuroActual = _temaActual.esOscuro;

    if (esOscuroActual) {
      // Si está oscuro, cambiar a claro
      await cambiarTema(TipoTema.claroMinimal);
    } else {
      // Si está claro, cambiar a oscuro
      await cambiarTema(TipoTema.oscuroElegante);
    }
  }

  // Cargar tema guardado
  Future<void> _cargarTemaGuardado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final temaGuardado = prefs.getString(_clavePreferencias);

      if (temaGuardado != null) {
        final tipoTema = GestorTemas.obtenerTipoPorId(temaGuardado);
        if (tipoTema != null) {
          _tipoTemaActual = tipoTema;
          _temaActual = GestorTemas.obtenerTema(tipoTema);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error al cargar tema guardado: $e');
    }
  }

  // Guardar tema
  Future<void> _guardarTema(TipoTema tipo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_clavePreferencias, tipo.id);
    } catch (e) {
      debugPrint('Error al guardar tema: $e');
    }
  }

  // Resetear a tema por defecto
  Future<void> resetearTema() async {
    await cambiarTema(GestorTemas.temaDefault);
  }

  // Obtener ThemeData de Flutter para compatibilidad
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: _temaActual.brightness,
      primaryColor: _temaActual.colorPrimario,
      scaffoldBackgroundColor: _temaActual.colorFondo,
      cardColor: _temaActual.colorTarjeta,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _temaActual.colorPrimario,
        brightness: _temaActual.brightness,
        primary: _temaActual.colorPrimario,
        secondary: _temaActual.colorSecundario,
        surface: _temaActual.colorSuperficie,
        background: _temaActual.colorFondo,
        error: _temaActual.colorError,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _temaActual.colorSuperficie,
        foregroundColor: _temaActual.colorTexto,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: _temaActual.colorTarjeta,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _temaActual.colorPrimario,
          foregroundColor: _temaActual.esOscuro ? Colors.white : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _temaActual.colorSuperficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _temaActual.colorTextoTerciary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _temaActual.colorTextoTerciary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _temaActual.colorPrimario, width: 2),
        ),
      ),
    );
  }
}
