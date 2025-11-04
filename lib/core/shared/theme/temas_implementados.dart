import 'package:flutter/material.dart';
import 'app_tema_base.dart';

class TemaBancarioAzul extends AppTema {
  @override
  Color get colorPrimario => const Color(0xFF1565C0);

  @override
  Color get colorSecundario => const Color(0xFF0D47A1);

  @override
  Color get colorAccento => const Color(0xFF42A5F5);

  @override
  Color get colorFondo => const Color(0xFFF5F7FA);

  @override
  Color get colorSuperficie => Colors.white;

  @override
  Color get colorTarjeta => Colors.white;

  @override
  Color get colorTexto => const Color(0xFF1A1A1A);

  @override
  Color get colorTextoSecundario => const Color(0xFF666666);

  @override
  Color get colorTextoTerciary => const Color(0xFF999999);

  @override
  Color get colorExito => const Color(0xFF4CAF50);

  @override
  Color get colorError => const Color(0xFFE53935);

  @override
  Color get colorAdvertencia => const Color(0xFFFF9800);

  @override
  Color get colorInfo => const Color(0xFF2196F3);

  @override
  Gradient get gradientePrincipal => LinearGradient(
    colors: [colorPrimario, colorSecundario],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Gradient get gradienteSecundario => LinearGradient(
    colors: [colorAccento, colorPrimario],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Gradient get gradienteTarjeta => LinearGradient(
    colors: [Colors.white, const Color(0xFFFAFBFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  List<BoxShadow> get sombraElevacion1 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion2 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion3 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  @override
  Brightness get brightness => Brightness.light;
}

class TemaOscuroElegante extends AppTema {
  @override
  Color get colorPrimario => const Color(0xFF6366F1);

  @override
  Color get colorSecundario => const Color(0xFF4F46E5);

  @override
  Color get colorAccento => const Color(0xFF8B5CF6);

  @override
  Color get colorFondo => const Color(0xFF0F0F0F);

  @override
  Color get colorSuperficie => const Color(0xFF1A1A1A);

  @override
  Color get colorTarjeta => const Color(0xFF212121);

  @override
  Color get colorTexto => Colors.white;

  @override
  Color get colorTextoSecundario => const Color(0xFFB3B3B3);

  @override
  Color get colorTextoTerciary => const Color(0xFF666666);

  @override
  Color get colorExito => const Color(0xFF10B981);

  @override
  Color get colorError => const Color(0xFFEF4444);

  @override
  Color get colorAdvertencia => const Color(0xFFF59E0B);

  @override
  Color get colorInfo => const Color(0xFF3B82F6);

  @override
  Gradient get gradientePrincipal => LinearGradient(
    colors: [colorPrimario, colorSecundario],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Gradient get gradienteSecundario => LinearGradient(
    colors: [colorAccento, colorPrimario],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Gradient get gradienteTarjeta => LinearGradient(
    colors: [colorTarjeta, const Color(0xFF2A2A2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  List<BoxShadow> get sombraElevacion1 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion2 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion3 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  @override
  Brightness get brightness => Brightness.dark;
}

class TemaClaroMinimal extends AppTema {
  @override
  Color get colorPrimario => const Color(0xFF1F2937);

  @override
  Color get colorSecundario => const Color(0xFF374151);

  @override
  Color get colorAccento => const Color(0xFF6B7280);

  @override
  Color get colorFondo => const Color(0xFFFAFAFA);

  @override
  Color get colorSuperficie => Colors.white;

  @override
  Color get colorTarjeta => Colors.white;

  @override
  Color get colorTexto => const Color(0xFF111827);

  @override
  Color get colorTextoSecundario => const Color(0xFF4B5563);

  @override
  Color get colorTextoTerciary => const Color(0xFF9CA3AF);

  @override
  Color get colorExito => const Color(0xFF059669);

  @override
  Color get colorError => const Color(0xFFDC2626);

  @override
  Color get colorAdvertencia => const Color(0xFFD97706);

  @override
  Color get colorInfo => const Color(0xFF2563EB);

  @override
  Gradient get gradientePrincipal => LinearGradient(
    colors: [colorPrimario, colorSecundario],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Gradient get gradienteSecundario => LinearGradient(
    colors: [Colors.white, const Color(0xFFF9FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Gradient get gradienteTarjeta => LinearGradient(
    colors: [Colors.white, const Color(0xFFFCFCFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  List<BoxShadow> get sombraElevacion1 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 6,
      offset: const Offset(0, 1),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion2 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion3 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Brightness get brightness => Brightness.light;
}

class TemaDoradoPremium extends AppTema {
  @override
  Color get colorPrimario => const Color(0xFFB8860B);

  @override
  Color get colorSecundario => const Color(0xFFDAA520);

  @override
  Color get colorAccento => const Color(0xFFFFD700);

  @override
  Color get colorFondo => const Color(0xFF1A1A1A);

  @override
  Color get colorSuperficie => const Color(0xFF2D2D2D);

  @override
  Color get colorTarjeta => const Color(0xFF2D2D2D);

  @override
  Color get colorTexto => const Color(0xFFF5F5DC);

  @override
  Color get colorTextoSecundario => const Color(0xFFD4AF37);

  @override
  Color get colorTextoTerciary => const Color(0xFF8B7355);

  @override
  Color get colorExito => const Color(0xFF32CD32);

  @override
  Color get colorError => const Color(0xFFDC143C);

  @override
  Color get colorAdvertencia => const Color(0xFFFF8C00);

  @override
  Color get colorInfo => const Color(0xFF4169E1);

  @override
  Gradient get gradientePrincipal => LinearGradient(
    colors: [colorPrimario, colorSecundario, colorAccento],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Gradient get gradienteSecundario => LinearGradient(
    colors: [const Color(0xFFFFD700), const Color(0xFFB8860B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Gradient get gradienteTarjeta => LinearGradient(
    colors: [colorTarjeta, const Color(0xFF3A3A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  List<BoxShadow> get sombraElevacion1 => [
    BoxShadow(
      color: colorAccento.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion2 => [
    BoxShadow(
      color: colorAccento.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  List<BoxShadow> get sombraElevacion3 => [
    BoxShadow(
      color: colorAccento.withOpacity(0.2),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  @override
  Brightness get brightness => Brightness.dark;
}
