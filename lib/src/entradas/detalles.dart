import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:santiago4x4pro/models/entradassalidas.dart';
import 'package:santiago4x4pro/models/lista_ordenes_model.dart';
import 'package:santiago4x4pro/models/ordenes.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/entradas/salida.dart';
import 'package:santiago4x4pro/src/ordenes/detalles.dart';
import 'package:santiago4x4pro/widget/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DetallesS extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;


  const DetallesS({Key? key, required this.userRepository,  required this.user}) : super(key: key);

  @override
  _DetallesSState createState() => _DetallesSState();
}

class _DetallesSState extends State<DetallesS> {

  var date = DateFormat.yMMMMd('es');
  var hour = DateFormat.Hm('es');
  var dateString = '';
  var hourString = '';

  String urlGetSalidasActivas = 'https://zurdosapi.tlk.com.mx/getSalidasActivas';
  String urlHacerSalida = 'https://zurdosapi.tlk.com.mx/upEntradas';

  @override
  void initState() {
    super.initState();

    dateString = date.format(DateTime.now());
    hourString = hour.format(DateTime.now());

    obtenerSalidasA();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salidas'),
        backgroundColor: Color(0xfb234798),
      ),
      body: body()
    );
  }

  Widget body() {
    return FutureBuilder<List<EnSaModel>>(
      future: obtenerSalidasA(),
      builder: (BuildContext context, AsyncSnapshot<List<EnSaModel>> snapshot) {
        List<EnSaModel> lista = [];
        
        if(snapshot.hasData) {
          lista = snapshot.data!;
        }

          if(lista.isNotEmpty) {
            return Column(
              children: List.generate(lista.length, (index) {
                return salidas(lista[index]);
              })
            );
          } else {
            return Text('Vacio');
          }


      }
    );
  }

  Widget salidas(EnSaModel enSaModel) {
    return  GestureDetector(
      onTap: () async{
        // ruta o enlace

             RespuestaUtilityModel respuestaUtilityModel = await insertarSalida(enSaModel);
                      if(!respuestaUtilityModel.error) {
                        Navigator.pop(context);
                        toast('Salida creada');
                      } else {
                        toast(respuestaUtilityModel.mensaje);
                      }

        // Navigator.push(context, MaterialPageRoute(builder: (context)=> SalidaFormE(enSaModel: enSaModel,user: widget.user,userRepository: widget.userRepository)));
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
                  'Nombre: ' + enSaModel.nombre,
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
                      "Dar salida",
                      style: TextStyle(
                        color: Color.fromRGBO(59, 89, 152, 1),
                        fontSize: 15
                      ) 
                    ),
                    onPressed: () async {
                      
             RespuestaUtilityModel respuestaUtilityModel = await insertarSalida(enSaModel);
                      if(!respuestaUtilityModel.error) {
                        Navigator.pop(context);
                        toast('Salida creada');
                      } else {
                        toast(respuestaUtilityModel.mensaje);
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> SalidaFormE(enSaModel: enSaModel,user: widget.user,userRepository: widget.userRepository)));
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

  Future<http.Response> obtenerSActivasApi() async {
    return await http.get(Uri.parse(urlGetSalidasActivas));
  }

  Future<List<EnSaModel>> obtenerSalidasA() async {
    List<EnSaModel> listaOrdenesFinal = [];
    try{
      await obtenerSActivasApi().then((http.Response response) {

        if(response.statusCode != 200) {
          throw 'Error';
        }

        Map<String, dynamic> parsedJson = jsonDecode(response.body);
        List<Map<String, dynamic>> listaParsedJson = [];

        if(parsedJson['SActivas'] != null) {
          for(int i = 0; i < parsedJson['SActivas'].length; i++) {
            listaParsedJson.add(parsedJson['SActivas'][i]);
          }
        }
        
        List<EnSaModel> listaEnSaModel = EnSaModel().fromJsonList(listaParsedJson);
        
        listaOrdenesFinal = listaEnSaModel;
      
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      listaOrdenesFinal = [];
    }
    return listaOrdenesFinal;
  }

  Future<http.Response> insertarSalidaApi({ required int id, required String numEmpleado, required String nombre, required String fecha, required String hora, required String tipo, required String createAt, required String user, required String fechaS, required String horaS, required String createAtS, required String userS, required String status}) async {
    return await http.put(Uri.parse('$urlHacerSalida/$id'), body: {
      'numEmpleado': numEmpleado,
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'tipo': tipo,
      'createAt': createAt,
      'user': user,
      'fechaS': fechaS,
      'horaS': horaS,
      'createAtS': createAtS,
      'userS': userS,
      'status': status,
    });
  }

  Future<RespuestaUtilityModel> insertarSalida(EnSaModel enSaModel) async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await insertarSalidaApi(
        id: enSaModel.idEnSa,
        numEmpleado: '',
        nombre: enSaModel.nombre,
        fecha: enSaModel.fecha,
        hora: enSaModel.hora,
        tipo: 'Entrada y Salida',
        createAt: enSaModel.createAt, 
        user: widget.user.name,
        fechaS: dateString,
        horaS: hourString,
        createAtS: dateString + ' ' + hourString,
        userS: widget.user.name,
        status: 'I',
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);
        if(response.statusCode != 200) {
          throw 'Error';
        }

      
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