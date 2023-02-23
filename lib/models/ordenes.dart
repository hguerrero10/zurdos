class OrdenesModel{

  String cliente;
  String destino;
  String fechaHora;
  String ecoTracto;
  String remolquePlacas;
  String pies;
  String tipo;
  String ecoDolly;
  String remolquePlacas2;
  String pies2;
  String tipo2;
  String folio;
  String nombreChofer;
  String licenciaChofer;
  String createAt;

  OrdenesModel({
    this.cliente = '',
    this.destino = '',
    this.fechaHora = '',
    this.ecoTracto = '',
    this.remolquePlacas = '',
    this.pies = '',
    this.tipo = '',
    this.ecoDolly = '',
    this.remolquePlacas2 = '',
    this.pies2 = '',
    this.tipo2 = '',
    this.folio = '',
    this.nombreChofer = '',
    this.licenciaChofer = '',
    this.createAt = '',
  });

  factory OrdenesModel.fromJson(Map<String, dynamic> parsedJson) {
    return OrdenesModel(
      cliente: (parsedJson['cliente'] != null) ? parsedJson['cliente'] : '',
      destino: (parsedJson['destino'] != null) ? parsedJson['destino'] : '',
      fechaHora: (parsedJson['fechaHora'] != null) ? parsedJson['fechaHora'] : '',
      ecoTracto: (parsedJson['ecoTracto'] != null) ? parsedJson['ecoTracto'] : '',
      remolquePlacas: (parsedJson['remolquePlacas'] != null) ? parsedJson['remolquePlacas'] : '',
      pies: (parsedJson['pies'] != null) ? parsedJson['pies'] : '',
      tipo: (parsedJson['tipo'] != null) ? parsedJson['tipo'] : '',
      ecoDolly: (parsedJson['ecoDolly'] != null) ? parsedJson['ecoDolly'] : '',
      remolquePlacas2: (parsedJson['remolquePlacas2'] != null) ? parsedJson['remolquePlacas2'] : '',
      pies2: (parsedJson['pies2'] != null) ? parsedJson['pies2'] : '',
      tipo2: (parsedJson['tipo2'] != null) ? parsedJson['tipo2'] : '',
      folio: (parsedJson['folio'] != null) ? parsedJson['folio'] : '',
      nombreChofer: (parsedJson['nombreChofer'] != null) ? parsedJson['nombreChofer'] : '',
      licenciaChofer: (parsedJson['licenciaChofer'] != null) ? parsedJson['licenciaChofer'] : '',
      createAt: (parsedJson['createAt'] != null) ? parsedJson['createAt'] : '',
    );
  }

  List<OrdenesModel> fromJsonList(List<Map<String, dynamic>> listaParsedJson) {
    List<OrdenesModel> listaHistorial = [];
    OrdenesModel historial;
    for(int i = 0; i < listaParsedJson.length; i++) {
      historial = OrdenesModel.fromJson(listaParsedJson[i]);
      listaHistorial.add(historial);
    }
    return listaHistorial;
  }

}