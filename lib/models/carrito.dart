class CarritoModel {
  String uid;
  String descripcion;
  String precio;
  String costoTotal;
  String cantidad;
  String urlImage;

  CarritoModel({
    required this.uid,
    required this.descripcion,
    required this.precio,
    required this.costoTotal,
    required this.cantidad,
    required this.urlImage,
  });

  @override
  String toString() {
    return 'CarritoModel {uid: $uid, descripcion: $descripcion, costo: $precio,  costoTotal: $costoTotal,  cantidad: $cantidad }';
  }
}