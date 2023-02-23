import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/widget/toast.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/models/recepcion_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';


class RecepcionSalida extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;

  final RecepcionModel recepcionModel;

  const RecepcionSalida({ Key? key, required this.userRepository,  required this.user, required this.recepcionModel }) : super(key: key);

  @override
  State<RecepcionSalida> createState() => _RecepcionSalidaState();
}

class _RecepcionSalidaState extends State<RecepcionSalida> {
  String urlAddRecepcion = 'https://zurdosapi.tlk.com.mx/addSalidaRecepcion';

  var date = DateFormat.yMMMMd('es');
  var hour = DateFormat.Hm('es');
  var dateString = '';
  var hourString = '';

  List images1 = [];
  List images2 = [];

  String? urlCajuela;
  String? urlPlaca;

  File? cajuelaEn; 
  bool? validateCajuelaEn;
  String? base64CajuelaEn;

  File? placaEn; 
  bool? validatePlacaEn;
  String? base64PlacaEn;

  final pickerCajuelaEn = ImagePicker();
  final pickerPlacaEn = ImagePicker();

  List<Asset> imagesCajuela = <Asset>[];
  List<Asset> imagesPlaca = <Asset>[];

  @override
  void initState() {
    dateString = date.format(DateTime.now());
    hourString = hour.format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        backgroundColor: Color(0xfb234798),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [

              _encabezadoText('Nombre'),
              _detalleText(widget.recepcionModel.nombre),
              SizedBox(height: 10),

              _encabezadoText('Empresa'),
              _detalleText(widget.recepcionModel.nombre),
              SizedBox(height: 10),

              _encabezadoText('Visito a'),
              _detalleText(widget.recepcionModel.visita),
              SizedBox(height: 10),

              _encabezadoText('Area'),
              _detalleText(widget.recepcionModel.area),
              SizedBox(height: 30),

              Text(
                'Fecha: ' + dateString,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              
              SizedBox(height: 10),
              Text(
                'Hora: ' + hourString,
                style: TextStyle(   
                  fontSize: 25,
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      loadAssets();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xfbb0afb5)
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                          'Caja/Cajuela',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white
                          ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      loadAssetsPlaca();
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xfbb0afb5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,color: Colors.white),
                            SizedBox(width: 5),
                          Text(
                            'Placa',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                ],
              ),

              SizedBox(height: 30),

              GestureDetector(
                onTap: () async {
                  RespuestaUtilityModel respuestaUtilityModel = await insertarSalida();
                  if(!respuestaUtilityModel.error) {
                    Navigator.pop(context);
                    toast('Salida realizada con exito');
                  } else {
                    toast(respuestaUtilityModel.mensaje);
                  }
                },
                child: Container(
                  width: 155,
                  height: 55,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xfb234798)
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send,color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                      'Dar salida',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white
                      ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _encabezadoText(String encabezdo) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              encabezdo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 17, 134, 1),
                fontSize: 23
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _detalleText(String encabezdo) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              encabezdo,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<http.Response> insertarSalidaApi({required RecepcionModel recepcionModel}) async {
    return await http.put(Uri.parse('$urlAddRecepcion/${widget.recepcionModel.idrecepcion}'), body: recepcionModel.toJson());
  }

  Future<RespuestaUtilityModel> insertarSalida() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{
      RecepcionModel recepcionModel = RecepcionModel();

      await uploadImageCajuela(imagesCajuela);
      await uploadImagePlaca(imagesPlaca);

      if(urlCajuela == null) {
        urlCajuela = '';
      }

      if(urlPlaca == null) {
        urlPlaca = '';
      }

      recepcionModel.nombre = widget.recepcionModel.nombre;
      recepcionModel.empresa = widget.recepcionModel.empresa;
      recepcionModel.visita = widget.recepcionModel.visita;
      recepcionModel.area = widget.recepcionModel.area;
      recepcionModel.fechaE = widget.recepcionModel.fechaE;
      recepcionModel.horaE = widget.recepcionModel.horaE;
      recepcionModel.cajuelaE = widget.recepcionModel.cajuelaE;
      recepcionModel.placaE = widget.recepcionModel.placaE;
      recepcionModel.fotocredencial = widget.recepcionModel.fotocredencial;
      recepcionModel.fechaS = dateString;
      recepcionModel.horaS = hourString;
      recepcionModel.cajuelaS = urlCajuela!;
      recepcionModel.placaS = urlPlaca!;
      recepcionModel.createAtE = widget.recepcionModel.createAtE;
      recepcionModel.userE = widget.recepcionModel.userE;
      recepcionModel.createAtS = dateString + ' ' +  hourString;
      recepcionModel.userS = widget.user.name;
      recepcionModel.estado = 'I';

      await insertarSalidaApi(
        recepcionModel: recepcionModel
      ).then((http.Response response) {
        if(response.statusCode != 200) {
          throw 'Error';
        }
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }
  
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesCajuela,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesCajuela = [];
      imagesCajuela = resultList;
      if(imagesCajuela.isNotEmpty) {
        validateCajuelaEn = true;
      } else {
        validateCajuelaEn = false;
      }
    });
  }

  Future<void> loadAssetsPlaca() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesPlaca,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesPlaca = [];
      imagesPlaca = resultList;
      if(imagesPlaca.isNotEmpty) {
        validatePlacaEn = true;
      } else {
        validatePlacaEn = false;
      }
    });
  }

  Future<void> uploadImageCajuela(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images1.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images1.length; i++) {
        if (i == 0) {
          urlCajuela = images1[0].toString();
        }
      }
    });
  }

  Future<void> uploadImagePlaca(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images2.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images2.length; i++) {
        if (i == 0) {
          urlPlaca = images2[0].toString();
        }
      }
    });
  }

}
