import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class BotonSimple extends StatefulWidget {
  final String texto;
  final VoidCallback? alPresionar;
  final bool estaCargando;
  final bool esPrimario;
  final IconData? icono;
  final double? ancho;

  const BotonSimple({
    super.key,
    required this.texto,
    this.alPresionar,
    this.estaCargando = false,
    this.esPrimario = true,
    this.icono,
    this.ancho,
  });

  @override
  State<BotonSimple> createState() => _BotonSimpleState();
}

class _BotonSimpleState extends State<BotonSimple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esHabilitado = widget.alPresionar != null && !widget.estaCargando;

    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.ancho ?? double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: widget.esPrimario && esHabilitado
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      )
                    : null,
                color: widget.esPrimario
                    ? (esHabilitado ? null : const Color(0xFF6B7280))
                    : (esHabilitado ? Colors.white : const Color(0xFFF9FAFB)),
                border: !widget.esPrimario
                    ? Border.all(
                        color: esHabilitado
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF6B7280),
                        width: 2.0,
                      )
                    : null,
                boxShadow: esHabilitado
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: esHabilitado ? _manejarTap : null,
                  onTapDown: esHabilitado ? _onTapDown : null,
                  onTapUp: esHabilitado ? _onTapUp : null,
                  onTapCancel: esHabilitado ? _onTapCancel : null,
                  child: Container(
                    alignment: Alignment.center,
                    child: widget.estaCargando
                        ? _construirIndicadorCarga()
                        : _construirContenido(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirIndicadorCarga() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.esPrimario ? Colors.white : const Color(0xFF6366F1),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Cargando...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.esPrimario ? Colors.white : const Color(0xFF6366F1),
          ),
        ),
      ],
    );
  }

  Widget _construirContenido() {
    final colorTexto = widget.esPrimario
        ? Colors.white
        : const Color(0xFF6366F1);

    if (widget.icono != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icono, color: colorTexto, size: 20),
          const SizedBox(width: 8),
          Text(
            widget.texto,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorTexto,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.texto,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorTexto,
      ),
    );
  }

  void _manejarTap() {
    widget.alPresionar?.call();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }
}
