/// The [dart:async] is neccessary for using streams  
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:santiago4x4pro/models/carrito.dart';
import 'package:santiago4x4pro/models/intinerario.dart';
import 'package:santiago4x4pro/models/participante.dart';
import 'package:santiago4x4pro/models/producto.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/eventos/carrito_eventos.dart';

class CartItemsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartStreamController.stream;

  /// The [cartItems] Map would hold all the data this bloc provides
  List<Itinerario> cartItems = [];
  List<CarritoModel> cartItemsProductos = [];
  late UserModel userBloc;
  Color pickerColor = const Color(0xffffffff);
  File? imageAuto;
  bool updatePerfil = false;
  bool updateAuto = false;
  String? firma;
  List<Participante> participantes = [];

  bool dialog = false;



  void addDialog() {
    bloc.dialog = true;
    cartStreamController.sink.add(bloc.dialog);
  }

  void deleteDialog() {
    bloc.dialog = false;
    cartStreamController.sink.add(bloc.dialog);
  }

  void addParticipantes(Participante value) {
    bloc.participantes.add(value);
    cartStreamController.sink.add(bloc.participantes);
  }

  void deletePartipantes() {
    bloc.participantes = [];
    cartStreamController.sink.add(bloc.participantes);
  }

  void addFirma(value) {
    bloc.firma = value;
    cartStreamController.sink.add(bloc.firma);
  }

  void deleteFirma() {
    bloc.firma = null;
    cartStreamController.sink.add(bloc.firma);
  }

  void addUpdateAuto() {
    bloc.updateAuto = true;
    cartStreamController.sink.add(bloc.updateAuto);
  }

  void deleteUpdateAuto() {
    bloc.updateAuto = false;
    cartStreamController.sink.add(bloc.updateAuto);
  }

  void addUpdatePerfil() {
    bloc.updatePerfil = true;
    cartStreamController.sink.add(bloc.updatePerfil);
  }

  void deleteUpdatePerfil() {
    bloc.updatePerfil = false;
    cartStreamController.sink.add(bloc.updatePerfil);
  }

  void addFileAuto(File file) {
    bloc.imageAuto = file;
    cartStreamController.sink.add(bloc.imageAuto);
  }

  void deleteFileAuto() {
    bloc.imageAuto = null;
    cartStreamController.sink.add(imageAuto);
  }

  void changeColor(Color color) {
    bloc.pickerColor = color;
    cartStreamController.sink.add(pickerColor);
  }

  void deleteColor() {
    bloc.pickerColor = const Color(0xffffffff);
    cartStreamController.sink.add(pickerColor);
  }

  void addToCartProducto(CarritoModel item) {
    cartItemsProductos.add(item);
    cartStreamController.sink.add(cartItemsProductos);
  }

  void addToCart(Itinerario item) {
    cartItems.add(item);
    cartStreamController.sink.add(cartItems);
  }

  void updateToCart(Itinerario item) {
    for (var element in cartItems) {
      if(element.descripcion == item.descripcion) {
        element.cantidad = item.cantidad;
        element.costoTotal = item.costoTotal;
      }
    }
    cartStreamController.sink.add(cartItems);
  }

  void updateToCartProductos(CarritoModel item) {
    for (var element in cartItemsProductos) {
      if(element.descripcion == item.descripcion) {
        element.cantidad = item.cantidad;
        element.costoTotal = item.costoTotal;
      }
    }
    cartStreamController.sink.add(cartItemsProductos);
  }

  void removeFromCart(Itinerario item) {
    cartItems.remove(item);
    cartStreamController.sink.add(cartItems);
  }

  void removeFromCartProductos(CarritoModel item) {
    cartItemsProductos.remove(item);
    cartStreamController.sink.add(cartItemsProductos);
  }

  int counter() {
    int count = 0;
    for (var x in bloc.cartItems) {
      count += int.parse(x.cantidad);
    }
    return count;
  }

  double getPriceProductos() {
    double price = 0.00;
    for (var x in bloc.cartItemsProductos) {
      price += double.parse(x.costoTotal);
    }
    return price;
  }

  double getPrice() {
    double price = 0.00;
    for (var x in bloc.cartItems) {
      price += double.parse(x.costoTotal);
    }
    return price;
  }

  void deleteCartEvent() {
    bloc.cartItems = [];
    cartStreamController.sink.add(cartItems);
  }

  void deleteCartProduct() {
    bloc.cartItemsProductos = [];
    cartStreamController.sink.add(cartItemsProductos);
  }

  void addUserModel(UserModel usuarioBloc) {
    bloc.userBloc = usuarioBloc;
    cartStreamController.sink.add(bloc.userBloc);
  }

  // double searchItem(Producto item) {
  //   double precio = 0.0;
  //   bloc.cartItems.forEach((element) {
  //     if(element.descripcion == item.description) {
  //       precio = double.parse(element.price);
  //     } else {
  //       precio = 0.0;
  //     }
  //   });
  //   return precio;
  // }



  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();