class Auto {
  String uid;
  String seguro;
  String color;
  String marca;
  String modelo;
  String urlImage;
  String placa;
  String createAt;

  Auto(
    {
      required this.uid,
      required this.seguro,
      required this.color,
      required this.marca,
      required this.modelo,
      required this.urlImage,
      required this.placa,
      required this.createAt
    }
  );

  @override
  String toString() {
    return 'Auto {seguro: $seguro, color: $color, marca: $marca, modelo: $modelo, urlImage: $urlImage, placa: $placa, createAt: $createAt }';
  }
}