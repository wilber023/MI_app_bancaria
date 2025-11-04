import 'package:flutter/material.dart';
import 'core/di/dependency_initializer.dart';
import 'my_app.dart';

void main() async {
  await InicializadorDependencias.inicializarDependenciasAplicacion();
  runApp(const MyApp());
}
