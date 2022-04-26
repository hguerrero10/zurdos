import 'package:flutter/material.dart';
import 'package:santiago4x4pro/src/patrocinadores/patrocinadores_form.dart';

class PatrocinadoresScreen extends StatelessWidget {

  const PatrocinadoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Patrocinadores'),
        backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
      ),
      body: const PatrocinadoresForm(),
    );
  }
}
