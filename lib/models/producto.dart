class Producto {
  String uid;
  String producto;
  String talla;
  String descripcion;
  String precio;
  String urlImage;
  String categoria;

  Producto(
    {
      required this.uid,
      required this.producto,
      required this.talla,
      required this.descripcion,
      required this.precio,
      required this.urlImage,
      required this.categoria
    }
  );

  @override
  int get hashCode =>
    uid.hashCode ^
    producto.hashCode ^
    talla.hashCode ^
    descripcion.hashCode ^
    precio.hashCode ^
    urlImage.hashCode ^
    categoria.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Producto &&
      runtimeType == other.runtimeType &&
      producto == other.producto &&
      talla == other.talla &&
      descripcion == other.descripcion &&
      precio == other.precio &&
      urlImage == other.urlImage &&
      categoria == other.categoria;

  @override
  String toString() {
    return 'Producto {uid: $uid, producto: $producto, talla: $talla, descripcion: $descripcion, precio: $precio, urlImage: $urlImage, categoria: $categoria }';
  }
}