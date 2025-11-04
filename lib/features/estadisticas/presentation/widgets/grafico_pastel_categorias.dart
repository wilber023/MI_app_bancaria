import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../doamin/entities/estadistica_categoria.dart';

class GraficoPastelCategorias extends StatefulWidget {
  final List<EstadisticaCategoria> estadisticas;
  final String titulo;

  const GraficoPastelCategorias({
    super.key,
    required this.estadisticas,
    this.titulo = 'Gastos por Categoría',
  });

  @override
  State<GraficoPastelCategorias> createState() =>
      _GraficoPastelCategoriasState();
}

class _GraficoPastelCategoriasState extends State<GraficoPastelCategorias> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.estadisticas.isEmpty) {
      return _buildSinDatos();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                                });
                              },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: _crearSecciones(),
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: _buildLeyenda()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _crearSecciones() {
    return widget.estadisticas.asMap().entries.map((entry) {
      final index = entry.key;
      final estadistica = entry.value;
      final isTocado = index == touchedIndex;

      final radius = isTocado ? 65.0 : 55.0;
      final fontSize = isTocado ? 16.0 : 14.0;

      return PieChartSectionData(
        color: _parseColor(estadistica.color),
        value: estadistica.porcentaje,
        title: '${estadistica.porcentajeFormateado}',
        radius: radius,
        titleStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            const Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLeyenda() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.estadisticas.map((estadistica) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _parseColor(estadistica.color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${estadistica.icono} ${estadistica.categoria}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      estadistica.montoFormateado,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSinDatos() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Sin datos para mostrar',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay transacciones en el período seleccionado',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse('0x$colorString'));
    } catch (e) {
      return Colors.grey;
    }
  }
}
