import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/widget/dialog/dialog.dart';

class CarritoPrductos extends StatefulWidget {
  final UserModel user;
  const CarritoPrductos({ Key? key, required this.user }) : super(key: key);

  @override
  _CarritoPrductosState createState() => _CarritoPrductosState();
}

class _CarritoPrductosState extends State<CarritoPrductos> {

    Future<void> initPaymentSheet(context, {required String email, required double amount}) async {
    try {
      final response = await http.post(Uri.parse('https://us-central1-santiago-app-8bfa0.cloudfunctions.net/stripePaymentIntentRequest'),
        body: {
          'email': email,
          'name': widget.user.name,
          'amount': amount.toString(),
          'description': 'Producto',
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
          primaryButtonColor: const Color.fromRGBO(0, 17, 134, 1)  ,
          merchantCountryCode: 'MXN',
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
      bloc.deleteCartProduct();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment completed!')));
    } catch (e) {
      if (e is stripe.StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra no efectuado')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            const Color.fromRGBO(0, 17, 134, 1)  .withOpacity(.9),
                            const Color.fromRGBO(0, 17, 134, 1)  .withOpacity(.9),
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
                    listItems(),
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
      floatingActionButton: boton(),
    );
  }
  
  Widget boton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text(
                '\$${bloc.getPriceProductos()}',
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
                await initPaymentSheet(context, email: widget.user.email, amount: bloc.getPriceProductos() * 100.00);
              }, 
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 17, 134, 1)  ),
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

  listItems() {
    return Column(
      children: List.generate(bloc.cartItemsProductos.length, (index) {
        var _contador = int.parse(bloc.cartItemsProductos[index].cantidad);
        var _resultadoN = double.parse(bloc.cartItemsProductos[index].precio);
        var _costoN = double.parse(bloc.cartItemsProductos[index].costoTotal);
        double total;
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.network(bloc.cartItemsProductos[index].urlImage)
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              bloc.cartItemsProductos[index].descripcion,
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '\$ ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 17, 134, 1)  ,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  bloc.cartItemsProductos[index].precio,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(0, 17, 134, 1)  ,
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
                                          bloc.removeFromCartProductos(bloc.cartItemsProductos[index]);
                                          Navigator.pop(context);
                                        },
                                        Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              '¿Estas seguro de eliminar ${bloc.cartItemsProductos[index].descripcion} del carrito?',
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
                                      setState(() => bloc.cartItemsProductos[index].cantidad = _contador.toString());
                                      setState(() => bloc.cartItemsProductos[index].costoTotal = total.toString());
                                      bloc.updateToCartProductos(bloc.cartItemsProductos[index]);
                                    }
                                  },
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(0, 17, 134, 1)  ,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                    child: Text(
                                      bloc.cartItemsProductos[index].cantidad,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Nuber Next Regular'
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
                                        setState(() => bloc.cartItemsProductos[index].cantidad = _contador.toString());
                                        setState(() => bloc.cartItemsProductos[index].costoTotal = total.toString());
                                        bloc.updateToCartProductos(bloc.cartItemsProductos[index]);
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        );
      })
    );
  }
  



}