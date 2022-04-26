import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/bloc/login_bloc/bloc.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  
  final UserRepository _userRepository;

  const LoginScreen({Key? key, required UserRepository userRepository}) : _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}