import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/lista_ordenes_model.dart';
import 'package:santiago4x4pro/models/ordenes.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/ordenes/detalles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Ordenes extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;

  const Ordenes({Key? key, required this.userRepository,  required this.user}) : super(key: key);

  @override
  _OrdenesState createState() => _OrdenesState();
}

class _OrdenesState extends State<Ordenes> {

  String urlGetUsersServer = 'https://zurdosapi.tlk.com.mx/getNewsOrderns';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevas ordenes'),
        backgroundColor: Color(0xfb234798),
      ),
      body: body()
    );
  }

  Widget body() {
    return FutureBuilder<List<OrdenesModel>>(
      future: obtenerOrdenes(),
      builder: (BuildContext context, AsyncSnapshot<List<OrdenesModel>> snapshot) {
        List<OrdenesModel> lista = [];
        
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
            return Text('Vacio perro');
          }


      }
    );
  }

  Widget ordenes(OrdenesModel ordenesModel) {
    return  GestureDetector(
      onTap: () {
        // ruta o enlace

        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetalleOrdenes(ordenesModel: ordenesModel,user: widget.user,userRepository: widget.userRepository)));
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
                title: Text(
                  'Folio: ' + ordenesModel.folio,
                  style: const TextStyle(   
                    fontSize: 15
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      "Ver orden",
                      style: TextStyle(
                        color: Color.fromRGBO(59, 89, 152, 1),
                        fontSize: 15
                      ) 
                    ),
                    onPressed: () {
                      
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetalleOrdenes(ordenesModel: ordenesModel,user: widget.user,userRepository: widget.userRepository)));
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
    return await http.get(Uri.parse(urlGetUsersServer));
  }

  Future<List<OrdenesModel>> obtenerOrdenes() async {
    List<OrdenesModel> listaOrdenesFinal = [];
    try{
      await obtenerOrdenesApi()
      .then((http.Response response) {

        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        List<Map<String, dynamic>> listaParsedJson = [];

        if(parsedJson['NewsOrders'] != null) {
          for(int i = 0; i < parsedJson['NewsOrders'].length; i++) {
            listaParsedJson.add(parsedJson['NewsOrders'][i]);
          }
        }
        
        List<OrdenesModel> listaOrdenesModel = OrdenesModel().fromJsonList(listaParsedJson);
        
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