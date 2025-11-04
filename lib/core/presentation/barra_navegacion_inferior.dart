import 'package:flutter/material.dart';
import '../routes/routes_app.dart';

class BarraNavegacionInferior extends StatelessWidget {
  final String rutaActual;

  const BarraNavegacionInferior({super.key, required this.rutaActual});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _obtenerIndiceActual(),
      onTap: (index) => _navegarAIndice(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Gastos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Estadisticas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuracion',
        ),
      ],
    );
  }

  int _obtenerIndiceActual() {
    switch (rutaActual) {
      case '/gastos':
        return 0;
      case '/estadisticas':
        return 1;
      case '/gastos/configuracion':
        return 2;
      default:
        return 0;
    }
  }

  void _navegarAIndice(BuildContext context, int index) {
    switch (index) {
      case 0:
        NavegacionHelper.irAGastos(context);
        break;
      case 1:
        NavegacionHelper.irAEstadisticas(context);
        break;
      case 2:
        NavegacionHelper.irAConfiguracion(context);
        break;
    }
  }
}
