import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/proveedor_tema.dart';
import '../theme/app_tema_base.dart';

class SelectorTemas extends StatefulWidget {
  const SelectorTemas({super.key});

  @override
  State<SelectorTemas> createState() => _SelectorTemasState();
}

class _SelectorTemasState extends State<SelectorTemas> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, child) {
        final temaActual = proveedorTema.temaActual;

        return Scaffold(
          backgroundColor: temaActual.colorFondo,
          appBar: _buildAppBar(temaActual),
          body: _buildCuerpo(proveedorTema, temaActual),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AppTema tema) {
    return AppBar(
      backgroundColor: tema.colorSuperficie,
      foregroundColor: tema.colorTexto,
      elevation: 0,
      title: Text(
        'Personalizar Tema',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: tema.colorTexto,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: tema.colorTexto),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildCuerpo(ProveedorTema proveedor, AppTema tema) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEncabezado(tema),
          const SizedBox(height: 24),
          _buildVistaPrevia(tema),
          const SizedBox(height: 24),
          _buildListaTemas(proveedor, tema),
          const SizedBox(height: 24),
          _buildBotonesAccion(proveedor, tema),
        ],
      ),
    );
  }

  Widget _buildEncabezado(AppTema tema) {
    return FadeInDown(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu tema',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: tema.colorTexto,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Personaliza la experiencia visual de tu aplicación',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: tema.colorTextoSecundario,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVistaPrevia(AppTema tema) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          gradient: tema.gradientePrincipal,
          borderRadius: BorderRadius.circular(16),
          boxShadow: tema.sombraElevacion2,
        ),
        child: Stack(
          children: [
            // Elementos decorativos
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              left: -10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Vista Previa del Tema',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.palette, color: Colors.white, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aplicación de Finanzas Personales',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaTemas(ProveedorTema proveedor, AppTema tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temas disponibles',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: tema.colorTexto,
          ),
        ),
        const SizedBox(height: 16),
        ...proveedor.tiposDisponibles.asMap().entries.map((entry) {
          final index = entry.key;
          final tipoTema = entry.value;

          return FadeInLeft(
            delay: Duration(milliseconds: 100 * index),
            child: _buildTarjetaTema(
              tipoTema,
              proveedor.tipoTemaActual == tipoTema,
              () => proveedor.cambiarTema(tipoTema),
              tema,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTarjetaTema(
    TipoTema tipoTema,
    bool seleccionado,
    VoidCallback onTap,
    AppTema tema,
  ) {
    final coloresVistaPrevia = switch (tipoTema) {
      TipoTema.bancarioAzul => [
        const Color(0xFF1565C0),
        const Color(0xFF0D47A1),
      ],
      TipoTema.oscuroElegante => [
        const Color(0xFF6366F1),
        const Color(0xFF4F46E5),
      ],
      TipoTema.claroMinimal => [
        const Color(0xFF1F2937),
        const Color(0xFF374151),
      ],
      TipoTema.doradoPremium => [
        const Color(0xFFB8860B),
        const Color(0xFFDAA520),
      ],
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tema.colorTarjeta,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: seleccionado
                    ? tema.colorPrimario
                    : tema.colorTextoTerciary.withOpacity(0.3),
                width: seleccionado ? 2 : 1,
              ),
              boxShadow: seleccionado
                  ? tema.sombraElevacion2
                  : tema.sombraElevacion1,
            ),
            child: Row(
              children: [
                // Vista previa del color
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: coloresVistaPrevia,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(tipoTema.icono, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                // Información del tema
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoTema.nombre,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: tema.colorTexto,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDescripcionTema(tipoTema),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: tema.colorTextoSecundario,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicador de selección
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? tema.colorPrimario
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: seleccionado
                          ? tema.colorPrimario
                          : tema.colorTextoTerciary,
                      width: 2,
                    ),
                  ),
                  child: seleccionado
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotonesAccion(ProveedorTema proveedor, AppTema tema) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => proveedor.resetearTema(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: tema.colorTextoTerciary),
              ),
              child: Text(
                'Resetear',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: tema.colorTexto,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: tema.colorPrimario,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Aplicar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDescripcionTema(TipoTema tipo) {
    return switch (tipo) {
      TipoTema.bancarioAzul =>
        'Profesional y confiable, perfecto para uso diario',
      TipoTema.oscuroElegante =>
        'Sofisticado y moderno, ideal para uso nocturno',
      TipoTema.claroMinimal => 'Limpio y minimalista, fácil para la vista',
      TipoTema.doradoPremium => 'Elegante y distinguido, para una experiencia premium',
    };
  }
}
