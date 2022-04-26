import 'package:flutter/material.dart';
import 'package:santiago4x4pro/src/reglamento/reglamento_form.dart';

class ReglamentoScreen extends StatelessWidget {

  const ReglamentoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Reglamento'),
        backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
      ),
      body: const ReglamentoForm(),
    );
  }
}