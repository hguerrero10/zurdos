import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:santiago4x4pro/widget/toast.dart';

class EntradasFormE extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;

  const EntradasFormE({ Key? key, required this.userRepository,  required this.user }) : super(key: key);

  @override
  State<EntradasFormE> createState() => _EntradasFormEState();
}

class _EntradasFormEState extends State<EntradasFormE> {

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

  var date = DateFormat.yMMMMd('es');
  var hour = DateFormat.Hm('es');
  var dateString = '';
  var hourString = '';
  String urlGetUsersServer = 'https://zurdosapi.tlk.com.mx/getEmpleadosES';
  String urlSalida = 'https://zurdosapi.tlk.com.mx/addNewEntradas';
  String urlEntrada = 'https://zurdosapi.tlk.com.mx/addNewEntradas';

  @override
  void initState() {
    dateString = date.format(DateTime.now());
    hourString = hour.format(DateTime.now());
    obtenerEmpleados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Entradas y salidas de empleados'),
        backgroundColor: Color(0xfb234798),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),

              _crearDropDownEmpleado(),

              SizedBox(height: 20),

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

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  GestureDetector(
                    onTap: () async {
                      RespuestaUtilityModel respuestaUtilityModel = await insertarEntrada();
                      if(!respuestaUtilityModel.error) {
                        Navigator.pop(context);
                        toast('Entrada creada');
                      } else {
                        toast(respuestaUtilityModel.mensaje);
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.green
                      ),
                      child: Center(
                        child: Text(
                          'ENTRADA',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () async {
                      RespuestaUtilityModel respuestaUtilityModel = await insertarSalida();
                      if(!respuestaUtilityModel.error) {
                        Navigator.pop(context);
                        toast('Salida creada');
                      } else {
                        toast(respuestaUtilityModel.mensaje);
                      }
                    },
                    child: Container(
                      width: 160,
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.red
                      ),
                      child: Center(
                        child: Text(
                          'SALIDA',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                  ),
                  

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<http.Response> obtenerEmpleadosApi() async {
    return await http.get(Uri.parse(urlGetUsersServer));
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
        List<String> listaParsedJson = [];

        if(parsedJson['Empleados'] != null) {
          for(int i = 0; i < parsedJson['Empleados'].length; i++) {
            listaParsedJson.add(parsedJson['Empleados'][i]['nombre'] + ' ' +  parsedJson ['Empleados'][i]['apellidoP'] + ' ' + parsedJson['Empleados'][i]['apellidoM']);
          }
        }

        _empleados.addAll(listaParsedJson);

      
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
        hint: "Seleccionar empleado...",
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

  Future<http.Response> insertarEntradaApi({ required int numEmpleado, required String nombre,  required String fecha, required String hora, required String tipo, required String createAt, required String user }) async {
    return await http.post(Uri.parse(urlEntrada), body: {
      'numEmpleado': '',
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'tipo': tipo,
      'createAt': createAt,
      'user': user,
    });
  }

  Future<RespuestaUtilityModel> insertarEntrada() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await insertarEntradaApi(
        numEmpleado: 1,
        nombre: selectEmpleado!,
        fecha: dateString,
        hora: hourString,
        tipo: 'Entrada',
        createAt: dateString + ' ' + hourString, 
        user: widget.user.name
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

  Future<http.Response> insertarSalidaApi({required int numEmpleado, required String nombre, required String fecha, required String hora, required String tipo, required String createAt, required String user}) async {
    return await http.post(Uri.parse(urlSalida), body: {
      'numEmpleado': '',
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
      'tipo': tipo,
      'createAt': createAt,
      'user': user,
    });
  }

  Future<RespuestaUtilityModel> insertarSalida() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      await insertarSalidaApi(
        numEmpleado: 1,
        nombre: selectEmpleado!,
        fecha: dateString,
        hora: hourString,
        tipo: 'Salida',
        createAt: dateString + ' ' + hourString, 
        user: widget.user.name
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