import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/proveedor_estadisticas.dart';
import '../../../autenticacion_usuario/presentation/providers/proveedor_inicio_sesion.dart';
import '../widgets/resumen_estadisticas.dart';
import '../widgets/grafico_pastel_categorias.dart';
import '../widgets/grafico_barras_categorias.dart';
import '../widgets/selector_periodo.dart';
import '../../../../core/providers/proveedor_tema.dart';
import '../../../../core/routes/routes_app.dart';

class PaginaEstadisticas extends StatefulWidget {
  const PaginaEstadisticas({super.key});

  @override
  State<PaginaEstadisticas> createState() => _PaginaEstadisticasState();
}

class _PaginaEstadisticasState extends State<PaginaEstadisticas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioId = context
          .read<ProveedorInicioSesion>()
          .usuarioAutenticado
          ?.id;
      if (usuarioId != null) {
        context.read<ProveedorEstadisticas>().cargarEstadisticasGenerales(
          usuarioId,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, _) {
        final tema = proveedorTema.temaActual;

        return Scaffold(
          backgroundColor: tema.colorFondo,
          appBar: _buildAppBar(tema),
          body: Consumer<ProveedorEstadisticas>(
            builder: (context, proveedorEstadisticas, child) {
              return Column(
                children: [
                  _buildSelectorPeriodo(proveedorEstadisticas, tema),
                  Expanded(child: _buildContenido(proveedorEstadisticas, tema)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(tema) {
    return AppBar(
      backgroundColor: tema.colorSuperficie,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: tema.gradienteTarjeta),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tema.colorTextoSecundario.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: tema.colorPrimario,
          ),
          onPressed: () => NavegacionHelper.irAGastos(context),
        ),
      ),
      title: Text(
        'Estadísticas Financieras',
        style: GoogleFonts.poppins(
          color: tema.colorTexto,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 0.3,
        ),
      ),
      actions: [
        Consumer<ProveedorEstadisticas>(
          builder: (context, proveedor, child) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: tema.colorTextoSecundario.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: proveedor.estaCargando
                      ? tema.colorTextoSecundario
                      : tema.colorPrimario,
                ),
                onPressed: proveedor.estaCargando ? null : _refrescarDatos,
              ),
            );
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        labelColor: tema.colorPrimario,
        unselectedLabelColor: tema.colorTextoSecundario,
        indicatorColor: tema.colorPrimario,
        indicatorWeight: 3.0,
        labelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.pie_chart_rounded), text: 'Resumen'),
          Tab(icon: Icon(Icons.bar_chart_rounded), text: 'Gráficas'),
        ],
      ),
    );
  }

  Widget _buildSelectorPeriodo(ProveedorEstadisticas proveedor, tema) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: tema.gradienteTarjeta,
        boxShadow: [
          BoxShadow(
            color: tema.colorTextoSecundario.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SelectorPeriodo(
        periodoActual: proveedor.periodoSeleccionado,
        onPeriodoSeleccionado: (periodo) => _cambiarPeriodo(periodo, proveedor),
        onPeriodoPersonalizado: () => _mostrarSelectorFecha(proveedor),
      ),
    );
  }

  Widget _buildContenido(ProveedorEstadisticas proveedor, tema) {
    if (proveedor.estaCargando) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(tema.colorPrimario),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando estadísticas...',
              style: GoogleFonts.poppins(
                color: tema.colorTextoSecundario,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (proveedor.mensajeError != null) {
      return _buildError(proveedor.mensajeError!, proveedor, tema);
    }

    if (!proveedor.tieneDatos) {
      return _buildSinDatos(tema);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabResumen(proveedor.estadisticas!, tema),
        _buildTabGraficas(proveedor.estadisticas!, tema),
      ],
    );
  }

  Widget _buildTabResumen(estadisticas, tema) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ResumenEstadisticas(estadisticas: estadisticas),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: GraficoPastelCategorias(
              estadisticas: estadisticas.estadisticasPorCategoria,
              titulo: 'Distribución por Categorías',
            ),
          ),
          const SizedBox(height: 20),
          _buildTopCategorias(estadisticas, tema),
        ],
      ),
    );
  }

  Widget _buildTabGraficas(estadisticas, tema) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          FadeInUp(
            child: GraficoBarrasCategorias(
              estadisticas: estadisticas.estadisticasPorCategoria,
              titulo: 'Gastos por Categoría (Monto)',
              mostrarPorMonto: true,
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: GraficoBarrasCategorias(
              estadisticas: estadisticas.estadisticasPorCategoria,
              titulo: 'Transacciones por Categoría (Cantidad)',
              mostrarPorMonto: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategorias(estadisticas, tema) {
    final topCategorias = estadisticas.top5CategoriasPorMonto;

    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Container(
        decoration: BoxDecoration(
          gradient: tema.gradienteTarjeta,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: tema.colorTextoSecundario.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tema.colorPrimario.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.trending_up_rounded,
                      color: tema.colorPrimario,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Top 5 Categorías',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: tema.colorTexto,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...topCategorias.asMap().entries.map((entry) {
                final index = entry.key;
                final categoria = entry.value;
                return _buildItemTopCategoria(categoria, index + 1, tema);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTopCategoria(categoria, int position, tema) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tema.colorSuperficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tema.colorTextoSecundario.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: tema.colorTextoSecundario.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getPositionColor(position),
                  _getPositionColor(position).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getPositionColor(position).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$position',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getPositionColor(position).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(categoria.icono, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoria.categoria,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: tema.colorTexto,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${categoria.cantidadTransacciones} transacciones',
                  style: GoogleFonts.poppins(
                    color: tema.colorTextoSecundario,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                categoria.montoFormateado,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: tema.colorTexto,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                categoria.porcentajeFormateado,
                style: GoogleFonts.poppins(
                  color: tema.colorTextoSecundario,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String mensaje, ProveedorEstadisticas proveedor, tema) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    tema.colorError?.withOpacity(0.1) ??
                    Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: tema.colorError ?? Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar estadísticas',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: tema.colorTexto,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: tema.colorTextoSecundario,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: tema.gradientePrincipal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _refrescarDatos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinDatos(tema) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: tema.colorTextoSecundario.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.insert_chart_outlined_rounded,
                size: 48,
                color: tema.colorTextoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sin datos para mostrar',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: tema.colorTexto,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No hay transacciones en el período seleccionado.\nComienza registrando algunos gastos.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: tema.colorTextoSecundario,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cambiarPeriodo(
    PeriodoEstadisticas periodo,
    ProveedorEstadisticas proveedor,
  ) {
    final usuarioId = context
        .read<ProveedorInicioSesion>()
        .usuarioAutenticado
        ?.id;
    if (usuarioId == null) return;

    switch (periodo) {
      case PeriodoEstadisticas.general:
        proveedor.cargarEstadisticasGenerales(usuarioId);
        break;
      case PeriodoEstadisticas.ultimoMes:
        proveedor.cargarEstadisticasUltimoMes(usuarioId);
        break;
      case PeriodoEstadisticas.ultimos3Meses:
        proveedor.cargarEstadisticasUltimos3Meses(usuarioId);
        break;
      case PeriodoEstadisticas.personalizado:
        // Manejado por _mostrarSelectorFecha
        break;
    }
  }

  void _mostrarSelectorFecha(ProveedorEstadisticas proveedor) async {
    final usuarioId = context
        .read<ProveedorInicioSesion>()
        .usuarioAutenticado
        ?.id;
    if (usuarioId == null) return;

    final DateTimeRange? rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
    );

    if (rango != null) {
      proveedor.cargarEstadisticasPorPeriodo(usuarioId, rango.start, rango.end);
    }
  }

  void _refrescarDatos() {
    final usuarioId = context
        .read<ProveedorInicioSesion>()
        .usuarioAutenticado
        ?.id;
    if (usuarioId != null) {
      context.read<ProveedorEstadisticas>().refrescarEstadisticas(usuarioId);
    }
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.deepPurple;
    }
  }
}
