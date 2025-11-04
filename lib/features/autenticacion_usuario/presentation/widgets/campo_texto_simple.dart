import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CampoTextoSimple extends StatefulWidget {
  final String etiqueta;
  final String? sugerencia;
  final TextEditingController? controlador;
  final bool esContrasena;
  final bool esRequerido;
  final TextInputType tipoTeclado;
  final String? Function(String?)? validador;
  final void Function(String)? alCambiar;
  final IconData? icono;
  final bool habilitado;
  final String? textoError;

  const CampoTextoSimple({
    super.key,
    required this.etiqueta,
    this.sugerencia,
    this.controlador,
    this.esContrasena = false,
    this.esRequerido = false,
    this.tipoTeclado = TextInputType.text,
    this.validador,
    this.alCambiar,
    this.icono,
    this.habilitado = true,
    this.textoError,
  });

  @override
  State<CampoTextoSimple> createState() => _CampoTextoSimpleState();
}

class _CampoTextoSimpleState extends State<CampoTextoSimple> {
  bool _mostrarContrasena = false;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.etiqueta.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    widget.etiqueta,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827),
                    ),
                  ),
                  if (widget.esRequerido)
                    const Text(
                      ' *',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                ],
              ),
            ),

          TextFormField(
            controller: widget.controlador,
            obscureText: widget.esContrasena && !_mostrarContrasena,
            keyboardType: widget.tipoTeclado,
            enabled: widget.habilitado,
            validator: widget.validador,
            onChanged: widget.alCambiar,
            decoration: InputDecoration(
              hintText: widget.sugerencia,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: widget.icono != null
                  ? Icon(widget.icono, color: Color(0xFF6B7280))
                  : null,
              suffixIcon: widget.esContrasena
                  ? IconButton(
                      icon: Icon(
                        _mostrarContrasena
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xFF6B7280),
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarContrasena = !_mostrarContrasena;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: widget.habilitado
                  ? Colors.white
                  : const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6B7280)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6B7280)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF6366F1),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorText: widget.textoError,
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
          ),
        ],
      ),
    );
  }
}
