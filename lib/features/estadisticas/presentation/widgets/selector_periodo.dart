import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/proveedor_estadisticas.dart';

class SelectorPeriodo extends StatelessWidget {
  final PeriodoEstadisticas periodoActual;
  final Function(PeriodoEstadisticas) onPeriodoSeleccionado;
  final VoidCallback onPeriodoPersonalizado;

  const SelectorPeriodo({
    super.key,
    required this.periodoActual,
    required this.onPeriodoSeleccionado,
    required this.onPeriodoPersonalizado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Período de análisis',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChipPeriodo(
                  'Todo',
                  PeriodoEstadisticas.general,
                  Icons.all_inclusive,
                ),
                _buildChipPeriodo(
                  'Último mes',
                  PeriodoEstadisticas.ultimoMes,
                  Icons.calendar_view_month,
                ),
                _buildChipPeriodo(
                  'Últimos 3 meses',
                  PeriodoEstadisticas.ultimos3Meses,
                  Icons.calendar_view_week,
                ),
                _buildChipPersonalizado(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipPeriodo(
    String label,
    PeriodoEstadisticas periodo,
    IconData icono,
  ) {
    final isSelected = periodoActual == periodo;

    return FilterChip(
      avatar: Icon(
        icono,
        size: 18,
        color: isSelected ? Colors.white : Colors.grey[600],
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onPeriodoSeleccionado(periodo),
      selectedColor: Colors.deepPurple,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildChipPersonalizado() {
    final isSelected = periodoActual == PeriodoEstadisticas.personalizado;

    return FilterChip(
      avatar: Icon(
        Icons.date_range,
        size: 18,
        color: isSelected ? Colors.white : Colors.grey[600],
      ),
      label: Text(
        'Personalizado',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onPeriodoPersonalizado(),
      selectedColor: Colors.deepPurple,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
