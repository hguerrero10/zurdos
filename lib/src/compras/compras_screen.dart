import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/compras/compras_form.dart';

class ComprasScreen extends StatelessWidget {
  
  final UserModel user;
  const ComprasScreen({Key? key,  required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Compras'),
        backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
      ),
      body: ComprasForm(user: user,),
    );
  }
}
