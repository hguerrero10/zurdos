import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santiago4x4pro/models/formatocfosc01.dart';
import 'package:santiago4x4pro/models/placas.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/src/formato/bloc/formato_bloc.dart';
import 'package:santiago4x4pro/src/formato/widget/camion_widget.dart';
import 'package:santiago4x4pro/src/formato/widget/firma_chofer_widget.dart';
import 'package:santiago4x4pro/src/formato/widget/firma_seguridad_widget.dart';
import 'package:santiago4x4pro/widget/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/home/home_form.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:santiago4x4pro/widget/toast.dart';

class SalidaForm extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;
  const SalidaForm({Key? key, required this.userRepository,  required this.user }) : super(key: key);
  
  @override
  _SalidaFormState createState() => _SalidaFormState();
}

class _SalidaFormState extends State<SalidaForm> with TickerProviderStateMixin {


  String urlAddNewFormat = 'https://zurdosapi.tlk.com.mx/addNewFormatFSC01';
  String urlGetOperators = 'https://zurdosapi.tlk.com.mx/getEmpleadosOP'; 
  String urlGetTractos= 'https://zurdosapi.tlk.com.mx/getTractos'; 
  String urlGetLFolio= 'https://zurdosapi.tlk.com.mx/getLastFolio'; 



  List<String> tractos = [];
  List<Placas> placas = [];
  List<String> _placas = [];

  Future getTractocamiones() async {
  var responseData;
    try{
      await http.get(Uri.parse(urlGetTractos),headers: {"Content-Type" : "application/json"}).then((value) async {
        if(value.statusCode == 200) {
          responseData = json.decode(value.body);
          for(var value in responseData['Tracto']) {
          
            setState(() {
              tractos.add(value['numeroEco']);
              placas.add(Placas(numeroEco: value['numeroEco'], placas: value['placas']));
            });
          }
          _tracto = tractos;
        } else {
          Navigator.pop(context);
        }
      }).timeout(const Duration(seconds: 35), onTimeout: () {
        print('Sin conexión al server1');
        Navigator.pop(context);
      });
    } catch (e) {
      print('Sin conexión al server2');
      Navigator.pop(context);
    }
  }







  final String _opcionSeleccionadaEmpleado = 'Seleccioanr';
  List<String> _empleados = [];

  List<DropdownMenuItem<String>> getDropDownMenuItemsEmpleados() {
    List<DropdownMenuItem<String>> items = [];

    for (var empleado in _empleados) {
      items.add(DropdownMenuItem(value: empleado, child: Text(empleado)));
    }
    return items;
  }
  
  String? selectEmpleado;


  var operatorSelectDrop;
  var operators;

  var lastFolio;

  final String _opcionSeleccionadaTracto = 'Seleccioanr';
  List<String> _tractos = [];

  List<DropdownMenuItem<String>> getDropDownMenuItemsTracto() {
    List<DropdownMenuItem<String>> items = [];

    for (var tracto in _tractos) {
      items.add(DropdownMenuItem(value: tracto, child: Text(tracto)));
    }
    return items;
  }


  String? selectTractocamion;






  String? selectUno;

  final String _opcionSeleccionadaUno = 'Si';
  final List<String> _uno = [
    "Si",
    "No",
  ];

  List<DropdownMenuItem<String>> getDropDownMenuItemsFormato() {
    List<DropdownMenuItem<String>> items = [];

    for (var value in _uno) {
      items.add(DropdownMenuItem(value: value, child: Text(value)));
    }
    return items;
  }




  TextEditingController uno = TextEditingController();




  final String _opcionSeleccionadaFormato = '';
  List<String>? _tracto;








  final formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey();
  bool _isPressed = false;
  int _state = 0;
  double _width = 330.0;
  Animation? _animation;
  AnimationController? _controllerAnimation;
  double _fraction = 0.0;

  String idFormato = '';

