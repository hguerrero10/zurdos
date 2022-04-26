import 'package:flutter/material.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/home/home_form.dart';

class HomeScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final UserModel user;

  const HomeScreen({Key? key, required UserRepository userRepository, required this.user}) : _userRepository = userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HomeForm(userRepository: _userRepository, user: user),
      ),
    );
  }
}