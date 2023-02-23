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


class EntradaForm extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;
  const EntradaForm({Key? key, required this.userRepository,  required this.user }) : super(key: key);
  
  @override
  _EntradaFormState createState() => _EntradaFormState();
}

class _EntradaFormState extends State<EntradaForm> with TickerProviderStateMixin {

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
          'Formato Entrada',
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
                
                _encabezadoText("FOLIO"),
                _inputTextF(),

                SizedBox(height: 20),

                _encabezadoText("NOMBRE DEL CHOFER"),
                _inputTextN(),

                SizedBox(height: 10),

                _encabezadoText("NO. LICENCIA DEL CHOFER"),
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
                      child: Text('Firma del chofer')
                    )
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
                        child: Text('Firma de Seguridad')
                      ),
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
                        child: Text('Fotografía de Sello')
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                _encabezadoText("PLACAS DE TRACTOCAMION"),
                _inputTextPlacasTracto(),
                SizedBox(height: 10),

                _encabezadoText("ECO DEL TRACTOCAMION"),
                _inputTextEcoTracto(),
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

  _submit() async {
    if (formKey.currentState!.validate() ) {
        formKey.currentState!.save();

      setState(() {
        _isPressed = true;
        if (_state == 0) {
          animateButton();
        }
      });

      try {
        var format = DateFormat.yMMMMd('es');
        var dateString = format.format(DateTime.now());

        await subirImagenes();

        await FirebaseFirestore.instance.collection('formatos').add({
          'tipo': 'ENTRADA',
          'formato': 'FO-SC-01',
          'fecha': dateString.toUpperCase(),
          'hora': hourString,
          'folio': folio.text.trim().toUpperCase(),
          'nombreChofer': nChofer.text.toUpperCase().trim(),
          'licenciaChofer': lChofer.text.toUpperCase().trim(),
          'firmaChofer': url3,
          'fotoLicencia': url2,
          'nombreSeguridad': widget.user.name.toUpperCase(),
          'firmaSeguridad': url4,
          'ecoCaja': eCaja.text.trim().toUpperCase(),
          'sello': sello.text.trim().toUpperCase(),
          'fotoSello': url1,
          'placasTracto': pTracto.text.trim().toUpperCase(),
          'ecoTracto': eTracto.text.trim().toUpperCase(),
          'uidUser': widget.user.uid,
          'createAt': DateTime.now(),
          'comentario1': formatoBloc.comentario1,
          'comentario2': formatoBloc.comentario2,
          'comentario3': formatoBloc.comentario3,
          'comentario4': formatoBloc.comentario4,
          'comentario5': formatoBloc.comentario5,
          'opcion1': formatoBloc.opcion1,
          'opcion2': formatoBloc.opcion2,
          'opcion3': formatoBloc.opcion3,
          'opcion4': formatoBloc.opcion4,
          'opcion5': formatoBloc.opcion5,
        }).then((value) => {

          setState(() {
            idFormato = folio.text.trim().toUpperCase();
            _state = 2;
          }),
          reveal()
        // await reportsCollection.add(report!.toEntity().toDocument()).then((doc) async => {idFormato = doc.id,
        });
      } catch (e) {
        log(e.toString());
      }
    }
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
              _submit();
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

}