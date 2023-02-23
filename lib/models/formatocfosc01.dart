class FormatoModel{

  int idFormato;
  String folio;
  String tipo;
  String fecha;
  String hora;
  String nombreSeguridad;
  String firmaSeguridad;
  String nombreChofer;
  String firmaChofer;
  String licenciaChofer;
  String fotoLicencia;
  String fotoSello;
  String sello;
  String ecoTracto;
  String placasTracto;
  String ecoCaja;
  String opcion1;
  String comentario1;
  String opcion2;
  String comentario2;
  String opcion3;
  String comentario3;
  String opcion4;
  String comentario4;
  String opcion5;
  String comentario5;
  String opcion6;
  String comentario6;
  String opcion7;
  String comentario7;
  String opcion8;
  String comentario8;
  String opcion9;
  String comentario9;
  String opcion10;
  String comentario10;
  String opcion11;
  String comentario11;
  String opcion12;
  String comentario12;
  String opcion13;
  String comentario13;
  String opcion14;
  String comentario14;
  String opcion15;
  String comentario15;
  String opcion16;
  String comentario16;
  String createAt;
  String creatorUser;
  String status;

  FormatoModel({
    this.idFormato = 0,
    this.folio = '',
    this.tipo = '',
    this.fecha = '',
    this.hora = '',
    this.nombreSeguridad = '',
    this.firmaSeguridad = '',
    this.nombreChofer = '',
    this.firmaChofer = '',
    this.licenciaChofer = '',
    this.fotoLicencia = '',
    this.fotoSello = '',
    this.sello = '',
    this.ecoTracto = '',
    this.placasTracto = '',
    this.ecoCaja = '',
    this.opcion1 = '',
    this.comentario1 = '',
    this.opcion2 = '',
    this.comentario2 = '',
    this.opcion3 = '',
    this.comentario3 = '',
    this.opcion4 = '',
    this.comentario4 = '',
    this.opcion5 = '',
    this.comentario5 = '',
    this.opcion6 = '',
    this.comentario6 = '',
    this.opcion7 = '',
    this.comentario7 = '',
    this.opcion8 = '',
    this.comentario8 = '',
    this.opcion9 = '',
    this.comentario9 = '',
    this.opcion10 = '',
    this.comentario10 = '',
    this.opcion11 = '',
    this.comentario11 = '',
    this.opcion12 = '',
    this.comentario12 = '',
    this.opcion13 = '',
    this.comentario13 = '',
    this.opcion14 = '',
    this.comentario14 = '',
    this.opcion15 = '',
    this.comentario15 = '',
    this.opcion16 = '',
    this.comentario16 = '',
    this.createAt = '',
    this.creatorUser = '',
    this.status = '',
  });

 factory FormatoModel.fromJson(Map<String, dynamic> parsedJson) {
    return FormatoModel(
      idFormato: (parsedJson['id_recepcion'] != null) ? parsedJson['id_recepcion']: 0,     
        folio: (parsedJson['folio'] != null) ? parsedJson['folio']: '',
        tipo: (parsedJson['tipo'] != null) ? parsedJson['tipo']: '',
        fecha: (parsedJson['fecha'] != null) ? parsedJson['fecha']: '',
        hora: (parsedJson['hora'] != null) ? parsedJson['hora']: '',
        nombreSeguridad: (parsedJson['nombreSeguridad'] != null) ? parsedJson['nombreSeguridad']: '',
        firmaSeguridad: (parsedJson['firmaSeguridad'] != null) ? parsedJson['firmaSeguridad']: '',
        nombreChofer: (parsedJson['nombreChofer'] != null) ? parsedJson['nombreChofer']: '',
        firmaChofer: (parsedJson['firmaChofer'] != null) ? parsedJson['firmaChofer']: '',
        licenciaChofer: (parsedJson['licenciaChofer'] != null) ? parsedJson['licenciaChofer']: '',
        fotoLicencia: (parsedJson['fotoLicencia'] != null) ? parsedJson['fotoLicencia']: '',
        fotoSello: (parsedJson['fotoSello'] != null) ? parsedJson['fotoSello']: '',
        sello: (parsedJson['sello'] != null) ? parsedJson['sello']: '',
        ecoTracto: (parsedJson['ecoTracto'] != null) ? parsedJson['ecoTracto']: '',
        placasTracto: (parsedJson['placasTracto'] != null) ? parsedJson['placasTracto']: '',
        ecoCaja: (parsedJson['ecoCaja'] != null) ? parsedJson['ecoCaja']: '',
        opcion1: (parsedJson['opcion1'] != null) ? parsedJson['opcion1']: '',
        comentario1: (parsedJson['comentario1'] != null) ? parsedJson['comentario1']: '',
        opcion2: (parsedJson['opcion2'] != null) ? parsedJson['opcion2']: '',
        comentario2: (parsedJson['comentario2'] != null) ? parsedJson['comentario2']: '',
        opcion3: (parsedJson['opcion3'] != null) ? parsedJson['opcion3']: '',
        comentario3: (parsedJson['comentario3'] != null) ? parsedJson['comentario3']: '',
        opcion4: (parsedJson['opcion4'] != null) ? parsedJson['opcion4']: '',
        comentario4: (parsedJson['comentario4'] != null) ? parsedJson['comentario4']: '',
        opcion5: (parsedJson['opcion5'] != null) ? parsedJson['opcion5']: '',
        comentario5: (parsedJson['comentario5'] != null) ? parsedJson['comentario5']: '',
        opcion6: (parsedJson['opcion6'] != null) ? parsedJson['opcion6']: '',
        comentario6: (parsedJson['comentario6'] != null) ? parsedJson['comentario6']: '',
        opcion7: (parsedJson['opcion7'] != null) ? parsedJson['opcion7']: '',
        comentario7: (parsedJson['comentario7'] != null) ? parsedJson['comentario7']: '',
        opcion8: (parsedJson['opcion8'] != null) ? parsedJson['opcion8']: '',
        comentario8: (parsedJson['comentario8'] != null) ? parsedJson['comentario8']: '',
        opcion9: (parsedJson['opcion9'] != null) ? parsedJson['opcion9']: '',
        comentario9: (parsedJson['comentario9'] != null) ? parsedJson['comentario9']: '',
        opcion10: (parsedJson['opcion10'] != null) ? parsedJson['opcion10']: '',
        comentario10: (parsedJson['comentario10'] != null) ? parsedJson['comentario10']: '',
        opcion11: (parsedJson['opcion11'] != null) ? parsedJson['opcion11']: '',
        comentario11: (parsedJson['comentario11'] != null) ? parsedJson['comentario11']: '',
        opcion12: (parsedJson['opcion12'] != null) ? parsedJson['opcion12']: '',
        comentario12: (parsedJson['comentario12'] != null) ? parsedJson['comentario12']: '',
        opcion13: (parsedJson['opcion13'] != null) ? parsedJson['opcion13']: '',
        comentario13: (parsedJson['comentario13'] != null) ? parsedJson['comentario13']: '',
        opcion14: (parsedJson['opcion14'] != null) ? parsedJson['opcion14']: '',
        comentario14: (parsedJson['comentario14'] != null) ? parsedJson['comentario14']: '',
        opcion15: (parsedJson['opcion15'] != null) ? parsedJson['opcion15']: '',
        comentario15: (parsedJson['comentario15'] != null) ? parsedJson['comentario15']: '',
        opcion16: (parsedJson['opcion16'] != null) ? parsedJson['opcion16']: '',
        comentario16: (parsedJson['comentario16'] != null) ? parsedJson['comentario16']: '',
        createAt: (parsedJson['createAt'] != null) ? parsedJson['createAt']: '',
        creatorUser: (parsedJson['creatorUser'] != null) ? parsedJson['creatorUser']: '',
        status: (parsedJson['status'] != null) ? parsedJson['status']: '',
    );
  }

  List<FormatoModel> fromJsonList(List<Map<String, dynamic>> listaParsedJson) {
    List<FormatoModel> listaHistorial = [];
    FormatoModel historial;
    for(int i = 0; i < listaParsedJson.length; i++) {
      historial = FormatoModel.fromJson(listaParsedJson[i]);
      listaHistorial.add(historial);
    }
    return listaHistorial;
  }

  Map<String, dynamic> toJson() => {
   "folio": folio,
   "tipo": tipo,
   "fecha": fecha,
   "hora": hora,
   "nombreSeguridad": nombreSeguridad,
   "firmaSeguridad": firmaSeguridad,
   "nombreChofer": nombreChofer,
   "firmaChofer": firmaChofer,
   "licenciaChofer": licenciaChofer,
   "fotoLicencia": fotoLicencia,
   "fotoSello": fotoSello,
   "sello": sello,
   "ecoTracto": ecoTracto,
   "placasTracto": placasTracto,
   "ecoCaja": ecoCaja,
   "opcion1": opcion1,
   "comentario1": comentario1,
   "opcion2": opcion2,
   "comentario2": comentario2,
   "opcion3": opcion3,
   "comentario3": comentario3,
   "opcion4": opcion4,
   "comentario4": comentario4,
   "opcion5": opcion5,
   "comentario5": comentario5,
   "opcion6": opcion6,
   "comentario6": comentario6,
   "opcion7": opcion7,
   "comentario7": comentario7,
   "opcion8": opcion8,
   "comentario8": comentario8,
   "opcion9": opcion9,
   "comentario9": comentario9,
   "opcion10": opcion10,
   "comentario10": comentario10,
   "opcion11": opcion11,
   "comentario11": comentario11,
   "opcion12": opcion12,
   "comentario12": comentario12,
   "opcion13": opcion13,
   "comentario13": comentario13,
   "opcion14": opcion14,
   "comentario14": comentario14,
   "opcion15": opcion15,
   "comentario15": comentario15,
   "opcion16": opcion16,
   "comentario16": comentario16,
   "createAt": createAt,
   "creatorUser": creatorUser,
   "status": status,
  };

}
