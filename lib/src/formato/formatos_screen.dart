import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/formato/formato_salida_form.dart';
import 'package:santiago4x4pro/src/home/home_form.dart';

class FormatoSScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final UserModel user;

  const FormatoSScreen({Key? key, required UserRepository userRepository, required this.user}) : _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SalidaForm(userRepository: _userRepository, user: user),
      ),
    );
  }
}