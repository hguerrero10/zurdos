import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/misEventos/eventDetails.dart';
import 'package:santiago4x4pro/widget/clipper/dolDurmaClipper.dart';

class MisEventosForm extends StatefulWidget {
  
  final UserModel user;
  const MisEventosForm({Key? key, UserRepository? userRepository,  required this.user}) : super(key: key);
  
  @override
  _MisEventosFormState createState() => _MisEventosFormState();
}

class _MisEventosFormState extends State<MisEventosForm> {

  List<DocumentSnapshot> documents = [];

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const TabBar(
            labelPadding: EdgeInsets.all(1),
            unselectedLabelColor: Colors.black,
            labelColor: Color.fromRGBO(0, 17, 134, 1)  ,
            indicatorColor: Color.fromRGBO(0, 17, 134, 1)  ,
            labelStyle: TextStyle(
              fontSize: 14,
            ),
            tabs: [
             Tab(child: Center(child: Text("Activos"))),
             Tab(child: Center(child: Text("Anteriores"))),
            ],
          ),
          body: TabBarView(
            children: [
              _eventoActivo(),
              _eventoInactivo(),
            ],
          ),
        ),
      )
    );
  }

  Widget _eventoActivo() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('eventos').where('status', isEqualTo: 'A').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData){
          return snapshot.data!.docs.isNotEmpty ?  Column(
            children: [
              Flexible(
                child: ListView(  
                  children: _eventoA(snapshot.data!.docs)
                ),
              ),
            ],
          )  : _noeventos('No asistiras a ningún evento');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _eventoInactivo() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('eventos').where('status', isEqualTo: 'I').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData){
          return snapshot.data!.docs.isNotEmpty ? Column(
            children: [
              Flexible(
                child: ListView(  
                  children:  _eventoPasado(snapshot.data!.docs)  
                ),
              ),
            ],
          ) : _noeventos('No hay eventos pasados');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

   Widget _noeventos(String text) {
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
              text,
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

  List<Widget> _eventoA(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
    for (var document in doc) {
      items.add(
        GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipPath(
                  clipper: DolDurmaClipper(right: 160, holeRadius: 40),      
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 200.0,
                              height: 150.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 45,
                                          height: 60,
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(height: 3),
                                                Text(
                                                  document.get('fecha').toString().split('/')[1],
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22
                                                  ),
                                                ),
                                                Text(
                                                  document.get('fecha').toString().split('/')[0],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 120,
                                          height: 55,
                                          child: Text(
                                          "${document.get("evento").toString().split(' ')[0]} ${document.get("evento").toString().split(' ')[1]}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 200.0,
                                      height: 25.0,
                                      child: Text(
                                        "${document.get("empieza").toString().split(' ')[1]} AM",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black54, 
                                          fontSize: 18.0
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                            Container(
                              width: 200.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(13.0),
                              ),
                              child: document.get("urlImage") == '' ? Image.asset('assets/no-image.jpg') : 
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                "${document.get("urlImage").toString()}",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                )
                              )
                            ),
                            SizedBox(height: 5),
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
              ]
            ),
          // onTap: ()=> submit(document.data['fecha'].toString())
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsEvent(document: document, user: widget.user)))
        ),
      );
    }
    return items;
  }

  List<Widget> _eventoPasado(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
      for (var document in doc) {
        items.add(
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipPath(
                  clipper: DolDurmaClipper(right: MediaQuery.of(context).size.width * 0.45, holeRadius: 40),      
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 200.0,
                              height: 150.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 45,
                                          height: 60,
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                const SizedBox(height: 3),
                                                Text(
                                                  document.get('fecha').toString().split('/')[1],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22
                                                  ),
                                                ),
                                                Text(
                                                  document.get('fecha').toString().split('/')[0],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 120,
                                          height: 55,
                                          child: Text(
                                          "${document.get("evento").toString().split(' ')[0]} ${document.get("evento").toString().split(' ')[1]}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200.0,
                                      height: 25.0,
                                      child: Text(
                                        "${document.get("empieza").toString().split(' ')[1]} AM",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black54, 
                                          fontSize: 18.0
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                            Container(
                              width: 200.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(13.0),
                              ),
                              child: document.get("urlImage") == '' ? Image.asset('assets/no-image.jpg') : 
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                document.get("urlImage").toString(),
                                color: Colors.grey,
                                colorBlendMode: BlendMode.saturation, 
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                )
                              )
                            ),
                            const SizedBox(height: 5),
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
              ]
            ),
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsEvent(document: document, user: widget.user)))
,
        ),
      );
    }
    return items;
  }
}