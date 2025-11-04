import 'package:flutter/material.dart';

enum TipoTema {
  bancarioAzul('azul_profesional', 'Azul Profesional', Icons.business),
  oscuroElegante('oscuro_elegante', 'Oscuro Elegante', Icons.nights_stay),
  claroMinimal('claro_minimal', 'Claro Minimal', Icons.light_mode),
  doradoPremium('dorado_premium', 'Dorado Premium', Icons.star);

  const TipoTema(this.id, this.nombre, this.icono);

  final String id;
  final String nombre;
  final IconData icono;
}

abstract class AppTema {
  // Colores principales
  Color get colorPrimario;
  Color get colorSecundario;
  Color get colorAccento;

  // Colores de fondo
  Color get colorFondo;
  Color get colorSuperficie;
  Color get colorTarjeta;

  // Colores de texto
  Color get colorTexto;
  Color get colorTextoSecundario;
  Color get colorTextoTerciary;

  // Colores funcionales
  Color get colorExito;
  Color get colorError;
  Color get colorAdvertencia;
  Color get colorInfo;

  // Gradientes
  Gradient get gradientePrincipal;
  Gradient get gradienteSecundario;
  Gradient get gradienteTarjeta;

  // Sombras
  List<BoxShadow> get sombraElevacion1;
  List<BoxShadow> get sombraElevacion2;
  List<BoxShadow> get sombraElevacion3;

  // Propiedades del tema
  Brightness get brightness;
  bool get esOscuro => brightness == Brightness.dark;

  // Métodos de utilidad
  Color get colorContraste => esOscuro ? Colors.white : Colors.black;
  Color get colorDivider => esOscuro ? Colors.white24 : Colors.black12;
}
