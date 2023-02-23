import 'dart:core';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/formato/formato_entrada_form.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santiago4x4pro/widget/drawer.dart';

class HomeForm extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;
  const HomeForm({Key? key, required this.userRepository,  required this.user }) : super(key: key);
  
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  
  List<DocumentSnapshot> documents = [];

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); 
  var format;
  var dateString;

  String? selectFormato;

  final String _opcionSeleccionadaFormato = 'Salida';
  final List<String> _formato = [
    "Salida",
    "Entrada",
  ];

  List<DropdownMenuItem<String>> getDropDownMenuItemsFormato() {
    List<DropdownMenuItem<String>> items = [];

    for (var formato in _formato) {
      items.add(DropdownMenuItem(value: formato, child: Text(formato)));
    }
    return items;
  }

  @override
  void initState() { 
    initializeDateFormatting();
    format = DateFormat.yMMMMd('es');
    dateString = format.format(DateTime.now());
    super.initState();
    bloc.addUserModel(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Image.asset(
        'assets/LOGO ZURDOS.png',
        height: 100,
        width: 120,
      ),
      drawer: MenuDrawer(user: widget.user),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inicio',
        ),
        backgroundColor: const Color.fromRGBO(0, 17, 134, 1),
      ),
      body: Container(          
        child: SafeArea(
          bottom: false,
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [

                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      dateString,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Buen dia: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      widget.user.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(height: 100),

                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  _cuadricula1(),
                                  SizedBox(height: 10),
                                  _cuadricula2(),
                                ]
                              ),

                            ],
                          )   
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ), 
      )        
    );
  }


  Widget _cuadricula1() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _boton(const Color(0xfb234798), Icons.checklist_rtl_outlined, () => Navigator.pushNamed(context, 'select'), 'Check list \nC-TPAT'),
          _boton(const Color(0xfb234798), Icons.newspaper, () => Navigator.pushNamed(context, 'ordenes'), 'Ordenes'),
        ],
      ),
    );
  }

  Widget _cuadricula2() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _boton(const Color(0xfb234798), Icons.people, () => Navigator.pushNamed(context, 'recepcion'), 'Recepcion'),
          _boton(const Color(0xfb234798), Icons.person, () => Navigator.pushNamed(context, 'entradas'), 'Entradas y salidas'),
        ],
      ),
    );
  }

  Widget _boton(color, icono, onPress, text) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width * 0.3,
        child: ElevatedButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
            overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              )
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                color: Colors.black,
              )
            )
          ),
          onPressed: onPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                color: color,
                size: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontFamily: 'Confortaa'
                  ),
                ),
              ),
            ],
          )
        )
      ),
    );
  }

  Widget _crearDropDownFormato() {
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
        items: _formato,
        showClearButton: true,
        selectedItem: selectFormato,
        onChanged: (value) {
          setState(() {
            selectFormato = (value);
          });
        },
      ),
    );
  }
  }
