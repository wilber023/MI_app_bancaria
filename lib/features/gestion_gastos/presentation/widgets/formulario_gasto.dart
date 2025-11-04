import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../domain/entities/gasto_entidad.dart';
import '../../../autenticacion_usuario/presentation/providers/proveedor_inicio_sesion.dart';
import '../providers/proveedor_gastos.dart';
import '../../../../core/providers/proveedor_tema.dart';
import '../../../../core/routes/routes_app.dart';

class FormularioGasto extends StatefulWidget {
  final GastoEntidad? gastoParaEditar;

  const FormularioGasto({super.key, this.gastoParaEditar});

  @override
  State<FormularioGasto> createState() => _FormularioGastoState();
}

class _FormularioGastoState extends State<FormularioGasto> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _categoriaSeleccionada = 'Alimentación';
  DateTime _fechaSeleccionada = DateTime.now();
  bool _estaProcesando = false;

  final List<String> _categorias = [
    'Alimentación',
    'Transporte',
    'Entretenimiento',
    'Compras',
    'Salud',
    'Educación',
    'Servicios',
    'Otros',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.gastoParaEditar != null) {
      _cargarDatosParaEdicion();
    }
  }

  void _cargarDatosParaEdicion() {
    final gasto = widget.gastoParaEditar!;
    _montoController.text = gasto.monto.toString();
    _descripcionController.text = gasto.descripcion;
    _categoriaSeleccionada = gasto.categoria;
    _fechaSeleccionada = gasto.fecha;
  }

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorTema>(
      builder: (context, proveedorTema, child) {
        final tema = proveedorTema.temaActual;

        return Container(
          decoration: BoxDecoration(
            color: tema.colorFondo,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: tema.colorTextoSecundario.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEncabezado(tema),
                const SizedBox(height: 24),
                _buildFormulario(tema),
                const SizedBox(height: 24),
                _buildBotonesAccion(tema),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEncabezado(tema) {
    return FadeInDown(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.gastoParaEditar != null ? 'Editar Gasto' : 'Nuevo Gasto',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: tema.colorTexto,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                widget.gastoParaEditar != null
                    ? 'Modifica los detalles de tu gasto'
                    : 'Registra un nuevo gasto personal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: tema.colorTextoSecundario,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: tema.colorTextoSecundario.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => NavegacionHelper.regresar(context),
              icon: Icon(
                Icons.close_rounded,
                color: tema.colorTextoSecundario,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulario(tema) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: _buildCampoMonto(tema),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: _buildSelectorCategoria(tema),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: _buildCampoDescripcion(tema),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _buildSelectorFecha(tema),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoMonto(tema) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monto del Gasto',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: tema.colorTexto,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _montoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: GoogleFonts.poppins(
              color: tema.colorTexto,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
              prefixStyle: GoogleFonts.poppins(
                color: tema.colorPrimario,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              hintStyle: GoogleFonts.poppins(color: tema.colorTextoSecundario),
              filled: true,
              fillColor: tema.colorSuperficie,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: tema.colorTextoSecundario.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: tema.colorPrimario, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El monto es requerido';
              }
              final monto = double.tryParse(value);
              if (monto == null || monto <= 0) {
                return 'Ingrese un monto válido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorCategoria(tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoría del Gasto',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: tema.colorTexto,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: tema.colorSuperficie,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: tema.colorTextoSecundario.withOpacity(0.2),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _categoriaSeleccionada,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            dropdownColor: tema.colorSuperficie,
            style: GoogleFonts.poppins(
              color: tema.colorTexto,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            items: _categorias.map((categoria) {
              return DropdownMenuItem<String>(
                value: categoria,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getColorCategoria(categoria).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIconoCategoria(categoria),
                        color: _getColorCategoria(categoria),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      categoria,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _categoriaSeleccionada = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Seleccione una categoría';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCampoDescripcion(tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción del Gasto',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: tema.colorTexto,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descripcionController,
          maxLines: 3,
          style: GoogleFonts.poppins(
            color: tema.colorTexto,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Describe en qué gastaste el dinero...',
            hintStyle: GoogleFonts.poppins(color: tema.colorTextoSecundario),
            filled: true,
            fillColor: tema.colorSuperficie,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: tema.colorTextoSecundario.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: tema.colorPrimario, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La descripción es requerida';
            }
            if (value.length < 3) {
              return 'La descripción debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSelectorFecha(tema) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha del Gasto',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: tema.colorTexto,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _seleccionarFecha,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: tema.colorSuperficie,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: tema.colorTextoSecundario.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: tema.colorPrimario.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: tema.colorPrimario,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha seleccionada',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: tema.colorTextoSecundario,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: tema.colorTexto,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: tema.colorTextoSecundario,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonesAccion(tema) {
    return Row(
      children: [
        Expanded(
          child: FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: tema.colorTextoSecundario.withOpacity(0.3),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () => NavegacionHelper.regresar(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: tema.colorTextoSecundario,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: Container(
              decoration: BoxDecoration(
                gradient: tema.gradientePrincipal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: tema.colorPrimario.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _estaProcesando ? null : _guardarGasto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _estaProcesando
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        widget.gastoParaEditar != null
                            ? 'Actualizar Gasto'
                            : 'Guardar Gasto',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _seleccionarFecha() async {
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaSeleccionada = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _estaProcesando = true;
    });

    try {
      final usuarioId = context
          .read<ProveedorInicioSesion>()
          .usuarioAutenticado
          ?.id;
      if (usuarioId == null) {
        setState(() {
          _estaProcesando = false;
        });
        _mostrarError('Error: Usuario no autenticado');
        return;
      }

      final monto = double.parse(_montoController.text);
      final descripcion = _descripcionController.text.trim();

      bool exitoso = false;
      final proveedorGastos = context.read<ProveedorGastos>();

      if (widget.gastoParaEditar != null) {
        final gastoActualizado = GastoEntidad(
          id: widget.gastoParaEditar!.id,
          usuarioId: usuarioId,
          monto: monto,
          categoria: _categoriaSeleccionada,
          descripcion: descripcion,
          fecha: _fechaSeleccionada,
          fechaCreacion: widget.gastoParaEditar!.fechaCreacion,
        );

        exitoso = await proveedorGastos.actualizarGasto(gastoActualizado);
      } else {
        exitoso = await proveedorGastos.crearGasto(
          usuarioId: usuarioId,
          monto: monto,
          categoria: _categoriaSeleccionada,
          descripcion: descripcion,
          fecha: _fechaSeleccionada,
        );
      }

      setState(() {
        _estaProcesando = false;
      });

      if (exitoso) {
        NavegacionHelper.regresar(context);
        _mostrarExito(
          widget.gastoParaEditar != null
              ? 'Gasto actualizado correctamente'
              : 'Gasto creado correctamente',
        );
      } else {
        final errorEspecifico =
            proveedorGastos.mensajeError ??
            'Error desconocido al guardar el gasto';
        _mostrarError('Error: $errorEspecifico');
      }
    } catch (e) {
      setState(() {
        _estaProcesando = false;
      });
      _mostrarError('Error inesperado: ${e.toString()}');
    }
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  IconData _getIconoCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
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

  Color _getColorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
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
