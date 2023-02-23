import 'dart:async';

class FormatoBloc{

  final formatoStream = StreamController.broadcast();
  Stream get getStream => formatoStream.stream;

  String? firmaChofer;
  String? firmaSeguridad;

  String? comentario1;
  String? comentario2;
  String? comentario3;
  String? comentario4;
  String? comentario5;

  String? opcion1;
  String? opcion2;
  String? opcion3;
  String? opcion4;
  String? opcion5;

  /////////////////////////////////////
  ////       FirmaChofer
  ////////////////////////////////////
  void firmaChoferAdd(firmaChofer) {
    formatoBloc.firmaChofer = firmaChofer;
    formatoBloc.formatoStream.sink.add(firmaChofer);
  }

  void firmaChoferDelete() {
    formatoBloc.firmaChofer = null;
    formatoBloc.formatoStream.sink.add(firmaChofer);
  }
  
  
  /////////////////////////////////////
  ////       FirmaSeguridad
  ////////////////////////////////////
  void firmaSeguridadAdd(firmaSeguridad) {
    formatoBloc.firmaSeguridad = firmaSeguridad;
    formatoBloc.formatoStream.sink.add(firmaSeguridad);
  }

  void firmaSeguridadDelete() {
    formatoBloc.firmaSeguridad = null;
    formatoBloc.formatoStream.sink.add(firmaSeguridad);
  }

  /////////////////////////////////////
  ////       Comentario1
  ////////////////////////////////////
  void comentario1Add(comentario1) {
    formatoBloc.comentario1 = comentario1;
    formatoBloc.formatoStream.sink.add(comentario1);
  }

  void comentario1Delete() {
    formatoBloc.comentario1 = null;
    formatoBloc.formatoStream.sink.add(comentario1);
  }

  /////////////////////////////////////
  ////       Comentario2
  ////////////////////////////////////
  void comentario2Add(comentario2) {
    formatoBloc.comentario2 = comentario2;
    formatoBloc.formatoStream.sink.add(comentario2);
  }

  void comentario2Delete() {
    formatoBloc.comentario2 = null;
    formatoBloc.formatoStream.sink.add(comentario2);
  }

  /////////////////////////////////////
  ////       Comentario3
  ////////////////////////////////////
  void comentario3Add(comentario3) {
    formatoBloc.comentario3 = comentario3;
    formatoBloc.formatoStream.sink.add(comentario3);
  }

  void comentario3Delete() {
    formatoBloc.comentario3 = null;
    formatoBloc.formatoStream.sink.add(comentario3);
  }

  /////////////////////////////////////
  ////       Comentario4
  ////////////////////////////////////
  void comentario4Add(comentario4) {
    formatoBloc.comentario4 = comentario4;
    formatoBloc.formatoStream.sink.add(comentario4);
  }

  void comentario4Delete() {
    formatoBloc.comentario4 = null;
    formatoBloc.formatoStream.sink.add(comentario4);
  }

  /////////////////////////////////////
  ////       Comentario5
  ////////////////////////////////////
  void comentario5Add(comentario5) {
    formatoBloc.comentario5 = comentario5;
    formatoBloc.formatoStream.sink.add(comentario5);
  }

  void comentario5Delete() {
    formatoBloc.comentario5 = null;
    formatoBloc.formatoStream.sink.add(comentario5);
  }

  /////////////////////////////////////
  ////       Opcion1
  ////////////////////////////////////
  void opcion1Add(opcion1) {
    formatoBloc.opcion1 = opcion1;
    formatoBloc.formatoStream.sink.add(opcion1);
  }

  void opcion1Delete() {
    formatoBloc.opcion1 = null;
    formatoBloc.formatoStream.sink.add(opcion1);
  }
  /////////////////////////////////////
  ////       Opcion2
  ////////////////////////////////////
  void opcion2Add(opcion2) {
    formatoBloc.opcion2 = opcion2;
    formatoBloc.formatoStream.sink.add(opcion2);
  }

  void opcion2Delete() {
    formatoBloc.opcion2 = null;
    formatoBloc.formatoStream.sink.add(opcion2);
  }
  /////////////////////////////////////
  ////       Opcion3
  ////////////////////////////////////
  void opcion3Add(opcion3) {
    formatoBloc.opcion3 = opcion3;
    formatoBloc.formatoStream.sink.add(opcion3);
  }

  void opcion3Delete() {
    formatoBloc.opcion3 = null;
    formatoBloc.formatoStream.sink.add(opcion3);
  }
  /////////////////////////////////////
  ////       Opcion4
  ////////////////////////////////////
  void opcion4Add(opcion4) {
    formatoBloc.opcion4 = opcion4;
    formatoBloc.formatoStream.sink.add(opcion4);
  }

  void opcion4Delete() {
    formatoBloc.opcion4 = null;
    formatoBloc.formatoStream.sink.add(opcion4);
  }
  /////////////////////////////////////
  ////       Opcion5
  ////////////////////////////////////
  void opcion5Add(opcion5) {
    formatoBloc.opcion5 = opcion5;
    formatoBloc.formatoStream.sink.add(opcion5);
  }

  void opcion5Delete() {
    formatoBloc.opcion5 = null;
    formatoBloc.formatoStream.sink.add(opcion5);
  }
  

  void dispose() {
    formatoStream.close(); // close our StreamController
  }
}
final formatoBloc = FormatoBloc();