  TextEditingController folio = TextEditingController();
  TextEditingController nChofer = TextEditingController();
  TextEditingController lChofer = TextEditingController();
  TextEditingController eCaja = TextEditingController();
  TextEditingController sello = TextEditingController();
  TextEditingController pTracto = TextEditingController();
  TextEditingController eTracto = TextEditingController();

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); 
  final DateFormat hourFormat = DateFormat('Hm'); 
  var format;
  var hour;
  var dateString;
  var hourString;

  ImagePicker imagePickerChofer = ImagePicker();
  ImagePicker imagePickerSello = ImagePicker();

  File? fotoChofer; 
  File? fotoSello;

  bool? validateFotoChofer;
  bool? validateFotoSello;

  String? base64FotoChofer;
  String? base64FotoSello;

  fs.UploadTask? uploadTask1;
  fs.UploadTask? uploadTask2;
  fs.UploadTask? uploadTask3;
  fs.UploadTask? uploadTask4;

  final fs.FirebaseStorage storage = fs.FirebaseStorage.instanceFor(bucket: 'gs://zurdos-38449.appspot.com');

  String? url1;
  String? url2;
  String? url3;
  String? url4;

  @override
  void initState() { 
    initializeDateFormatting();
    format = DateFormat.yMMMMd('es');
    hour = DateFormat.Hm('es');
    dateString = format.format(DateTime.now());
    hourString = hour.format(DateTime.now());
    super.initState();
    obtenerEmpleados();
    getTractocamiones();
    obtenerFolio();
    bloc.addUserModel(widget.user);

  }

  Future<void> _openImagePickerChofer() async {
    final pickedImage = await imagePickerChofer.pickImage(source: ImageSource.camera);
    if(pickedImage != null) {
      setState(() {
        validateFotoChofer = true;
        fotoChofer = File(pickedImage.path);
        convertBase64FotoChofer();
      });
    }
  }

  Future<void> _openImagePickerSello() async {
    final pickedImage = await imagePickerSello.pickImage(source: ImageSource.camera);
    if(pickedImage != null) {
      setState(() {
        validateFotoSello = true;
        fotoSello = File(pickedImage.path);
        convertBase64FotoSello();
      });
    }
  }

  Future<void> convertBase64FotoChofer() async {
    if(fotoChofer != null) {
      base64FotoChofer = null;
      Uint8List imagebytes = await fotoChofer!.readAsBytes(); //convert to bytes
      List<int>? imageData;
      imageData = imagebytes;
      base64FotoChofer = base64Encode(imageData);
      log(base64FotoChofer.toString());
    }
  }

  Future<void> convertBase64FotoSello() async {
    if(fotoSello != null) {
      base64FotoSello = null;
      Uint8List imagebytes = await fotoSello!.readAsBytes(); //convert to bytes
      setState(() {
        List<int>? imageData;
        imageData = imagebytes;
        base64FotoSello = base64Encode(imageData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(user: widget.user),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Formato Salida',
        ),
        actions: [
          IconButton(
            onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => const CamionWidget())));
          }, 
          icon: Icon(Icons.directions_bus_filled_rounded))
        ],
        backgroundColor: const Color.fromRGBO(0, 17, 134, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [

                Text(
                  'FO-SC-01',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'CHECK LIST C-TPAT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 20),

                
                lastFolio != null ? _encabezadoText('FOLIO: ' + lastFolio.toString()) : SizedBox(),
                // _inputTextF(),

                SizedBox(height: 20),

                _encabezadoText("NOMBRE DEL CHOFER"),
                _crearDropDownEmpleado(),

                SizedBox(height: 10),

                _encabezadoText("NO. LICENCIA DEL CHOFER"),
                // _encabezadoText(_empleados.),
                _inputTextL(),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0, 17, 134, 1),
                      ),
                      onPressed: () {
                        _openImagePickerChofer();
                      }, 
                      child: Text('Fotografía de Licencia')
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0, 17, 134, 1),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => const FirmaChoferWidget())));
                      }, 
                      child: Text('Firma de Chofer'))
                  ],
                ),

                SizedBox(height: 10),

                _encabezadoText("NOMBRE DE SEGURIDAD"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                    SizedBox(height: 10),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(0, 17, 134, 1),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => const FirmaSeguridadWidget())));
                        }, 
                      child: Text('Firma de Seguridad')),
                    )
                  ],
                ),

                SizedBox(height: 25),

                Text(
                  'DATOS DE LA CAJA - CONTENEDOR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 25),

                _encabezadoText("NO. ECO CAJA"),
                _inputTextEcoCaja(),
                SizedBox(height: 10),

                _encabezadoText("NO. SELLO"),
                _inputTextSello(),

                SizedBox(height: 10),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(0, 17, 134, 1),
                        ),
                        onPressed: () {
                        _openImagePickerSello();
                        }, 
                        child: Text('Fotografía de Sello')),
                    ),
                  ],
                ),
                SizedBox(height: 10),


                _encabezadoText("ECO DEL TRACTOCAMION"),
                _crearDropDownTracto(),
                // _inputTextEcoTracto(),
                SizedBox(height: 10),


                _encabezadoText("PLACAS DE TRACTOCAMION"),
                _inputTextPlacasTracto(),

                SizedBox(height: 25),

                _botonEnviar()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _encabezadoText(String encabezdo) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              encabezdo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 17, 134, 1),
                fontSize: 15.0
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _inputTextF() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 1),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: folio,
              // initialValue: report?.folio,
              // onSaved: (value) => report?.description = (value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar el folio';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTextN() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 2),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: nChofer,
              // initialValue: report?.folio,
              // onSaved: (value) => report?.description = (value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar el nombre del chofer';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTextL() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: lChofer,
              // initialValue: report?.folio,
              // onSaved: (value) => report?.description = (value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar la licencia del chofer';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _inputTextEcoCaja() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: eCaja,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar el eco de caja';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _inputTextSello() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: sello,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar el numero de sello';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTextPlacasTracto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: pTracto,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar las placas del tractocamion';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTextEcoTracto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: eTracto,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar el eco del tractocamion';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reveal() {
    _controllerAnimation = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controllerAnimation!)
      ..addListener(() {
        setState(() {
          _fraction = _animation!.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ListView(children: <Widget>[
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.check),
                          title: Text(
                            "Formato enviado",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Folio: ${idFormato.toString()}',
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ),
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeForm(userRepository: widget.userRepository, user: widget.user)), (route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            },
          );
        }
      });

    _controllerAnimation!.forward();
  } 

  void animateButton() {
    double initialWidth = _globalKey.currentContext!.size!.width;

    _controllerAnimation = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controllerAnimation!)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation!.value);
        });
      });
    _controllerAnimation!.forward();

    setState(() {
      _state = 1;
    });
  }

  double calculateElevation() {
    return _isPressed ? 6.0 : 4.0;
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return const Text(
        'Enviar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return const SizedBox(
        height: 36.0,
        width: 36.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  Future<int> subirImagenes() async {

    fs.Reference  reference1 = storage.ref().child('${DateTime.now()}/${widget.user.uid}');
    fs.Reference  reference2 = storage.ref().child('${DateTime.now()}/${widget.user.uid}');
    fs.Reference  reference3 = storage.ref().child('${DateTime.now()}/${widget.user.uid}');
    fs.Reference  reference4 = storage.ref().child('${DateTime.now()}/${widget.user.uid}');

    var imageData1;
    var imageData2;
    var imageData3;
    var imageData4;
      
    var uploadTask1;
    var uploadTask2;
    var uploadTask3;
    var uploadTask4;

    imageData1 = base64Decode(base64FotoSello!); 
    uploadTask1 = reference1.putData(imageData1, fs.SettableMetadata(contentType: 'image/jpeg'));
    url1 = await (await uploadTask1).ref.getDownloadURL();

    imageData2 = base64Decode(base64FotoChofer!); 
    uploadTask2 = reference2.putData(imageData2, fs.SettableMetadata(contentType: 'image/jpeg'));
    url2 = await (await uploadTask2).ref.getDownloadURL();

    imageData3 = base64Decode(formatoBloc.firmaChofer!); 
    uploadTask3 = reference3.putData(imageData3, fs.SettableMetadata(contentType: 'image/jpeg'));
    url3 = await (await uploadTask3).ref.getDownloadURL();

    imageData4 = base64Decode(formatoBloc.firmaSeguridad!); 
    uploadTask4 = reference4.putData(imageData4, fs.SettableMetadata(contentType: 'image/jpeg'));
    url4 = await (await uploadTask4).ref.getDownloadURL();
    return 1;
  }
















 

  Future<http.Response> apiInsertFormat({required FormatoModel formatoModel}) async {
    return await http.post(Uri.parse(urlAddNewFormat), body: formatoModel.toJson());
  }

  Future<RespuestaUtilityModel> _submit() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    if (formKey.currentState!.validate() ) {
        formKey.currentState!.save();

      setState(() {
        _isPressed = true;
        if (_state == 0) {
          animateButton();
        }
      });

      try {
        FormatoModel formatoModel = FormatoModel();
        var format = DateFormat.yMMMMd('es');
        var dateString = format.format(DateTime.now());

    
        formatoModel.tipo = 'SALIDA';
        formatoModel.fecha = dateString.toUpperCase();
        formatoModel.hora = hourString;
        formatoModel.folio = lastFolio.toString();
        formatoModel.nombreChofer = selectEmpleado!;
        formatoModel.licenciaChofer = lChofer.text.toUpperCase().trim();
        formatoModel.firmaChofer = formatoBloc.firmaChofer!;
        formatoModel.fotoLicencia = base64FotoChofer!;
        formatoModel.nombreSeguridad = widget.user.name;
        formatoModel.firmaSeguridad = formatoBloc.firmaSeguridad!;
        formatoModel.sello = sello.text.trim().toUpperCase();
        formatoModel.fotoSello = base64FotoSello!;
        formatoModel.ecoTracto = selectTractocamion!;
        formatoModel.placasTracto = pTracto.text.trim().toUpperCase();
        formatoModel.ecoCaja = eCaja.text.trim().toUpperCase();
        formatoModel.opcion1 = formatoBloc.opcion1.toString();
        formatoModel.comentario1 = formatoBloc.comentario1.toString();
        formatoModel.opcion2 = formatoBloc.opcion2.toString();
        formatoModel.comentario2 = formatoBloc.comentario2.toString();
        formatoModel.comentario3 = formatoBloc.comentario3.toString();
        formatoModel.opcion3 = formatoBloc.opcion3.toString();
        formatoModel.comentario4 = formatoBloc.comentario4.toString();
        formatoModel.opcion4 = formatoBloc.opcion4.toString();
        formatoModel.comentario5 = formatoBloc.comentario5.toString();
        formatoModel.opcion5 = formatoBloc.opcion5.toString();

        formatoModel.createAt = DateTime.now().toString();
        formatoModel.creatorUser = widget.user.name;
        formatoModel.status = 'A';

      await apiInsertFormat(formatoModel: formatoModel).then((http.Response response) {
        print(response.statusCode);
        print(response.body);
        
        if(response.statusCode != 200) {
          throw 'Error';
        }
        
        print(response.statusCode);
          setState(() {
            _state = 2;
          });
          reveal();
        });
      } catch (error) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    }
    return respuestaUtilityModel;
  }

  Widget _botonEnviar() {
    if(formatoBloc.opcion1 != null) {
      return PhysicalModel(
        color: Colors.white,
        elevation: calculateElevation(),
        borderRadius: BorderRadius.circular(25.0),
        child: SizedBox(
          key: _globalKey,
          height: 50.0,
          width: _width,
          child: RaisedButton(
            padding: const EdgeInsets.all(10.0),
            color: _state == 2
                ? Color.fromARGB(255, 40, 214, 30)
                : const Color.fromRGBO(0, 17, 134, 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: buildButtonChild(),
            onPressed: () async {
                 RespuestaUtilityModel respuestaUtilityModel = await _submit();
              if(!respuestaUtilityModel.error) {
                Navigator.pop(context);
                toast('Formato creado');
              } else {
                toast(respuestaUtilityModel.mensaje);
              }
            },
          ),
        )
      );
    }
    else {
      return Container();
    }
  }

  Widget _crearDropDownUno() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar formato...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectUno,
        onChanged: (value) {
          setState(() {
            selectUno = (value);
          });
        },
      ),
    );
  }









  Future<http.Response> obtenerEmpleadosApi() async {
    return await http.get(Uri.parse(urlGetOperators));
  }

  Future<RespuestaUtilityModel> obtenerEmpleados() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await obtenerEmpleadosApi().then((http.Response response) {
        print(response.body);
        print(response.statusCode);
        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        operators = parsedJson;
        List<String> listaParsedJson = [];

        if(parsedJson['Empleados'] != null) {
          for(int i = 0; i < parsedJson['Empleados'].length; i++) {
            listaParsedJson.add(parsedJson['Empleados'][i]['nombre'] + ' ' +  parsedJson ['Empleados'][i]['apellidoP'] + ' ' + parsedJson['Empleados'][i]['apellidoM']);
          }
        }

        _empleados.addAll(listaParsedJson);

        print(operators);

      
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      print(error);
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }

  Widget _crearDropDownEmpleado() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar operador...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _empleados,
        showClearButton: true,
        selectedItem: selectEmpleado,
        onChanged: (value) {
          setState(() {
            selectEmpleado = (value);

          });
        },
      ),
    );
  }





















  Future<http.Response> obtenerTractosApi() async {
    return await http.get(Uri.parse(urlGetOperators));
  }

  Future<RespuestaUtilityModel> obtenerTractos() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await obtenerTractosApi().then((http.Response response) {
        print(response.body);
        print(response.statusCode);
        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        operators = parsedJson;
        List<String> listaParsedJson = [];

        if(parsedJson['Traco'] != null) {
          for(int i = 0; i < parsedJson['Traco'].length; i++) {
            listaParsedJson.add(parsedJson['Traco'][i]['numeroEco']);
          }
        }

        _empleados.addAll(listaParsedJson);

        print(operators);

      
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      print(error);
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }

  Widget _crearDropDownTracto() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar tractocamion...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _tracto,
        showClearButton: true,
        selectedItem: selectTractocamion,
        onChanged: (value) {
          setState(() {
            placas.forEach((pl) {
              if(value == pl.numeroEco) {
                pTracto.text = pl.placas!;
              }
            });

            selectTractocamion = (value);
          });
        },
      ),
    );
  }
























  Future<http.Response> obtenerLastFolio() async {
    return await http.get(Uri.parse(urlGetLFolio));
  }

  Future<RespuestaUtilityModel> obtenerFolio() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await obtenerLastFolio().then((http.Response response) {
        print(response.body);
        print(response.statusCode);
        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        // List<String> listaParsedJson = [];

        if(parsedJson['Folio'] != null) {
          for(int i = 0; i < parsedJson['Folio'].length; i++) {
            print(parsedJson['Folio'][i]['folio']);
            var civ = int.parse(parsedJson['Folio'][i]['folio']);
            print(civ);
            var suma = civ + 1;
            print(suma);
           lastFolio = suma;
            print(lastFolio);

          }
        }

        // _empleados.addAll(listaParsedJson);

        print(lastFolio);

      
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      print(error);
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }
}