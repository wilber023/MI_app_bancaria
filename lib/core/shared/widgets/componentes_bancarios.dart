import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_tema_base.dart';

class TarjetaBancaria extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final AppTema tema;
  final bool elevada;
  final bool conGradiente;

  const TarjetaBancaria({
    super.key,
    required this.child,
    required this.tema,
    this.padding,
    this.onTap,
    this.elevada = true,
    this.conGradiente = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: conGradiente ? tema.gradienteTarjeta : null,
            color: conGradiente ? null : tema.colorTarjeta,
            borderRadius: BorderRadius.circular(16),
            boxShadow: elevada ? tema.sombraElevacion2 : tema.sombraElevacion1,
            border: Border.all(
              color: tema.colorTextoTerciary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BotonBancario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final AppTema tema;
  final bool esPrimario;
  final bool cargando;
  final IconData? icono;
  final bool expandido;

  const BotonBancario({
    super.key,
    required this.texto,
    required this.tema,
    this.onPressed,
    this.esPrimario = true,
    this.cargando = false,
    this.icono,
    this.expandido = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget boton = esPrimario ? _buildBotonPrimario() : _buildBotonSecundario();

    return expandido ? SizedBox(width: double.infinity, child: boton) : boton;
  }

  Widget _buildBotonPrimario() {
    return Container(
      decoration: BoxDecoration(
        gradient: tema.gradientePrincipal,
        borderRadius: BorderRadius.circular(12),
        boxShadow: tema.sombraElevacion2,
      ),
      child: ElevatedButton(
        onPressed: cargando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildContenidoBoton(Colors.white),
      ),
    );
  }

  Widget _buildBotonSecundario() {
    return OutlinedButton(
      onPressed: cargando ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: tema.colorPrimario, width: 2),
      ),
      child: _buildContenidoBoton(tema.colorPrimario),
    );
  }

  Widget _buildContenidoBoton(Color colorTexto) {
    if (cargando) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colorTexto),
        ),
      );
    }

    if (icono != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: colorTexto, size: 20),
          const SizedBox(width: 8),
          Text(
            texto,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: colorTexto,
            ),
          ),
        ],
      );
    }

    return Text(
      texto,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: colorTexto,
      ),
    );
  }
}

class InputBancario extends StatelessWidget {
  final String etiqueta;
  final String? pista;
  final TextEditingController? controlador;
  final AppTema tema;
  final IconData? iconoPrefijo;
  final Widget? sufijo;
  final bool obscureText;
  final TextInputType? tipoTeclado;
  final String? Function(String?)? validador;
  final VoidCallback? onTap;
  final bool soloLectura;

  const InputBancario({
    super.key,
    required this.etiqueta,
    required this.tema,
    this.pista,
    this.controlador,
    this.iconoPrefijo,
    this.sufijo,
    this.obscureText = false,
    this.tipoTeclado,
    this.validador,
    this.onTap,
    this.soloLectura = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: tema.colorTextoSecundario,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controlador,
          obscureText: obscureText,
          keyboardType: tipoTeclado,
          validator: validador,
          onTap: onTap,
          readOnly: soloLectura,
          style: GoogleFonts.poppins(color: tema.colorTexto, fontSize: 16),
          decoration: InputDecoration(
            hintText: pista,
            hintStyle: GoogleFonts.poppins(color: tema.colorTextoTerciary),
            prefixIcon: iconoPrefijo != null
                ? Icon(iconoPrefijo, color: tema.colorTextoSecundario)
                : null,
            suffix: sufijo,
            filled: true,
            fillColor: tema.colorSuperficie,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: tema.colorTextoTerciary.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: tema.colorPrimario, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class CargadorShimmer extends StatelessWidget {
  final double altura;
  final double? ancho;
  final BorderRadius? borderRadius;
  final AppTema tema;

  const CargadorShimmer({
    super.key,
    required this.altura,
    required this.tema,
    this.ancho,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: tema.colorTextoTerciary.withOpacity(0.3),
      highlightColor: tema.colorTextoTerciary.withOpacity(0.1),
      child: Container(
        height: altura,
        width: ancho,
        decoration: BoxDecoration(
          color: tema.colorTextoTerciary.withOpacity(0.3),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class IndicadorEstado extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final IconData icono;
  final AppTema tema;
  final Color? colorPersonalizado;

  const IndicadorEstado({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.icono,
    required this.tema,
    this.colorPersonalizado,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorPersonalizado ?? tema.colorPrimario;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icono, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: tema.colorTexto,
            ),
          ),
          Text(
            etiqueta,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: tema.colorTextoSecundario,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Extensión para InputDecoration personalizada
extension InputDecorationData on InputDecoration {
  static InputDecoration bancario({
    required AppTema tema,
    String? hintText,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: tema.colorTextoTerciary),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: tema.colorTextoSecundario)
          : null,
      suffix: suffix,
      filled: true,
      fillColor: tema.colorSuperficie,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tema.colorTextoTerciary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: tema.colorPrimario, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
