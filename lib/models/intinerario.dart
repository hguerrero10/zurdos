class Itinerario {
  String uid;
  String descripcion;
  String precio;
  String costoTotal;
  String cantidad;

  Itinerario({
    required this.uid,
    required this.descripcion,
    required this.precio,
    required this.costoTotal,
    required this.cantidad,
  });

  @override
  String toString() {
    return 'Itinerario {uid: $uid, descripcion: $descripcion, costo: $precio,  costoTotal: $costoTotal,  cantidad: $cantidad }';
  }
}