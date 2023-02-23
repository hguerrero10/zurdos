import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:santiago4x4pro/models/recepcion_model.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:santiago4x4pro/src/recepciones/recepcionSalida.dart';
import 'package:santiago4x4pro/widget/toast.dart';

class RecepcionForm extends StatefulWidget {
  final UserModel user; 
  final UserRepository userRepository;

  const RecepcionForm({ Key? key, required this.userRepository,  required this.user }) : super(key: key);

  @override
  State<RecepcionForm> createState() => _RecepcionFormState();
}

class _RecepcionFormState extends State<RecepcionForm> {
  String urlAddRecepcion = 'https://zurdosapi.tlk.com.mx/addNewRecepcion';
  String urlGetRecepcionesAE = 'https://zurdosapi.tlk.com.mx/getRecepcionesEA';

  TextEditingController nombre = TextEditingController();
  TextEditingController empresa = TextEditingController();
  TextEditingController visita = TextEditingController();
  TextEditingController area = TextEditingController();

  var date = DateFormat.yMMMMd('es');
  var hour = DateFormat.Hm('es');
  var dateString = '';
  var hourString = '';

  List images1 = [];
  List images2 = [];
  List images3 = [];

  String? urlCajuela;
  String? urlPlaca;
  String? urlCredencial;

  File? cajuelaEn; 
  bool? validateCajuelaEn;
  String? base64CajuelaEn;

  File? placaEn; 
  bool? validatePlacaEn;
  String? base64PlacaEn;

  File? credencialEn; 
  bool? validateCredencialEn;
  String? base64CredencialEn;

  final pickerCajuelaEn = ImagePicker();
  final pickerPlacaEn = ImagePicker();
  final pickerCredencial = ImagePicker();

  List<Asset> imagesCajuela = <Asset>[];
  List<Asset> imagesPlaca = <Asset>[];
  List<Asset> imagesCredencial = <Asset>[];

  convertBase64CajuelaEn() async {
    if(cajuelaEn != null) {
      base64CajuelaEn = null;
      Uint8List imagebytes = await cajuelaEn!.readAsBytes(); //convert to bytes
      List<int>? imageData;
      imageData = imagebytes;
      base64CajuelaEn = base64Encode(imageData);
    }
  }

  // convertBase64PlacasEn() async {
  //   if(placaEn != null) {
  //     base64PlacaEn = null;
  //     Uint8List imagebytes = await placaEn!.readAsBytes(); //convert to bytes
  //     setState(() {
  //       List<int>? imageData;
  //       imageData = imagebytes;
  //       base64PlacaEn = base64Encode(imageData);
  //     });
  //   }
  // }

  // convertBase64Credencial() async {
  //   if(credencial != null) {
  //     base64Credencial = null;
  //     Uint8List imagebytes = await credencial!.readAsBytes(); //convert to bytes
  //     setState(() {
  //       List<int>? imageData;
  //       imageData = imagebytes;
  //       base64Credencial = base64Encode(imageData);
  //     });
  //   }
  // }

