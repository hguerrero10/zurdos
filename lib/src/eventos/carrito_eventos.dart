import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/evento.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/carta/carta_form.dart';
import 'package:santiago4x4pro/src/home/home_screen.dart';
// ignore: unused_import
import 'package:santiago4x4pro/widget/clipper/dottedLine.dart';
import 'package:santiago4x4pro/widget/clipper/ticketClipper.dart';
import 'package:santiago4x4pro/widget/dialog/dialog.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;

class Carrito extends StatefulWidget {
  final UserModel user;
  final Evento evento;
  final UserRepository userRepository;
  const Carrito({Key? key, required this.user, required this.evento, required this.userRepository}) : super(key: key);

  @override
  _CarritoState createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {

  DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
  }

  enviar() async {
    for(var item in bloc.cartItems) {
      await FirebaseFirestore.instance.collection('compras').add({
        'producto': item.descripcion,
        'total': item.costoTotal,
        'precio': item.precio,
        'fecha': dateFormat.format(DateTime.now()),
        'cantidad': item.cantidad.toString(),
        'talla': '',
        'uidUser': widget.user.uid,
        'uidProducto': widget.evento.uid,
        'urlImage': widget.evento.urlImage,
      });

    }
  }

  Future<void> initPaymentSheet(context, {required String email, required double amount}) async {
    try {
      final response = await http.post(
        Uri.parse('https://us-central1-santiago-app-8bfa0.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {
          'email': widget.user.email,
          'name': widget.user.name,
          'amount': amount.toString(),
          'description': 'Evento: ${widget.evento.evento}',
          'phone': widget.user.phone
        }
      );
      final jsonResponse = jsonDecode(response.body);
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'Santiago 4x4 Pro',
          customerId: jsonResponse['customer'],
          style: ThemeMode.dark,
          customFlow: false,
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          testEnv: false,
          primaryButtonColor: Colors.blueAccent,
          merchantCountryCode: 'MXN',
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
      await enviar();
      await addEventos().then((value) => {
        showAlertDialog(amount)
      });
      bloc.deleteCartEvent();
    } catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra no efectuada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> addEventos() async {
    await FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection("participantes").add({
      'uidUser': widget.user.uid,
      'uidEvento': widget.evento.uid
    });
    await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection("eventos").add({
      'email': widget.user.email, 
      'empieza': widget.evento.empieza,
      'evento': widget.evento.evento,
      'fecha': widget.evento.fecha,
      'lugar': widget.evento.lugar,
      'name': widget.user.name,
      'status': "A",
      'termina': widget.evento.termina,
      'urlImage': widget.evento.urlImage,
      'uidEvento': widget.evento.uid,
      'uidUser': widget.user.uid
    }).then((value) => {
      addInvitados(value.id)
    });
  }

  Future<void> addInvitados(String doc) async {
    for(var item in bloc.participantes) {
      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('participantes').add({
        'participante': item.participante,
        'nombre': item.nombre,
        'direccion': item.direccion,
        'colonia': item.colonia,
        'ciudad': item.ciudad,
        'estado': item.estado,
        'cp': item.cp,
        'telefono': item.telefono,
        'celular': item.celular,
        'email': item.email,
        'sangre': item.sangre,
        'vehiculo': item.vehiculo,
        'ano': item.ano,
        'color': item.color,
        'placas': item.placas,
        'expedicion': item.expedicion,
        'compania': item.compania,
        'medico': item.medico,
        'edad': item.edad,
        'uidEvento': widget.evento.uid,
        'createAt': dateFormat.format(DateTime.now())
      });
    }
    bloc.deletePartipantes();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getStream,
      builder: (context, snapshot) {
    // bloc.dialog == true ? log('YA') : dialog('Aviso', '', Icons.info, Colors.orange, Colors.white, context, () {}, Center(), () {});
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color.fromRGBO(209, 65, 12, 1),
                expandedHeight: 120.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/compras.jpg'),
                            fit: BoxFit.cover
                          )
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromRGBO(44, 197, 94, 1).withOpacity(.9),
                                const Color.fromRGBO(44, 197, 94, 1).withOpacity(.9),
                              ]
                            )
                          ),
                        )
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white,),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    return Column(
                      children: [
                        _item(),
                        const SizedBox(height: 10),
                      ]
                    );
                  },
                  childCount: 1,
                )
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _submitButton(),
        );
      }
    );
  }

  _item() {
    return Column(
      children: List.generate(bloc.cartItems.length, (index) {
        var _contador = int.parse(bloc.cartItems[index].cantidad);
        var _resultadoN = double.parse(bloc.cartItems[index].precio);
        var _costoN = double.parse(bloc.cartItems[index].costoTotal);
        double total;
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      bloc.cartItems[index].descripcion
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '\$ ',
                          style: TextStyle(
                            color: Color.fromRGBO(44, 197, 94, 1),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          bloc.cartItems[index].costoTotal,
                          style: const TextStyle(
                            color: Color.fromRGBO(44, 197, 94, 1)
                          ),
                        ),
                        const Text(
                          ' MXN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_contador == 1) {
                              dialog(
                                'Aviso', 
                                '', 
                                CupertinoIcons.cart_badge_minus, 
                                const Color.fromRGBO(209, 65, 12, 1),
                                Colors.white, 
                                context, 
                                () async {
                                  bloc.removeFromCart(bloc.cartItems[index]);
                                  Navigator.pop(context);
                                },
                                Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      '¿Estas seguro de eliminar ${bloc.cartItems[index].descripcion} del carrito?',
                                      style: const TextStyle(
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                              );
                            } else {
                              _contador--;
                              total = _costoN - _resultadoN;
                              setState(() => bloc.cartItems[index].cantidad = _contador.toString());
                              setState(() => bloc.cartItems[index].costoTotal = total.toString());
                              bloc.updateToCart(bloc.cartItems[index]);
                            }
                          },
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(44, 197, 94, 1),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: Text(
                              bloc.cartItems[index].cantidad,
                              style: const TextStyle(
                                color: Colors.white,
                              ),

                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _contador++;
                              total = _costoN + _resultadoN;
                              setState(() => bloc.cartItems[index].cantidad = _contador.toString());
                              setState(() => bloc.cartItems[index].costoTotal = total.toString());
                              bloc.updateToCart(bloc.cartItems[index]);
                            });
                          },
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )        
        );
      })
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                '\$${bloc.getPrice()}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Text(
                ' MXN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () async {
                if(bloc.participantes.isNotEmpty) {
                  await initPaymentSheet(context, email: widget.user.email, amount: bloc.getPrice() * 100.00);
                } else {
                  dialog(
                    'Aviso',
                    '', 
                    Icons.info_outline, 
                    Colors.orange, 
                    Colors.white, 
                    context, () { 
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartaResponsivaForm()));
                    },
                    const Text(
                      'Antes de realizar la compra, tendras que completar la CARTA DE RESPONSABILIDAD.',
                      textAlign: TextAlign.center,
                    ), 
                    () => Navigator.pop(context)
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1)),
              ), 
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  'Pagar',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _noCarrito() {
    List<Widget> items = [];
    items.add(
      Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Center(
            child: SizedBox( 
              width: 300, 
              height: 300, 
              child: Center(
                child: Image.asset('assets/carrito-vacio.png')
              )
            ),
          ),
        ],
      )
    );
    return items;
  }

  void showAlertDialog(amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: ClipPath(
            clipper: TicketClipper(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                insetPadding: const EdgeInsets.all(30),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        color: Colors.green,
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.check_mark_circled, 
                            color: Colors.white, 
                            size: 60
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Compra exitosa',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: Text(
                          'Gracias por realizar tu compra del evento ${widget.evento.evento}.',
                          textAlign: TextAlign.justify,
                          style:  const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35, right: 20, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style:  TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              '\$$amount MXN',
                              style:  const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green)
                            ),
                            onPressed: () {
                              bloc.deleteCartEvent();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(userRepository: widget.userRepository, user: widget.user)), (route) => false);
                            }, 
                            child: const Text(
                              'Aceptar',
                              style: TextStyle(
                              ),
                            ) 
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
