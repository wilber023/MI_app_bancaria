import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/gasto_entidad.dart';
import '../../../../core/providers/proveedor_tema.dart';

class TarjetaGasto extends StatelessWidget {
  final GastoEntidad gasto;
  final VoidCallback? onTap;
  final VoidCallback? onEliminar;

  const TarjetaGasto({
    super.key,
    required this.gasto,
    this.onTap,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, child) {
        final tema = proveedorTema.temaActual;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: tema.gradienteTarjeta,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: tema.colorTextoSecundario.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              splashColor: tema.colorPrimario.withOpacity(0.1),
              highlightColor: tema.colorPrimario.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildIconoCategoria(tema),
                    const SizedBox(width: 16),
                    Expanded(child: _buildContenidoGasto(tema)),
                    _buildMonto(tema),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconoCategoria(tema) {
    final colorCategoria = _getColorCategoria();
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorCategoria.withOpacity(0.2),
            colorCategoria.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorCategoria.withOpacity(0.3), width: 1),
      ),
      child: Icon(_getIconoCategoria(), color: colorCategoria, size: 24),
    );
  }

  Widget _buildContenidoGasto(tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gasto.descripcion,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: tema.colorTexto,
            letterSpacing: 0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getColorCategoria().withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                gasto.categoria,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: _getColorCategoria(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: tema.colorTextoSecundario,
                ),
                const SizedBox(width: 3),
                Text(
                  DateFormat('dd/MM/yy').format(gasto.fecha),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: tema.colorTextoSecundario,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonto(tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '-\$${gasto.monto.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: tema.colorError ?? Colors.red[600],
            letterSpacing: 0.3,
          ),
        ),
        if (onEliminar != null)
          GestureDetector(
            onTap: onEliminar,
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:
                    tema.colorError?.withOpacity(0.1) ??
                    Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.delete_outline,
                size: 16,
                color: tema.colorError ?? Colors.red[600],
              ),
            ),
          ),
      ],
    );
  }

  IconData _getIconoCategoria() {
    switch (gasto.categoria.toLowerCase()) {
      case 'alimentación':
        return Icons.restaurant;
      case 'transporte':
        return Icons.directions_car;
      case 'entretenimiento':
        return Icons.movie;
      case 'compras':
        return Icons.shopping_bag;
      case 'salud':
        return Icons.local_hospital;
      case 'educación':
        return Icons.school;
      case 'servicios':
        return Icons.build;
      default:
        return Icons.attach_money;
    }
  }

  Color _getColorCategoria() {
    switch (gasto.categoria.toLowerCase()) {
      case 'alimentación':
        return Colors.orange;
      case 'transporte':
        return Colors.blue;
      case 'entretenimiento':
        return Colors.purple;
      case 'compras':
        return Colors.pink;
      case 'salud':
        return Colors.red;
      case 'educación':
        return Colors.green;
      case 'servicios':
        return Colors.brown;
      default:
        return Colors.deepPurple;
    }
  }
}
