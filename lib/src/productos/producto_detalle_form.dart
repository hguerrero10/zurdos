import 'dart:convert';
import 'dart:developer';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/carrito.dart';
import 'package:santiago4x4pro/models/producto.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/home/home_screen.dart';
import 'package:santiago4x4pro/src/productos/carrito_productos.dart';
import 'package:santiago4x4pro/widget/clipper/ticketClipper.dart';
import '../../util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleProducto extends StatefulWidget {
  final Producto product;
  final UserModel user;

  const DetalleProducto({Key? key, required this.product, required this.user}): super(key: key);

  get userRepository => null;
  
  @override
  _DetalleProductoState createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // PaymentMethod paymentMethod = PaymentMethod();

  DateFormat dateFormat = DateFormat('yyyy/MM/dd');


  Producto? producto;
  CarritoModel? carritoModel;

  int _counter = 1;
  late double result;
  late double _counterTotal;

  List<int> _selectedItems = []; 
  var currency = 'MXN'; 

  var now = DateTime.now();
  var forma = DateFormat('yMd');

  @override
  void initState() {
    super.initState();
    _counterTotal = double.parse(widget.product.precio);
    result = double.parse(widget.product.precio);        
  }
 
  void addPaymentDetailsToFirestore() {
    FirebaseFirestore.instance.collection("users").doc(widget.user.uid).collection("Payments").add({
      'currency': "{$currency}",
      'amount': "$result",
      'product': widget.product.producto,
      'image': widget.product.urlImage,
      'quantity': _counter,
      'date': forma.format(now)
    });
  }

  void addPayments() {
    FirebaseFirestore.instance.collection("payments").add({
      'currency': "{$currency}",
      'amount': "$result",
      'product': widget.product.producto,
      'image': widget.product.urlImage,
      'date': forma.format(now),
      'quantity': _counter,
      'uidUser': widget.user.uid
    });
  }



  void addSocios() {
    late int fecha = int.parse(forma.format(now).split('/')[2]) + 1;
    var fechaFinal = '${forma.format(now).split('/')[0]}/${forma.format(now).split('/')[1]}/$fecha';

    FirebaseFirestore.instance.collection("users").doc(widget.user.uid).update({'socio': "1"});
    FirebaseFirestore.instance.collection("socios").add({
      'email': widget.user.email,
      'final':  fechaFinal,
      'inicio': forma.format(now),
      'name': widget.user.name,
      'phone': widget.user.phone,
      'uid': widget.user.uid
    });
  }

  List tallas = [
    {'talla': 'XS'},
    {'talla': 'S'},
    {'talla': 'M'},
    {'talla': 'L'},
    {'talla': 'XL'},
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getStream,
      initialData: bloc.cartStreamController,
      builder: (context, snapshot) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _button(),
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF949598),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              bloc.cartItemsProductos.isNotEmpty ? IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoPrductos(user: widget.user)));
                }, 
                icon: const Icon(
                  CupertinoIcons.cart, 
                  color: Color(0xFF949598)
                )
              ) : const SizedBox()
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  height: 250,
                  width: MediaQuery.of(context).size.width * 1.2,
                  child:  widget.product.urlImage == '' ?
                  Image.asset('assets/no-image.jpg') : 
                  Image.network(
                    widget.product.urlImage,
                    fit: BoxFit.contain
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: const Divider(
                    height: 1,
                    color: Colors.grey,
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        widget.product.producto,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Descripción",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        widget.product.descripcion,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: Color(0xFF949598),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                result != _counterTotal ? "\$ " + result.toString() : "\$ " + _counterTotal.toString(),
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
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1))
                                  ),
                                  child: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if(_counter == 1) {
                                        _counter = 1;
                                      } else {
                                        _counter--;
                                        result =  result - _counterTotal;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30),
                                child: Text(
                                  _counter.toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFF949598),
                                  )
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1))
                                  ),
                                  child: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _counter++;
                                      result =  _counterTotal * _counter;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.product.categoria == 'Ropa' ? Column(
                      children: [
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 15),
                              child: Text(
                                "Seleccionar talla",
                                style: TextStyle(
                                  fontSize: 16,
                                )
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(tallas.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100)
                                        )
                                      ),
                                      side: MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                          color: Colors.grey
                                        ),
                                      ),
                                      overlayColor: MaterialStateProperty.all(Colors.grey[200]),
                                      backgroundColor: MaterialStateProperty.all(_selectedItems.contains(index) ? const Color.fromRGBO(44, 197, 94, 1) : Colors.white)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedItems = [];
                                        _selectedItems.add(index);
                                      });
                                    },
                                    child: Text(
                                      tallas[index]['talla'],
                                      style: TextStyle(
                                        color: _selectedItems.contains(index) ? Colors.white : Colors.grey[600]
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                    const SizedBox(height: 50)
                  ],
                ),
              ],
            ),
          )
        );
      }
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                initPaymentSheet(context, amount: result != _counterTotal ? result * 100 :  _counterTotal * 100);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1)),
              ), 
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Comprar',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initPaymentSheet(context, {required double amount}) async {
    try {
      final response = await http.post(Uri.parse('https://us-central1-santiago-app-8bfa0.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {
          'email': widget.user.email,
          'name': widget.user.name,
          'amount': amount.toString(),
          'description': widget.product.producto,
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
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
          testEnv: false,
          primaryButtonColor: Colors.blueAccent,
          merchantCountryCode: 'MXN',
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
      await enviar();
      showAlertDialog(amount);
      bloc.deleteCartProduct();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago efectuado correctamente')));
    } catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra no efectuada')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  enviar() async {
    await FirebaseFirestore.instance.collection('compras').add({
      'producto': widget.product.producto,
      'total': result != _counterTotal ? result :  _counterTotal,
      'precio': widget.product.precio,
      'fecha': dateFormat.format(DateTime.now()),
      'cantidad': _counter.toString(),
      'talla': _selectedItems == [] ? '' : _selectedItems[0],
      'uidUser': widget.user.uid,
      'uidProducto': widget.product.uid,
      'urlImage': widget.product.urlImage,
    });
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
                  height: MediaQuery.of(context).size.height * 0.5,
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
                          'Gracias por tu compra de ${widget.product.producto}.',
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
                            Row(
                              children: [
                                const Text(
                                  '\$',
                                  style:  TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  result != _counterTotal ? result.toString() :  _counterTotal.toString() + ' MXN',
                                  style:  const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
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