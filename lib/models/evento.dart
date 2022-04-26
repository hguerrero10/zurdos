class Evento {
  String uid;
  String detalle;
  String empieza;
  String evento;
  String fecha;
  String lugar;
  String termina;
  String urlImage;

  Evento({
    required this.uid,
    required this.detalle,
    required this.empieza,
    required this.evento,
    required this.fecha,
    required this.lugar,
    required this.termina,
    required this.urlImage
    }
  );

  @override
  int get hashCode =>
    uid.hashCode ^
    detalle.hashCode ^
    empieza.hashCode ^
    evento.hashCode ^
    fecha.hashCode ^
    lugar.hashCode ^
    termina.hashCode ^
    urlImage.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Evento &&
      runtimeType == other.runtimeType &&
      detalle == other.detalle &&
      empieza == other.empieza &&
      evento == other.evento &&
      fecha == other.fecha &&
      lugar == other.lugar &&
      termina == other.termina &&
      urlImage == other.urlImage;

  @override
  String toString() {
    return 'Evento {uid: $uid, detalle: $detalle, empieza: $empieza, evento: $evento, fecha: $fecha, lugar: $lugar, termina: $termina, urlImage: $urlImage}';
  }
}