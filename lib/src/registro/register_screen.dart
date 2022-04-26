import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/bloc/registro_bloc/bloc.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/registro/register_form.dart';

class RegisterScreen extends StatelessWidget {

  final UserRepository _userRepository;

  const RegisterScreen({Key? key, required UserRepository userRepository}) : _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: RegisterForm(),
      ),
    );
  }
}