  @override
  void initState() {
    dateString = date.format(DateTime.now());
    hourString = hour.format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
        title: Text('Recepcion'),
        backgroundColor: Color(0xfb234798),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Entrada'),
              Tab(text: 'Salida'),
            ],
          ),
      ),
       body: TabBarView(
          children: [
            entrada(),
            SingleChildScrollView(child: salida())
          ],
        )
      )
    );
  }

  Widget entrada(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20.0, right: 40.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color(0xfb234798),
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: nombre,
                    // initialValue: report?.nombre,
                    // onSaved: (value) => report?.nombre = (value),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresar nombre completo';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Nombre completo'
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20.0, right: 40.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color(0xfb234798),
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: empresa,
                    // initialValue: report?.nombre,
                    // onSaved: (value) => report?.nombre = (value),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresar empresa';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Empresa'
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20.0, right: 40.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color(0xfb234798),
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: visita,
                    // initialValue: report?.nombre,
                    // onSaved: (value) => report?.nombre = (value),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresar visita';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Visita a'
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 20.0, right: 40.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color(0xfb234798),
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: area,
                    // initialValue: report?.nombre,
                    // onSaved: (value) => report?.nombre = (value),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingresar area';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.left,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Area '
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30),
        
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
                      await loadAssets();
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
                SizedBox(width: 20),
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
               SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    loadAssetsCredencial();
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
                          'Credencial',
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
          ),
          
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

          SizedBox(height: 30),

          GestureDetector(
            onTap: () async {
              RespuestaUtilityModel respuestaUtilityModel = await insertarEntrada();
              if(!respuestaUtilityModel.error) {
                Navigator.pop(context);
                toast('Recepcion creada');
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
                  'Registrar',
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
    );
  }

  Widget salida() {
    return FutureBuilder<List<RecepcionModel>>(
      future: obtenerOrdenes(),
      builder: (BuildContext context, AsyncSnapshot<List<RecepcionModel>> snapshot) {
        List<RecepcionModel> lista = [];

        if(snapshot.hasData) {
          lista = snapshot.data!;
        }
          if(lista.isNotEmpty) {
            return Column(
              children: List.generate(lista.length, (index) {
                return ordenes(lista[index]);
              })
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('No hay salidas')
              ],
            );
          }
      }
    );
  }

  Future<http.Response> insertarEntradaApi({required RecepcionModel recepcionModel}) async {
    return await http.post(Uri.parse(urlAddRecepcion), body: recepcionModel.toJson());
  }

  Future<RespuestaUtilityModel> insertarEntrada() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{
      RecepcionModel recepcionModel = RecepcionModel();

      if(nombre.text.isEmpty) {
        throw 'Nombre esta vacio';
      }
      
      if(visita.text.isEmpty) {
        throw 'Visita esta vacio';
      }

      if(empresa.text.isEmpty) {
        throw 'Empresa esta vacio';
      }

      if(area.text.isEmpty) {
        throw 'Area esta vacio';
      }

      await uploadImageCajuela(imagesCajuela);
      await uploadImagePlaca(imagesPlaca);
      await uploadImageCredencial(imagesCredencial);

      if(urlCajuela == null) {
        urlCajuela = '';
      }

      if(urlPlaca == null) {
        urlPlaca = '';
      }

      recepcionModel.nombre = nombre.text;
      recepcionModel.empresa = empresa.text;
      recepcionModel.visita = visita.text;
      recepcionModel.area = area.text;
      recepcionModel.fechaE = dateString;
      recepcionModel.horaE = hourString;
      recepcionModel.cajuelaE = urlCajuela!;
      recepcionModel.placaE = urlPlaca!;
      recepcionModel.fotocredencial = urlCredencial!;
      recepcionModel.fechaS = '';
      recepcionModel.horaS = '';
      recepcionModel.cajuelaS = '';
      recepcionModel.placaS = '';
      recepcionModel.createAtE = dateString + ' ' +  hourString;
      recepcionModel.userE = widget.user.name;
      recepcionModel.createAtS = '';
      recepcionModel.userS = '';
      recepcionModel.estado = 'A';

      await insertarEntradaApi(recepcionModel: recepcionModel).then((http.Response response) {
        print(response.statusCode);
        print(response.body);
        
        if(response.statusCode != 200) {
          throw 'Error';
        }
        
        print(response.statusCode);
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

  Future<void> loadAssetsCredencial() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesCredencial,
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
      imagesCredencial = [];
      imagesCredencial = resultList;
      if(imagesCredencial.isNotEmpty) {
        validateCredencialEn = true;
      } else {
        validateCredencialEn = false;
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

  Future<void> uploadImageCredencial(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images3.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images3.length; i++) {
        if (i == 0) {
          urlCredencial = images3[0].toString();
        }
      }
    });
  }







  Widget ordenes(RecepcionModel recepcionModel) {
    return  GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> RecepcionSalida(recepcionModel: recepcionModel,user: widget.user,userRepository: widget.userRepository)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ' + recepcionModel.nombre,
                      style: const TextStyle(   
                        fontSize: 17
                      ),
                    ),
                    Text(
                      'Empresa: ' + recepcionModel.empresa,
                      style: const TextStyle(   
                        fontSize: 15
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      "Detalles",
                      style: TextStyle(
                        color: Color.fromRGBO(59, 89, 152, 1),
                        fontSize: 15
                      ) 
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RecepcionSalida(recepcionModel: recepcionModel,user: widget.user,userRepository: widget.userRepository)));
                    },
                  ),  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> obtenerOrdenesApi() async {
    return await http.get(Uri.parse(urlGetRecepcionesAE));
  }

  Future<List<RecepcionModel>> obtenerOrdenes() async {
    List<RecepcionModel> listaOrdenesFinal = [];
    try{
      await obtenerOrdenesApi().then((http.Response response) {

        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        List<Map<String, dynamic>> listaParsedJson = [];

        if(parsedJson['RecepcionesEA'] != null) {
          for(int i = 0; i < parsedJson['RecepcionesEA'].length; i++) {
            listaParsedJson.add(parsedJson['RecepcionesEA'][i]);
          }
        }
        
        List<RecepcionModel> listaOrdenesModel = RecepcionModel().fromJsonList(listaParsedJson);
        
        listaOrdenesFinal = listaOrdenesModel;
      
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      listaOrdenesFinal = [];
    }
    return listaOrdenesFinal;
  }

}