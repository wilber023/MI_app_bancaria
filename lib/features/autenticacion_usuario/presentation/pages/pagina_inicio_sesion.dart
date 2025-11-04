import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/proveedor_inicio_sesion.dart';
import '../providers/proveedor_estado_autenticacion.dart';
import '../widgets/campo_texto_simple.dart';
import '../widgets/boton_simple.dart';
import '../widgets/tarjeta_mensaje.dart';
import '../../../../core/routes/routes_app.dart';
import '../../../../core/security/servicio_timeout_avanzado.dart';
import '../../../../core/providers/proveedor_tema.dart';

class PaginaInicioSesion extends StatefulWidget {
  const PaginaInicioSesion({super.key});

  @override
  State<PaginaInicioSesion> createState() => _PaginaInicioSesionState();
}

class _PaginaInicioSesionState extends State<PaginaInicioSesion>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _controladorNombreUsuario = TextEditingController();
  final _controladorContrasena = TextEditingController();

  late AnimationController _controladorAnimacionFondo;
  late Animation<double> _animacionFondo;

  @override
  void initState() {
    super.initState();
    _controladorAnimacionFondo = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _animacionFondo = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controladorAnimacionFondo, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controladorNombreUsuario.dispose();
    _controladorContrasena.dispose();
    _controladorAnimacionFondo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, _) {
        final tema = proveedorTema.temaActual;

        return Scaffold(
          backgroundColor: tema.colorFondo,
          body: Stack(
            children: [
              _construirFondoAnimado(tema),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 40),
                            _construirHeader(tema),
                            const SizedBox(height: 30),
                            _construirFormularioLogin(tema),
                          ],
                        ),
                        Column(
                          children: [
                            _construirEnlacesNavegacion(tema),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirFondoAnimado(tema) {
    return AnimatedBuilder(
      animation: _animacionFondo,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tema.colorPrimario.withOpacity(0.15),
                tema.colorSecundario.withOpacity(0.08),
                tema.colorPrimario.withOpacity(0.12),
              ],
              stops: [0.0, 0.5 + 0.5 * _animacionFondo.value, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _construirHeader(tema) {
    return FadeInDown(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: tema.gradienteTarjeta,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: tema.colorPrimario.withOpacity(0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(
                color: tema.colorTextoSecundario.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 56,
              color: tema.colorPrimario,
            ),
          ),

          const SizedBox(height: 32),

          Text(
            '¡Bienvenido de vuelta!',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: tema.colorTexto,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Gestiona tus finanzas de manera inteligente',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: tema.colorTextoSecundario,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFormularioLogin(tema) {
    return Consumer<ProveedorInicioSesion>(
      builder: (context, proveedor, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: tema.gradienteTarjeta,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: tema.colorTextoSecundario.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (proveedor.mensajeError != null)
                    TarjetaMensaje(
                      mensaje: proveedor.mensajeError!,
                      tipo: TipoMensaje.error,
                      alCerrar: () => proveedor.limpiarError(),
                    ),

                  if (proveedor.mensajeError != null)
                    const SizedBox(height: 24),

                  CampoTextoSimple(
                    etiqueta: 'Nombre de Usuario',
                    sugerencia: 'Ingresa tu nombre de usuario',
                    controlador: _controladorNombreUsuario,
                    icono: Icons.person_outline_rounded,
                    tipoTeclado: TextInputType.text,
                    esRequerido: true,
                    habilitado: !proveedor.estaCargando,
                    validador: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'El nombre de usuario es requerido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  CampoTextoSimple(
                    etiqueta: 'Contraseña',
                    sugerencia: 'Ingresa tu contraseña',
                    controlador: _controladorContrasena,
                    icono: Icons.lock_outline_rounded,
                    esContrasena: true,
                    esRequerido: true,
                    habilitado: !proveedor.estaCargando,
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'La contraseña es requerida';
                      }
                      if (valor.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  BotonSimple(
                    texto: 'Iniciar Sesión',
                    icono: Icons.login_rounded,
                    estaCargando: proveedor.estaCargando,
                    alPresionar: proveedor.estaCargando
                        ? null
                        : () => _manejarInicioSesion(proveedor),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Funcionalidad no disponible aún',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: tema.colorTextoSecundario,
                        ),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: GoogleFonts.poppins(
                        color: tema.colorPrimario,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

  Widget _construirEnlacesNavegacion(tema) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '¿No tienes una cuenta? ',
              style: GoogleFonts.poppins(
                color: tema.colorTextoSecundario,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () {
                NavegacionHelper.irARegistro(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Regístrate aquí',
                style: GoogleFonts.poppins(
                  color: tema.colorPrimario,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _manejarInicioSesion(ProveedorInicioSesion proveedor) async {
    if (_formKey.currentState?.validate() ?? false) {
      final esValido = proveedor.validarCredencialesIngresadas(
        nombreUsuario: _controladorNombreUsuario.text,
        contrasena: _controladorContrasena.text,
      );

      if (esValido) {
        await proveedor.iniciarProcesoInicioSesion(
          nombreUsuario: _controladorNombreUsuario.text,
          contrasena: _controladorContrasena.text,
        );

        if (mounted && proveedor.inicioSesionExitoso) {
          final proveedorEstado = Provider.of<ProveedorEstadoAutenticacion>(
            context,
            listen: false,
          );

          final servicioInactividad = Provider.of<ServicioInactividad>(
            context,
            listen: false,
          );

          if (proveedor.usuarioAutenticado != null) {
            // Generar token único para esta sesión
            final token =
                '${proveedor.usuarioAutenticado!.id}_${DateTime.now().millisecondsSinceEpoch}';

            // Guardar token y configurar timeout en almacenamiento encriptado
            await servicioInactividad.iniciarSesionConToken(token);

            await proveedorEstado.iniciarSesion(proveedor.usuarioAutenticado!);

            if (mounted) {
              NavegacionHelper.irAGastos(context);
            }
          }
        }
      }
    }
  }
}
