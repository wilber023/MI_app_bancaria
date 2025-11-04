import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/proveedor_registro_usuario.dart';
import '../widgets/campo_texto_simple.dart';
import '../widgets/boton_simple.dart';
import '../widgets/tarjeta_mensaje.dart';
import '../../../../core/routes/routes_app.dart';

class PaginaRegistroUsuario extends StatefulWidget {
  const PaginaRegistroUsuario({super.key});

  @override
  State<PaginaRegistroUsuario> createState() => _PaginaRegistroUsuarioState();
}

class _PaginaRegistroUsuarioState extends State<PaginaRegistroUsuario>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _controladorNombreUsuario = TextEditingController();
  final _controladorCorreo = TextEditingController();
  final _controladorNombre = TextEditingController();

  final _controladorContrasena = TextEditingController();
  final _controladorConfirmarContrasena = TextEditingController();

  late AnimationController _controladorAnimacionFondo;
  late Animation<double> _animacionFondo;

  @override
  void initState() {
    super.initState();
    _controladorAnimacionFondo = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _animacionFondo = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controladorAnimacionFondo, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controladorNombreUsuario.dispose();
    _controladorCorreo.dispose();
    _controladorNombre.dispose();

    _controladorContrasena.dispose();
    _controladorConfirmarContrasena.dispose();
    _scrollController.dispose();
    _controladorAnimacionFondo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _construirFondoAnimado(),

          SafeArea(
            child: Column(
              children: [
                _construirAppBarPersonalizado(),

                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          _construirHeader(),

                          const SizedBox(height: 32),

                          _construirFormularioRegistro(),

                          const SizedBox(height: 32),

                          _construirEnlacesNavegacion(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFondoAnimado() {
    return AnimatedBuilder(
      animation: _animacionFondo,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                const Color(0xFF8B5CF6).withOpacity(0.1),
                const Color(0xFF06B6D4).withOpacity(0.05),
                const Color(0xFF10B981).withOpacity(0.1),
              ],
              stops: [0.0, 0.5 + 0.3 * _animacionFondo.value, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _construirAppBarPersonalizado() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => NavegacionHelper.regresar(context),
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6366F1)),
            ),
            const Expanded(
              child: Text(
                'Crear Cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _construirHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_add_outlined,
              size: 40,
              color: Color(0xFF8B5CF6),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '¡Únete a nosotros!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Crea tu cuenta y comienza esta increíble experiencia',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _construirFormularioRegistro() {
    return Consumer<ProveedorRegistroUsuario>(
      builder: (context, proveedor, child) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              if (proveedor.mensajeError != null)
                TarjetaMensaje(
                  mensaje: proveedor.mensajeError!,
                  tipo: TipoMensaje.error,
                  alCerrar: () => proveedor.limpiarError(),
                ),

              if (proveedor.erroresValidacion.isNotEmpty)
                ...proveedor.erroresValidacion.map(
                  (error) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TarjetaMensaje(
                      mensaje: error,
                      tipo: TipoMensaje.advertencia,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              _construirSeccionFormulario('Información Personal', [
                CampoTextoSimple(
                  etiqueta: 'Nombre',
                  sugerencia: 'Tu nombre',
                  controlador: _controladorNombre,
                  icono: Icons.person_outline,
                  esRequerido: true,
                  habilitado: !proveedor.estaCargando,
                  validador: _validarNombre,
                ),
              ]),

              const SizedBox(height: 24),

              _construirSeccionFormulario('Información de Cuenta', [
                CampoTextoSimple(
                  etiqueta: 'Nombre de Usuario',
                  sugerencia: 'Elige un nombre de usuario único',
                  controlador: _controladorNombreUsuario,
                  icono: Icons.alternate_email,
                  esRequerido: true,
                  habilitado: !proveedor.estaCargando,
                  validador: _validarNombreUsuario,
                ),

                const SizedBox(height: 16),

                CampoTextoSimple(
                  etiqueta: 'Correo Electrónico',
                  sugerencia: 'tu.email@ejemplo.com',
                  controlador: _controladorCorreo,
                  icono: Icons.email_outlined,
                  tipoTeclado: TextInputType.emailAddress,
                  esRequerido: true,
                  habilitado: !proveedor.estaCargando,
                  validador: _validarCorreoElectronico,
                ),
              ]),

              const SizedBox(height: 24),

              _construirSeccionFormulario('Seguridad', [
                CampoTextoSimple(
                  etiqueta: 'Contraseña',
                  sugerencia: 'Mínimo 6 caracteres',
                  controlador: _controladorContrasena,
                  icono: Icons.lock_outline,
                  esContrasena: true,
                  esRequerido: true,
                  habilitado: !proveedor.estaCargando,
                  validador: _validarContrasena,
                ),

                const SizedBox(height: 16),

                CampoTextoSimple(
                  etiqueta: 'Confirmar Contraseña',
                  sugerencia: 'Repite tu contraseña',
                  controlador: _controladorConfirmarContrasena,
                  icono: Icons.lock_outline,
                  esContrasena: true,
                  esRequerido: true,
                  habilitado: !proveedor.estaCargando,
                  validador: _validarConfirmacionContrasena,
                ),
              ]),

              const SizedBox(height: 32),

              BotonSimple(
                texto: 'Crear Cuenta',
                icono: Icons.person_add,
                estaCargando: proveedor.estaCargando,
                alPresionar: proveedor.estaCargando
                    ? null
                    : () => _manejarRegistro(proveedor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirSeccionFormulario(String titulo, List<Widget> campos) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            ...campos,
          ],
        ),
      ),
    );
  }

  Widget _construirEnlacesNavegacion() {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Ya tienes cuenta? ',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          TextButton(
            onPressed: () => NavegacionHelper.regresar(context),
            child: const Text(
              'Inicia Sesión',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validarNombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    if (valor.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? _validarNombreUsuario(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    if (valor.trim().length < 3) {
      return 'El nombre de usuario debe tener al menos 3 caracteres';
    }
    if (valor.trim().length > 20) {
      return 'El nombre de usuario no puede exceder 20 caracteres';
    }
    return null;
  }

  String? _validarCorreoElectronico(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(valor.trim())) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  String? _validarContrasena(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (valor.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validarConfirmacionContrasena(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Debes confirmar la contraseña';
    }
    if (valor != _controladorContrasena.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _manejarRegistro(ProveedorRegistroUsuario proveedor) async {
    if (_formKey.currentState?.validate() ?? false) {
      final esValido = proveedor.validarDatosRegistroIngresados(
        nombreUsuario: _controladorNombreUsuario.text,
        correoElectronico: _controladorCorreo.text,
        contrasena: _controladorContrasena.text,
        confirmarContrasena: _controladorConfirmarContrasena.text,
        nombre: _controladorNombre.text,
      );

      if (esValido) {
        await proveedor.iniciarProcesoRegistroUsuario(
          nombreUsuario: _controladorNombreUsuario.text,
          correoElectronico: _controladorCorreo.text,
          contrasena: _controladorContrasena.text,
          confirmarContrasena: _controladorConfirmarContrasena.text,
          nombre: _controladorNombre.text,
        );

        if (mounted && proveedor.registroExitoso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Registro exitoso! Ahora puedes iniciar sesión'),
              backgroundColor: Color(0xFF10B981),
            ),
          );

          NavegacionHelper.regresar(context);
        } else if (mounted && !proveedor.registroExitoso) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error en registro: ${proveedor.mensajeError ?? "Error desconocido"}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
