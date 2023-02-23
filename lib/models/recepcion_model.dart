class RecepcionModel{

  int idrecepcion;
  String nombre;
  String empresa;
  String visita;
  String area;
  String fechaE;
  String horaE;
  String cajuelaE;
  String placaE;
  String fotocredencial;
  String cajuelaS;
  String placaS;
  String fechaS;
  String horaS;
  String createAtE;
  String userE;
  String createAtS;
  String userS;
  String estado;

  RecepcionModel({
    this.idrecepcion = 0,
    this.nombre = '',
    this.empresa = '',
    this.visita = '',
    this.area = '',
    this.fechaE = '',
    this.horaE = '',
    this.cajuelaE = '',
    this.placaE = '',
    this.fotocredencial = '',
    this.cajuelaS = '',
    this.placaS = '',
    this.fechaS = '',
    this.horaS = '',
    this.createAtE = '',
    this.userE = '',
    this.createAtS = '',
    this.userS = '',
    this.estado = '',
  });

 factory RecepcionModel.fromJson(Map<String, dynamic> parsedJson) {
    return RecepcionModel(
      idrecepcion: (parsedJson['id_recepcion'] != null) ? parsedJson['id_recepcion']: 0,     
      nombre: (parsedJson['nombre'] != null) ? parsedJson['nombre']: '',     
      empresa: (parsedJson['empresa'] != null) ? parsedJson['empresa']: '',     
      visita: (parsedJson['visita'] != null) ? parsedJson['visita']: '',    
      area: (parsedJson['area'] != null) ? parsedJson['area']: '',   
      fechaE: (parsedJson['fechaE'] != null) ? parsedJson['fechaE']: '',    
      horaE: (parsedJson['horaE'] != null) ? parsedJson['horaE']: '', 
      cajuelaE: (parsedJson['cajuelaE'] != null) ? parsedJson['cajuelaE']: '',     
      placaE: (parsedJson['placaE'] != null) ? parsedJson['placaE']: '',     
      fotocredencial: (parsedJson['fotocredencial'] != null) ? parsedJson['fotocredencial']: '',    
      cajuelaS: (parsedJson['cajuelaS'] != null) ? parsedJson['cajuelaS']: '',     
      placaS: (parsedJson['placaS'] != null) ? parsedJson['placaS']: '',  
      fechaS: (parsedJson['fechaS'] != null) ? parsedJson['fechaS']: '',   
      horaS: (parsedJson['horaS'] != null) ? parsedJson['horaS']: '',    
      createAtE: (parsedJson['createAtE'] != null) ? parsedJson['createAtE']: '',     
      userE: (parsedJson['userE'] != null) ? parsedJson['userE']: '',      
      createAtS: (parsedJson['createAtS'] != null) ? parsedJson['createAtS']: '',     
      userS: (parsedJson['userS'] != null) ? parsedJson['userS']: '',     
      estado: (parsedJson['estado'] != null) ? parsedJson['estado']: '',     
    );
  }

  List<RecepcionModel> fromJsonList(List<Map<String, dynamic>> listaParsedJson) {
    List<RecepcionModel> listaHistorial = [];
    RecepcionModel historial;
    for(int i = 0; i < listaParsedJson.length; i++) {
      historial = RecepcionModel.fromJson(listaParsedJson[i]);
      listaHistorial.add(historial);
    }
    return listaHistorial;
  }

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "empresa": empresa,
    "visita": visita,
    "area": area,
    "fechaE": fechaE,
    "horaE": horaE,
    "cajuelaE": cajuelaE,
    "placaE": placaE,
    "fotocredencial": fotocredencial,
    "cajuelaS": cajuelaS,
    "placaS": placaS,
    "fechaS": fechaS,
    "horaS": horaS,
    "createAtE": createAtE,
    "userE": userE,
    "createAtS": createAtS,
    "userS": userS,
    "estado": estado
  };

}
