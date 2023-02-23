import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/models/evento.dart';
import 'package:santiago4x4pro/models/intinerario.dart';
import 'dart:ui';

import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/carta/carta_form.dart';
import 'package:santiago4x4pro/src/eventos/compra_evento.dart';
import 'package:santiago4x4pro/widget/clipper/dottedLine.dart';

class DetalleEvento extends StatefulWidget {
  final UserModel user;
  final Evento evento;
  final UserRepository userRepository;
  const DetalleEvento({Key? key, required this.evento, required this.user, required this.userRepository}) : super(key: key);

  @override
  _DetalleEventoState createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(209, 65, 12, 1),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 17, 134, 1)  ),
          ),
          onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> CompraEvento(evento: widget.evento,user: widget.user,userRepository: widget.userRepository,))),
          child: const Center(
            child: Text(
              'Entradas', 
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, 
              )
            )
          ),
        ), 
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromRGBO(0, 17, 134, 1)  ,
            expandedHeight: 140.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.evento.urlImage),
                        fit: BoxFit.fill,
                      ),
                    ),   
                    child: ClipRect(
                      child: BackdropFilter(
                        filter:  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                          ),
                      ),
                    ),
                  ),    
                ]
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return Column(
                  children: [
                    inicio(),
                    // _botonesContacto(),
                    const DottedLine(dashColor: Colors.grey,),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        widget.evento.evento,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _contenedor(),
                    const SizedBox(height: 15),
                    // _ubicacionEvento(),
                    const DottedLine(dashColor: Colors.grey,),
                    const SizedBox(height: 20),
                    const Text(
                      "Detalle evento",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        widget.evento.detalle,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DottedLine(dashColor: Colors.grey,),
                    const SizedBox(height: 20),
                    const Text(
                      "Costos",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Socios pista Santiago 4x4 Pro",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, 
                      child: _costoSocios()
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Costos invitados",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, 
                      child: _costoInvitados()
                    ),
                    const SizedBox(height: 20),
                    const DottedLine(dashColor: Colors.grey,),
                    const SizedBox(height: 20),
                    const Text(
                      "Souvenirs",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8, 
                      child: _costoSouvenirs()
                    ),
                    const SizedBox(height: 80),
                  ]
                );
              },
              childCount: 1,
            )
          ),
        ],
      ),
    );
  }

  Widget _costoInvitados() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection('costos').where('socio', isEqualTo: '0').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData){
          return Column(
            children:  List.generate(snapshot.data!.docs.length, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _precios(snapshot.data!.docs[index]['descripcion'], "\$${snapshot.data!.docs[index]['costo']}")
              );
            }),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _costoSocios() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection('costos').where('socio', isEqualTo: '1').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children:  List.generate(snapshot.data!.docs.length, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _precios(snapshot.data!.docs[index]['descripcion'], "\$${snapshot.data!.docs[index]['costo']}")
              );
            }),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _costoSouvenirs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection('souvenirs').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children: List.generate(snapshot.data!.docs.length, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  snapshot.data!.docs[index]['descripcion'], 
                  style: const TextStyle(
                    color: Colors.black54
                  ),
                )
              );
            }),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget inicio() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 3),
                    Text(
                      widget.evento.fecha.split('/')[1],
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                      ),
                    ),
                    Text(
                      widget.evento.fecha.split('/')[0],
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.7,
              child: const Text(
                "Pista para Jeep, Cuadrimotos, Razors, Motocross.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 23
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void whatsAppOpen(String phone, String msg) async {
    // await FlutterLaunch.launchWathsApp(phone: phone, message: msg);
  }

  Widget _botonesContacto() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      GestureDetector(
        child: Column(
          children: const [
            Icon(
              Icons.shopping_cart,
              color: Colors.grey,
              size: 35,
            ),
            SizedBox(height: 10),
            Text("Comprar")
          ],
        ),
        // onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=> CompraEvento(evento: widget.evento, user: widget.user)));},
      ),
      GestureDetector(
        child: Column(
          children: const[
            Icon(
              Icons.my_location,
              color: Color.fromRGBO(10, 96, 255, 1),
              size: 35,
            ),
            SizedBox(height: 10),
            Text("Ubicacion")
          ],
        ),
        onTap: (){},
      ),
      GestureDetector(
        child: Column(
          children: [
            Image.asset("assets/whatsapp.png", height: 35, width: 35),
            const SizedBox(height: 10),
            const Text("WhatsApp")
          ],
        ),
        onTap: ()=> whatsAppOpen('528184723848', ''),
      )
    ],
  );
}


Widget _contenedor() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(
        width: 75,
        height: 30,
        child: Icon(
          Icons.calendar_today,
          size: 23,
          color: Colors.black54,
        )
      ),
      Column(
        children: [
          SizedBox(
            width: 200,
            height: 20,
            child: Text(
              "Empieza: ${widget.evento.empieza} AM",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 20,
            child: Text(
              "Termina: ${widget.evento.termina} PM",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54
              ),
            ),
          ),
        ],
      ),
    ],
  );
}


Widget _ubicacionEvento() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Center(
              child: Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
            Container()
          ],
        )
      ),
      SizedBox(
        height: 60,
        child: Column(
          children: <Widget>[
            const SizedBox(height:10),
            SizedBox(
              width: 180,
              child: Text(
                widget.evento.lugar,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            Text(
              widget.evento.evento,
              style: const TextStyle(
                fontSize: 10
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget _precios(String lugar, String costo){
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          '-' + lugar,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54
          ),
        ),
      ),
      const SizedBox(width: 5),
      Text(
        costo,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54
        ),
      ),
    ],
  );
}
}