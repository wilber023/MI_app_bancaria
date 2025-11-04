import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../doamin/entities/estadisticas_transacciones.dart';

class ResumenEstadisticas extends StatelessWidget {
  final EstadisticasTransacciones estadisticas;

  const ResumenEstadisticas({super.key, required this.estadisticas});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeaderResumen(),
              const SizedBox(height: 20),
              _buildEstadisticasPrincipales(),
              const SizedBox(height: 16),
              _buildCategoriaDestacada(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderResumen() {
    return Column(
      children: [
        Text(
          'Resumen de Gastos',
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          estadisticas.totalGastosFormateado,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Total gastado',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEstadisticasPrincipales() {
    return Row(
      children: [
        Expanded(
          child: _buildEstadisticaItem(
            'Transacciones',
            estadisticas.totalTransacciones.toString(),
            Icons.receipt_long,
          ),
        ),
        Container(width: 1, height: 50, color: Colors.white24),
        Expanded(
          child: _buildEstadisticaItem(
            'Promedio',
            estadisticas.promedioFormateado,
            Icons.trending_up,
          ),
        ),
        Container(width: 1, height: 50, color: Colors.white24),
        Expanded(
          child: _buildEstadisticaItem(
            'Categorías',
            estadisticas.estadisticasPorCategoria.length.toString(),
            Icons.category,
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticaItem(String titulo, String valor, IconData icono) {
    return Column(
      children: [
        Icon(icono, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          valor,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoriaDestacada() {
    if (estadisticas.categoriaConMasGastos.monto == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              estadisticas.categoriaConMasGastos.icono,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categoría con más gastos',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  estadisticas.categoriaConMasGastos.categoria,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                estadisticas.categoriaConMasGastos.montoFormateado,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                estadisticas.categoriaConMasGastos.porcentajeFormateado,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
