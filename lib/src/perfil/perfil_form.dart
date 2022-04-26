import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/auto.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:santiago4x4pro/src/perfil/auto_info.dart';
import 'package:santiago4x4pro/widget/dialog/dialog.dart';
import 'package:santiago4x4pro/widget/toast.dart';
import 'package:intl/intl.dart';

class PerfilForm extends StatefulWidget {

  final UserModel user;
  const PerfilForm({Key? key, required this.user}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<PerfilForm> {
  
  final DateFormat fechaFormato = DateFormat('yyyy-MM-dd HH:mm'); 
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _status = true;

  final storage = firebase_storage.FirebaseStorage.instanceFor(bucket: 'gs://santiago-app-8bfa0.appspot.com/');
  final pickerPerfil = ImagePicker();
  final pickerAuto = ImagePicker();
  File? imagePerfil;
  String? updateImage;
  String? seguroSelect;
  String? urlPerfil;
  String? urlAuto;
  firebase_storage.UploadTask? uploadTaskPerfil;
  firebase_storage.UploadTask? uploadTaskAuto;

  bool updatePerfil = true;

  TextEditingController? nameInputController;
  TextEditingController? phoneInputController;
  TextEditingController? emailInputController;
  TextEditingController? typeBloodUserInputController;
  TextEditingController? dayBornInputController;
  TextEditingController? insuranceUserInputController;
  TextEditingController? nameGuestInputController;
  TextEditingController? ageInputController;
  TextEditingController? typeBloodInputController;
  TextEditingController? insuranceInputController;
  TextEditingController colorInputController = TextEditingController();
  TextEditingController marcaInputController = TextEditingController();
  TextEditingController modeloInputController = TextEditingController();
  TextEditingController placaInputController = TextEditingController();
  TextEditingController seguroInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameInputController  = TextEditingController(text: widget.user.name);
    phoneInputController  = TextEditingController(text: widget.user.phone);
    emailInputController  = TextEditingController(text: widget.user.email);
    typeBloodUserInputController  = TextEditingController(text: widget.user.typeBlood);
    dayBornInputController  = TextEditingController(text: widget.user.dateBorn);
    insuranceUserInputController  = TextEditingController(text: widget.user.insurance);
  }

  final List<String> _seguro = [
    "Si", 
    "No"
  ];

  Future<void> _openImagePickerPerfil() async {
    final pickedImage = await pickerPerfil.pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      setState(() {
        imagePerfil = File(pickedImage.path);
      });
    }
  }


