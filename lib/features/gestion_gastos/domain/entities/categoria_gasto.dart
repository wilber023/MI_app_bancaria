class CategoriaGasto {
  final String nombre;
  final String icono;
  final String color;

  const CategoriaGasto({
    required this.nombre,
    required this.icono,
    required this.color,
  });

  static const List<CategoriaGasto> categoriasDefault = [
    CategoriaGasto(nombre: 'Alimentación', icono: '🍽️', color: 'FF4CAF50'),
    CategoriaGasto(nombre: 'Transporte', icono: '🚗', color: 'FF2196F3'),
    CategoriaGasto(nombre: 'Entretenimiento', icono: '🎬', color: 'FF9C27B0'),
    CategoriaGasto(nombre: 'Salud', icono: '🏥', color: 'FFF44336'),
    CategoriaGasto(nombre: 'Educación', icono: '📚', color: 'FF607D8B'),
    CategoriaGasto(nombre: 'Compras', icono: '🛍️', color: 'FFFF9800'),
    CategoriaGasto(nombre: 'Servicios', icono: '🏠', color: 'FF795548'),
    CategoriaGasto(nombre: 'Otros', icono: '📝', color: 'FF9E9E9E'),
  ];
}
