import 'package:santiago4x4pro/models/ordenes.dart';

class ListaOrdenesModel{
  
  List<OrdenesModel> listaOrdenes;

  ListaOrdenesModel({
    this.listaOrdenes = const []
  });

    factory ListaOrdenesModel.fromJson(List<Map<String, dynamic>>  parsedJson) {
    List<Map<String, dynamic>> listaRegistros = [];

    if (parsedJson.isNotEmpty) {
      for (int i = 0; i < parsedJson.length; i++) {
        listaRegistros.add(parsedJson[i]);
      }
    }

    return ListaOrdenesModel(
      listaOrdenes: (parsedJson.isNotEmpty)
          ? OrdenesModel().fromJsonList(listaRegistros)
          : [],
    );
  }
}