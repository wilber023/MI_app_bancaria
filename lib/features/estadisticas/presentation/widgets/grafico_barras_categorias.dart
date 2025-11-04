import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../doamin/entities/estadistica_categoria.dart';

class GraficoBarrasCategorias extends StatelessWidget {
  final List<EstadisticaCategoria> estadisticas;
  final String titulo;
  final bool mostrarPorMonto;

  const GraficoBarrasCategorias({
    super.key,
    required this.estadisticas,
    this.titulo = 'Gastos por Categoría',
    this.mostrarPorMonto = true,
  });

  @override
  Widget build(BuildContext context) {
    if (estadisticas.isEmpty) {
      return _buildSinDatos();
    }

    // Tomar solo las top 6 categorías para evitar sobrecarga visual
    final topCategorias = estadisticas.take(6).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mostrarPorMonto ? 'Ordenado por monto' : 'Ordenado por cantidad',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _obtenerMaxY(topCategorias),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final categoria = topCategorias[group.x];
                        return BarTooltipItem(
                          '${categoria.icono} ${categoria.categoria}\n',
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: mostrarPorMonto
                                  ? categoria.montoFormateado
                                  : '${categoria.cantidadTransacciones} transacciones',
                              style: GoogleFonts.poppins(
                                color: Colors.yellow,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            _buildBottomTitle(value, topCategorias),
                        reservedSize: 60,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _obtenerIntervalo(topCategorias),
                        getTitlesWidget: (value, meta) =>
                            _buildLeftTitle(value),
                        reservedSize: 50,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _crearBarras(topCategorias),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _obtenerIntervalo(topCategorias),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _crearBarras(List<EstadisticaCategoria> categorias) {
    return categorias.asMap().entries.map((entry) {
      final index = entry.key;
      final categoria = entry.value;
      final valor = mostrarPorMonto
          ? categoria.monto
          : categoria.cantidadTransacciones.toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: valor,
            color: _parseColor(categoria.color),
            width: 30,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _obtenerMaxY(categorias),
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitle(
    double value,
    List<EstadisticaCategoria> categorias,
  ) {
    if (value.toInt() >= 0 && value.toInt() < categorias.length) {
      final categoria = categorias[value.toInt()];
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Text(categoria.icono, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              categoria.categoria.length > 8
                  ? '${categoria.categoria.substring(0, 8)}...'
                  : categoria.categoria,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLeftTitle(double value) {
    if (mostrarPorMonto) {
      return Text(
        '\$${value.toInt()}',
        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]),
      );
    } else {
      return Text(
        value.toInt().toString(),
        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700]),
      );
    }
  }

  double _obtenerMaxY(List<EstadisticaCategoria> categorias) {
    if (categorias.isEmpty) return 100;

    final maxValor = mostrarPorMonto
        ? categorias.map((c) => c.monto).reduce((a, b) => a > b ? a : b)
        : categorias
              .map((c) => c.cantidadTransacciones.toDouble())
              .reduce((a, b) => a > b ? a : b);

    // Agregar un 20% de margen superior
    return maxValor * 1.2;
  }

  double _obtenerIntervalo(List<EstadisticaCategoria> categorias) {
    final maxY = _obtenerMaxY(categorias);
    return maxY / 5; // 5 líneas de grid
  }

  Widget _buildSinDatos() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey[400]),
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
