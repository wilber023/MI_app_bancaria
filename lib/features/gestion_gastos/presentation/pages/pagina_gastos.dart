import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/gasto_entidad.dart';
import '../../domain/usecases/caso_uso_gestionar_gastos.dart';
import '../providers/proveedor_gastos.dart';
import '../../../autenticacion_usuario/presentation/providers/proveedor_inicio_sesion.dart';
import '../../../autenticacion_usuario/presentation/providers/proveedor_estado_autenticacion.dart';
import '../widgets/tarjeta_gasto.dart';
import '../widgets/formulario_gasto.dart';
import '../../../../core/routes/routes_app.dart';
import '../../../../core/providers/proveedor_tema.dart';
import '../../../../core/shared/widgets/componentes_bancarios.dart';

class PaginaGastos extends StatefulWidget {
  const PaginaGastos({super.key});

  @override
  State<PaginaGastos> createState() => _PaginaGastosState();
}

class _PaginaGastosState extends State<PaginaGastos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioId = context
          .read<ProveedorInicioSesion>()
          .usuarioAutenticado
          ?.id;
      if (usuarioId != null) {
        context.read<ProveedorGastos>().cargarGastos(usuarioId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, child) {
        final tema = proveedorTema.temaActual;

        return Scaffold(
          backgroundColor: tema.colorFondo,
          appBar: _buildAppBar(tema),
          body: Consumer<ProveedorGastos>(
            builder: (context, proveedorGastos, child) {
              if (proveedorGastos.estaCargando) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          tema.colorPrimario,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando tus gastos...',
                        style: GoogleFonts.poppins(
                          color: tema.colorTextoSecundario,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (proveedorGastos.mensajeError != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: tema.colorError,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar gastos',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: tema.colorTexto,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        proveedorGastos.mensajeError!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: tema.colorTextoSecundario,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BotonBancario(
                        texto: 'Reintentar',
                        tema: tema,
                        onPressed: _recargarGastos,
                        icono: Icons.refresh,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _buildResumen(proveedorGastos.resumen, tema),
                  Expanded(
                    child: _buildListaGastos(proveedorGastos.gastos, tema),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FadeInUp(
            child: Container(
              decoration: BoxDecoration(
                gradient: tema.gradientePrincipal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: tema.sombraElevacion2,
              ),
              child: FloatingActionButton.extended(
                onPressed: _mostrarFormularioGasto,
                backgroundColor: Colors.transparent,
                elevation: 0,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Nuevo Gasto',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(tema) {
    return AppBar(
      backgroundColor: tema.colorSuperficie,
      elevation: 0,
      title: Text(
        'Mis Gastos',
        style: GoogleFonts.poppins(
          color: tema.colorTexto,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.analytics, color: tema.colorTexto),
          onPressed: () => NavegacionHelper.irAEstadisticas(context),
          tooltip: 'Ver estadísticas',
        ),
        IconButton(
          icon: Icon(Icons.palette, color: tema.colorTexto),
          onPressed: () => NavegacionHelper.irAConfiguracion(context),
          tooltip: 'Cambiar tema',
        ),
        Consumer<ProveedorInicioSesion>(
          builder: (context, proveedor, child) {
            return PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: tema.colorTexto),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      proveedor.usuarioAutenticado?.nombre ?? 'Usuario',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  child: ListTile(
                    leading: const Icon(Icons.analytics),
                    title: Text(
                      'Estadísticas',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      NavegacionHelper.regresar(context);
                      NavegacionHelper.irAEstadisticas(context);
                    },
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Cerrar sesión',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    onTap: () async {
                      NavegacionHelper.regresar(context);

                      final proveedorAuth =
                          Provider.of<ProveedorEstadoAutenticacion>(
                            context,
                            listen: false,
                          );

                      final exitoso = await proveedorAuth.cerrarSesion();

                      if (mounted && exitoso) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.go('/login');
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildResumen(ResumenGastos? resumen, tema) {
    if (resumen == null) return const SizedBox.shrink();

    return FadeInDown(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: tema.gradientePrincipal,
          borderRadius: BorderRadius.circular(16),
          boxShadow: tema.sombraElevacion3,
        ),
        child: Column(
          children: [
            Text(
              'Total de gastos',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${resumen.totalGastos.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEstadistica('Gastos', resumen.cantidadGastos.toDouble()),
                _buildEstadistica('Total', resumen.totalGastos),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadistica(String titulo, double valor) {
    return Column(
      children: [
        Text(
          titulo,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          titulo == 'Gastos'
              ? valor.toInt().toString()
              : '\$${valor.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildListaGastos(List<GastoEntidad> gastos, tema) {
    if (gastos.isEmpty) {
      return FadeIn(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: tema.colorTextoTerciary,
              ),
              const SizedBox(height: 16),
              Text(
                'No tienes gastos registrados',
                style: GoogleFonts.poppins(
                  color: tema.colorTexto,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Toca el botón + para agregar tu primer gasto',
                style: GoogleFonts.poppins(
                  color: tema.colorTextoSecundario,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gastos.length,
      itemBuilder: (context, index) {
        final gasto = gastos[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: TarjetaGasto(
            gasto: gasto,
            onTap: () => _editarGasto(gasto),
            onEliminar: () => _eliminarGasto(gasto),
          ),
        );
      },
    );
  }

  void _mostrarFormularioGasto() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FormularioGasto(),
    );
  }

  void _editarGasto(GastoEntidad gasto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FormularioGasto(gastoParaEditar: gasto),
    );
  }

  void _eliminarGasto(GastoEntidad gasto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Eliminar gasto',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar este gasto?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => NavegacionHelper.regresar(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              NavegacionHelper.regresar(context);
              final usuarioId = context
                  .read<ProveedorInicioSesion>()
                  .usuarioAutenticado
                  ?.id;
              if (usuarioId != null) {
                await context.read<ProveedorGastos>().eliminarGasto(
                  gasto.id,
                  usuarioId,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _recargarGastos() {
    final usuarioId = context
        .read<ProveedorInicioSesion>()
        .usuarioAutenticado
        ?.id;
    if (usuarioId != null) {
      context.read<ProveedorGastos>().cargarGastos(usuarioId);
    }
  }
}
