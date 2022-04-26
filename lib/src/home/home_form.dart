import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/acerca/acerca_form.dart';
import 'package:santiago4x4pro/src/eventos/eventos_form.dart';
import 'package:santiago4x4pro/src/noticias/noticas_form.dart';
import 'package:santiago4x4pro/src/productos/productos_form.dart';
import 'package:santiago4x4pro/widget/drawer.dart';

class HomeForm extends StatefulWidget {

  final UserModel user;
  final UserRepository userRepository;
  const HomeForm({Key? key, required this.userRepository,  required this.user }) : super(key: key);
  
  @override
  _HomeFormState createState() => _HomeFormState();

}

class _HomeFormState extends State<HomeForm> {
  
  List<DocumentSnapshot> documents = [];

  @override
  void initState() { 
    super.initState();
    bloc.addUserModel(widget.user);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      drawer: MenuDrawer(user: widget.user),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Inicio',
        ),
        backgroundColor: const Color.fromRGBO(44, 197, 94, 1),
      ),
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: const TabBar(
            labelPadding: EdgeInsets.all(1),
            unselectedLabelColor: Colors.black,
            labelColor: Color.fromRGBO(44, 197, 94, 1),
            indicatorColor: Color.fromRGBO(44, 197, 94, 1),
            labelStyle: TextStyle(
              fontSize: 14,
            ),
            tabs: [
              Tab(child: Center(child: Text("Noticias"))),
              Tab(child: Center(child: Text("Eventos"))),
              Tab(child: Center(child: Text("Productos"))),
              Tab(child: Center(child: Text("Acerca de"))),
            ],
          ),
          body: TabBarView(
            children: [
              const Noticias(),
              Eventos(userRepository: widget.userRepository),
              const Productos(),
              const Acerca(),
            ],
          ),
        ),
      ),
    );
  }
}
