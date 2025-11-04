import 'package:flutter/material.dart';
import 'injection_dependencie.dart';

class InicializadorDependencias {
  static Future<void> inicializarDependenciasAplicacion() async {
    WidgetsFlutterBinding.ensureInitialized();
    await InyeccionDependencias.inicializar();
  }
}
