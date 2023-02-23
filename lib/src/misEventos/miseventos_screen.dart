import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/misEventos/miseventos_form.dart';

class MisEventosScreen extends StatelessWidget {
  
  final UserModel user;
  const MisEventosScreen({Key? key,  required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Eventos',
        ),
        backgroundColor: const Color.fromRGBO(0, 17, 134, 1)  ,
      ),
      body: MisEventosForm(user: user,),
    );
  }
}