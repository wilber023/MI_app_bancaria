import 'app_tema_base.dart';
import 'temas_implementados.dart';

class GestorTemas {
  static final Map<TipoTema, AppTema> _temas = {
    TipoTema.bancarioAzul: TemaBancarioAzul(),
    TipoTema.oscuroElegante: TemaOscuroElegante(),
    TipoTema.claroMinimal: TemaClaroMinimal(),
    TipoTema.doradoPremium: TemaDoradoPremium(),
  };

  static AppTema obtenerTema(TipoTema tipo) {
    return _temas[tipo] ?? TemaBancarioAzul();
  }

  static List<TipoTema> get tiposDisponibles => TipoTema.values;

  static TipoTema get temaDefault => TipoTema.bancarioAzul;

  static TipoTema? obtenerTipoPorId(String id) {
    try {
      return TipoTema.values.firstWhere((tema) => tema.id == id);
    } catch (e) {
      return null;
    }
  }
}