  Future<void> _openImagePickerAuto() async {
    final pickedImage = await pickerAuto.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      setState(() {
        bloc.addFileAuto(File(pickedImage.path));
      });
    }
  }

  Widget _label(String label, Color rgbColor) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            label,
            style: TextStyle(
              color: rgbColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: _scaffoldKey,
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: const TabBar(
              labelPadding: EdgeInsets.all(1),
              unselectedLabelColor: Colors.black,
              labelColor: Color.fromRGBO(44, 197, 94, 1),
              indicatorColor: Color.fromRGBO(44, 197, 94, 1),
              labelStyle: TextStyle(
                fontSize: 14,
              ),
              tabs: [
                Tab(child: Center(child: Text("Perfil"))),
                Tab(child: Center(child: Text("Mis autos"))),
              ],
            ),
            body: TabBarView(
              children: [
                _perfil(),
                _auto(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _perfil() {
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Stack(fit: StackFit.loose, children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 100,
                            minRadius: 100,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imagePerfil != null ? Image.file(imagePerfil!, fit: BoxFit.cover, width: 160, height: 160,) : widget.user.image.isEmpty ? Image.asset('assets/user-defauld.png', fit: BoxFit.cover, width: 160, height: 160) : Image.network(widget.user.image, fit: BoxFit.cover, width: 160, height: 160)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 120, right: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                            child: _status == true ? null : CircleAvatar(
                              backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
                              radius: 25,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                color: Colors.white,
                                onPressed: () {
                                  _openImagePickerPerfil();
                                },
                              ),
                            ),
                            ),
                          ],
                        )
                      ),
                    ]),
                  )
                ],
              ),
            ),
            Container(
              color: const Color(0xffFFFFFF),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Informacion Personal',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _status ? _getEditIcon() : Container(),
                            ],
                          )
                        ],
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Nombre',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only( left: 25, right: 25, top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: TextFormField(
                                style: const TextStyle( fontSize: 15),
                                decoration: const InputDecoration(
                                  hintText: "Escriba su nombre",
                                  hintStyle: TextStyle( fontSize: 15),
                                ),
                                controller: nameInputController, 
                                enabled: !_status,
                                autofocus: !_status,
                                  validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                },
                                // onSaved: (value) => name = value,
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Correo',
                                  style: TextStyle(
                                    
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: emailInputController,
                                style: const TextStyle( fontSize: 15),
                                decoration: const InputDecoration(
                                  hintText: "Escriba su correo",
                                  hintStyle: TextStyle( fontSize: 15),
                                ),
                                enabled: false,
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Tipo de sangre',
                                  style: TextStyle(
                                    
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: typeBloodUserInputController,
                                style: const TextStyle( fontSize: 15),
                                decoration: const InputDecoration(
                                  hintText: "Escriba su tipo de sangre",
                                  hintStyle: TextStyle( fontSize: 15),
                                ),
                                enabled: !_status,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Escriba su tipo de sangre por favor';
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only( left: 25, right: 25, top: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const[
                                Text(
                                  'Celular',
                                  style: TextStyle(
                                    
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: phoneInputController,
                                style: const TextStyle( fontSize: 15),
                                decoration: const InputDecoration(
                                hintText: "Escriba su celular",
                                hintStyle: TextStyle( fontSize: 15),
                                ),
                                enabled: !_status,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Escriba su celular por favor';
                                  }
                                },
                                // onSaved: (value) => phone = value,
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only( left: 25, right: 25, top: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Fecha de nacimiento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: TextFormField(
                                onTap: () {

                                },
                                controller: dayBornInputController,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                hintText: "Escriba su fecha de nacimiento",
                                hintStyle: TextStyle(fontSize: 15),
                                ),
                                enabled: !_status,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Escriba su fecha de nacimiento';
                                  }
                                },
                                // onSaved: (value) => phone = value,
                              ),
                            ),
                          ],
                        )
                      ),
                    !_status ? _getActionButtons() : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _auto() {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('car').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData){
            return snapshot.data!.docs.isNotEmpty ? Column(
              children: [
                Flexible(
                  child: ListView(  
                    children:  builCard(snapshot.data!.docs),  
                  ),
                ),
              ],
            ): _autoSinDatos();
          }
          else {
            const SizedBox();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: add()
    );
  }


  List<Widget> builCard(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
    for (var document in doc) {
      items.add(
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AutoInfo(user: widget.user, documentSnapshot: document)));
          },
          child: SizedBox(
            height: 130,
            child: Padding(
              padding: const EdgeInsets.all(5),
                child: Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Image.network(
                              document.get('urlImage'), 
                              fit: BoxFit.cover,
                              height: 90,
                              width: 130,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document.get('modelo').toString(), style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 10),
                                  Text(document.get('marca').toString(), style: const TextStyle(fontSize: 15)),
                                  const SizedBox(height: 5),
                                  Text(document.get('placa').toString(), style: const TextStyle(fontSize: 15)),
                                  const SizedBox(height: 5),
                                  Text(document.get('createAt').toString(), style: const TextStyle(fontSize: 15))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                  )
                )
              ),
          ),
        )
      );
    }
    return items;
  }

  Widget add() => FloatingActionButton(
    onPressed: () {
      dialog(
        'Agregar vehículo', 
        '',
        CupertinoIcons.car_detailed, 
        const Color.fromRGBO(44, 197, 94, 1),
        Colors.white, 
        context, 
        () async {
          firebase_storage.Reference reference = storage.ref().child('${placaInputController.text.trim()}-${DateTime.now()}');
          uploadTaskAuto = reference.putFile(bloc.imageAuto!, firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
          urlAuto = await (await uploadTaskAuto!).ref.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('car').add({
            "color": bloc.pickerColor.toString(),
            "marca": marcaInputController.text.trim(),
            "modelo": modeloInputController.text.trim(),
            "placa": placaInputController.text.trim(),
            "seguro": seguroSelect,
            "urlImage": urlAuto,
            "createAt": fechaFormato.format(DateTime.now()).toString()
          }).then((value) => {
            toast('Automovil agregado'),
            Navigator.pop(context),
            bloc.deleteColor(),
            bloc.deleteFileAuto(),
            setState(() {
              marcaInputController = TextEditingController();
              modeloInputController = TextEditingController();
              placaInputController = TextEditingController();
              seguroSelect = null;
              urlAuto = null;
            }),
          }).timeout(const Duration(seconds: 15), onTimeout: ()  => {
            toast('Error'),
            Navigator.pop(context)
          });
        },
        StreamBuilder(
          stream: bloc.getStream,
          initialData: bloc.cartStreamController,
          builder: (context, snapshot) {
            return Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: marcaInputController,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                ),
                TextFormField(
                  controller: modeloInputController,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Modelo',
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                ),
                TextFormField(
                  controller: placaInputController,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 7,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Placa',
                    counterText: "",
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        colorDialog();
                      },
                      child: const Text(
                        'Seleccionar color',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        colorDialog();
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                          color: bloc.pickerColor
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _openImagePickerAuto();
                      },
                      child: const Text(
                        'Seleccionar imagen',
                      ),
                    ),
                    bloc.imageAuto == null ?
                    const SizedBox() :
                    const Icon(Icons.check, color: Colors.green)
                  ],
                ),
                const SizedBox(height: 15), 
                _label('Seguro', Colors.black),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 2,
                  margin: const EdgeInsets.only(left: 20, right: 20,),
                  child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItems: true,
                    items: _seguro,
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: 'Seleccionar',
                      labelStyle: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    selectedItem: seguroSelect,
                    onChanged: (value) {
                      setState(() {
                        seguroSelect = (value);
                      });
                    },
                  ),
                )
              ]
            );
          }
        ),
        () {
          setState(() {
            Navigator.of(context).pop();
            bloc.deleteColor();
            seguroSelect = null;
          });
        },
      );
    },
    backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
    child: const Icon(
      Icons.add,
      color: Colors.white,
    ),
  );

  colorDialog() {
    showDialog(
      context: context,
      builder: (context) { 
        return AlertDialog(
        title: const Text('Seleccionar color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: bloc.pickerColor,
            onColorChanged: (Color color) {
              bloc.changeColor(color);
            } 
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      }
    );
  }

  Widget _autoSinDatos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.car_detailed,
            color: Colors.grey[400],
            size: 120,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'No haz ingresado un vehiculo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 25
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              child: const Text(
                "Guardar", 
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1),)
              ),
              onPressed: () async{
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                });
                dialog(
                  '',
                  'contenido',
                  CupertinoIcons.info, 
                  const Color.fromRGBO(44, 197, 94, 1), 
                  Colors.white, context, 
                  () async {
                    setState(() {
                      _status = false;
                      bloc.addUpdatePerfil();
                    });
                    if(imagePerfil == null) {
                      FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
                        'name': nameInputController!.text.trim(),
                        'phone': phoneInputController!.text.trim(),
                        'email': emailInputController!.text.trim(),
                        'typeBlood': typeBloodUserInputController!.text.trim(),
                        'dayBorn': dayBornInputController!.text.trim(),
                        'insurance': insuranceUserInputController!.text.trim(),
                      }).then((value) => {
                        Navigator.pop(context),
                        toast('Perfil actualizado'),
                        toast('Los cambios se veran reflejados en tu proximo inicio de sesion'),
                        bloc.deleteUpdatePerfil()
                      });
                    } else {
                      firebase_storage.Reference reference = storage.ref().child('${widget.user.name}-${DateTime.now()}');
                      uploadTaskPerfil = reference.putFile(imagePerfil!, firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
                      urlPerfil = await (await uploadTaskPerfil!).ref.getDownloadURL();
                      FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
                        'name': nameInputController!.text.trim(),
                        'phone': phoneInputController!.text.trim(),
                        'email': emailInputController!.text.trim(),
                        'typeBlood': typeBloodUserInputController!.text.trim(),
                        'dayBorn': dayBornInputController!.text.trim(),
                        'insurance': insuranceUserInputController!.text.trim(),
                        'image': urlPerfil
                      }).then((value) => {
                        Navigator.pop(context),
                        toast('Perfil actualizado'),
                        toast('Los cambios se veran reflejados en tu proximo inicio de sesion'),
                        bloc.deleteUpdatePerfil()
                      });
                    }
                  },
                  StreamBuilder(
                    stream: bloc.getStream,
                    initialData: bloc.cartStreamController,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Text(
                            bloc.updatePerfil == false ? '¿Estas seguro de realizar cambios a tu perfil?' : 'Actualizando...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Nuber Next',
                            ),
                          ),
                          const SizedBox(height: 5),
                          bloc.updatePerfil == false ? const SizedBox() : const CircularProgressIndicator(),
                        ],
                      );
                    }
                  ),
                  () => Navigator.of(context).pop()
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[600])
              ),
              child: const Text(
                "Cancelar", 
              ),
              onPressed: () {
                setState(() {
                  _status = true;
                  imagePerfil = null;
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Color.fromRGBO(44, 197, 94, 1),
        radius: 14,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}