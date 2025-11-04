import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TarjetaMensaje extends StatelessWidget {
  final String mensaje;
  final TipoMensaje tipo;
  final VoidCallback? alCerrar;
  final IconData? iconoPersonalizado;
  final bool mostrarIcono;
  final Duration? duracionAnimacion;

  const TarjetaMensaje({
    super.key,
    required this.mensaje,
    this.tipo = TipoMensaje.informacion,
    this.alCerrar,
    this.iconoPersonalizado,
    this.mostrarIcono = true,
    this.duracionAnimacion,
  });

  @override
  Widget build(BuildContext context) {
    final configMensaje = _obtenerConfiguracionMensaje();

    return SlideInDown(
      duration: duracionAnimacion ?? const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: configMensaje.colorFondo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: configMensaje.colorBorde, width: 1),
          boxShadow: [
            BoxShadow(
              color: configMensaje.colorBorde.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (mostrarIcono)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: configMensaje.colorIcono.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconoPersonalizado ?? configMensaje.icono,
                  color: configMensaje.colorIcono,
                  size: 20,
                ),
              ),

            if (mostrarIcono) const SizedBox(width: 12),

            Expanded(
              child: Text(
                mensaje,
                style: TextStyle(
                  color: configMensaje.colorTexto,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (alCerrar != null)
              IconButton(
                onPressed: alCerrar,
                icon: Icon(
                  Icons.close,
                  color: configMensaje.colorTexto.withOpacity(0.7),
                  size: 18,
                ),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
          ],
        ),
      ),
    );
  }

  ConfiguracionMensaje _obtenerConfiguracionMensaje() {
    switch (tipo) {
      case TipoMensaje.error:
        return ConfiguracionMensaje(
          colorFondo: const Color(0xFFFEF2F2),
          colorBorde: const Color(0xFFFECACA),
          colorIcono: const Color(0xFFEF4444),
          colorTexto: const Color(0xFF7F1D1D),
          icono: Icons.error_outline,
        );
      case TipoMensaje.exito:
        return ConfiguracionMensaje(
          colorFondo: const Color(0xFFF0FDF4),
          colorBorde: const Color(0xFFBBF7D0),
          colorIcono: const Color(0xFF10B981),
          colorTexto: const Color(0xFF14532D),
          icono: Icons.check_circle_outline,
        );
      case TipoMensaje.advertencia:
        return ConfiguracionMensaje(
          colorFondo: const Color(0xFFFFFBEB),
          colorBorde: const Color(0xFFFEF3C7),
          colorIcono: const Color(0xFFF59E0B),
          colorTexto: const Color(0xFF92400E),
          icono: Icons.warning_amber_outlined,
        );
      case TipoMensaje.informacion:
        return ConfiguracionMensaje(
          colorFondo: const Color(0xFFEFF6FF),
          colorBorde: const Color(0xFFDDEAFE),
          colorIcono: const Color(0xFF3B82F6),
          colorTexto: const Color(0xFF1E3A8A),
          icono: Icons.info_outline,
        );
    }
  }
}

enum TipoMensaje { error, exito, advertencia, informacion }

class ConfiguracionMensaje {
  final Color colorFondo;
  final Color colorBorde;
  final Color colorIcono;
  final Color colorTexto;
  final IconData icono;

  ConfiguracionMensaje({
    required this.colorFondo,
    required this.colorBorde,
    required this.colorIcono,
    required this.colorTexto,
    required this.icono,
  });
}
