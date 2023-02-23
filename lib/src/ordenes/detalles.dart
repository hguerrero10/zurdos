import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/ordenes.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';


class DetalleOrdenes extends StatefulWidget {
  final UserModel user;
  final UserRepository userRepository;

  final OrdenesModel ordenesModel;

  const DetalleOrdenes({ Key? key, required this.userRepository,  required this.user, required this.ordenesModel }) : super(key: key);

  @override
  State<DetalleOrdenes> createState() => _DetalleOrdenesState();
}

class _DetalleOrdenesState extends State<DetalleOrdenes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
        backgroundColor: Color(0xfb234798),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [

              _encabezadoText('Folio'),
              _detalleText(widget.ordenesModel.folio),
              SizedBox(height: 10),


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
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              encabezdo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 17, 134, 1),
                fontSize: 25
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
                fontSize: 20
              ),
            ),
          ),
        )
      ],
    );
  }

}