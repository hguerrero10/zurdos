import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/widget/clipper/dottedLine.dart';
import 'package:santiago4x4pro/widget/clipper/ticketClipper.dart';

class DetailsEvent extends StatefulWidget {

  final DocumentSnapshot document;
  final UserModel user;
  const DetailsEvent({Key? key, required this.document, required this.user}) : super(key: key);

  @override
  _DetailsEventState createState() => _DetailsEventState();
}

class _DetailsEventState extends State<DetailsEvent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/fondoTicket.jpg'),
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
                    ClipPath(
                      clipper: TicketClipper(),
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width * 1.2,
                        height: 20,
                      )
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: QrImage(
                        data: widget.document.id,
                        version: QrVersions.auto,
                        size: 110.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const DottedLine(dashColor: Colors.grey,),
                    const SizedBox(height: 20),
                    Text(
                      widget.user.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 20),
                    Text(
                     widget.document.get("evento").toString(),
                     textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 17, 134, 1)  ,
                        fontSize: 18
                      )
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        ticketDetailsWidget('Empieza', widget.document.get("empieza").toString().split(' ')[0], 'Termina', widget.document.get("termina").toString().split(' ')[0]),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 20),
                          child: ticketDetailsWidget('Ubicacion', widget.document.get("lugar").toString(), '', ''),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20),
                          child: Text(
                            'Invitados', 
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ],
                    ),
                    _listEntradas(),
                    _info(),
                    const SizedBox(height: 20),
                    const DottedLine(dashColor: Colors.grey,),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '“Cuando uno es todoterreno, lo que sobran son amigos”',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        '#ExpertosDelOffroad',
                        style: TextStyle(
                          color: Colors.grey[400]
                        ),
                      ),
                    ),
                  ],
                );
              },
              childCount: 1,
            )
          ),
        ],
      ),
    );
  }

  Widget _listEntradas() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('participantes').where(widget.document.id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children: List.generate(snapshot.data!.docs.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: _entradas(snapshot.data!.docs[index].get('nombre'), snapshot.data!.docs[index].get('participante'))
              );
            })
          );
        }
        return const Center(child: SizedBox());
      },
    );
  }

  Widget _info() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('participantes').where(widget.document.id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Fecha de compra', 
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        snapshot.data!.docs[0].get('createAt'),
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 17, 134, 1)  ,
                          fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(child: SizedBox());
      },
    );
  }


  Widget _entradas(String descripcion, String cantidad) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Text(
              descripcion,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(0, 17, 134, 1)  ,
              ),
            ),
          ),
          Text(
            cantidad,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600]
            ),
          ),
        ],
      ),
    );
  }

   Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle, style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc, style: const TextStyle(
                    color: Color.fromRGBO(0, 17, 134, 1)  ,
                    fontSize: 15
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle, style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc, style: const TextStyle(
                    color: Color.fromRGBO(0, 17, 134, 1)  ,
                    fontSize: 15
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}