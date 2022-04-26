import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/evento.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/eventos/detalle_evento_form.dart';

class Eventos extends StatefulWidget {
  final UserRepository userRepository;
  const Eventos({ Key? key, required this.userRepository }) : super(key: key);

  @override
  _EventosState createState() => _EventosState();
}

class _EventosState extends State<Eventos> {

  List<DocumentSnapshot> documents = [];

  late Evento event;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').where('status', isEqualTo: 'A').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          documents.clear();
          documents.addAll(snapshot.data!.docs);
          return snapshot.data!.docs.isNotEmpty ?  Column(
            children: [
              Flexible(
                child: ListView(
                  children:  _event(snapshot.data!.docs),
                )
              ),
            ],
          ) : _noeventos();
        } 
        else {
          const SizedBox();
        }
        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  List<Widget> _event(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
    for (var document in doc) {
      items.add(  
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
              child: Column(
                children: [
                   document.get('urlImage') != "" ?  
                   Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.network(
                        document.get('urlImage').toString(),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ) : 
                   Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.2,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          document.get('evento').toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15
                          ) 
                        ),
                      ), 
                      Container(
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          'Ver mas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(44, 197, 94, 1)
                          ),
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              event = Evento(
                uid: document.id.toString(),
                detalle: document.get('detalle').toString(), 
                empieza: document.get('empieza').toString(), 
                evento: document.get('evento').toString(), 
                fecha: document.get('fecha').toString(),
                lugar: document.get('lugar').toString(),
                termina: document.get('termina').toString(),
                urlImage: document.get('urlImage').toString()
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetalleEvento(evento: event, user: bloc.userBloc, userRepository: widget.userRepository,)));
            }
          ),
        )
      );
    }
    return items;
  }

  Widget _noeventos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.tickets,
            color: Colors.grey[400],
            size: 120,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'No hay eventos disponibles',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 25
              ),
            ),
          )
        ],
      ),
    );
  }
}