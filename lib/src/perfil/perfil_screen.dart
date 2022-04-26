import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/perfil/perfil_form.dart';

class PerfilScreen extends StatelessWidget {

  final UserModel user;
  const PerfilScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Perfil'),
        backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
      ),
      body: PerfilForm(user: user),
    );
  }
}
