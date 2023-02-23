import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/evento.dart';
import 'package:santiago4x4pro/models/intinerario.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/widget/clipper/dolDurmaClipper.dart';
import 'carrito_eventos.dart';

class CompraEvento extends StatefulWidget {
  final UserModel user;
  final Evento evento;
  final UserRepository userRepository;
  const CompraEvento({Key? key, required this.user, required this.evento, required this.userRepository}) : super(key: key);

  @override
  _CompraEventoState createState() => _CompraEventoState();
}

class _CompraEventoState extends State<CompraEvento> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var array = [];

  int contador = 0;

  Itinerario? itinerarioCarrito;
  Itinerario? itinerario;
  Itinerario? itinerarioUpdate;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.getStream,
      builder: (context, snapshot) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Entradas', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: widget.user.socio == "0" ? _noSocio() : _socio(),
          bottomNavigationBar: bloc.counter() == 0 ? const SizedBox() : BottomAppBar(
            child: SizedBox(
              height: 48.0, 
              child: _buildBottom()
            )
          )
        );
      }
    );
  }

  Widget _noSocio() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection('costos').where('socio', isEqualTo: '0').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 5.0),
              Flexible(
                child: ListView(
                  children: _cardForm(snapshot.data!.docs),
                ),
              ),
              const SizedBox(height: 3.0),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _socio() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('eventos').doc(widget.evento.uid).collection('costos').where('socio', isEqualTo: '1').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              const SizedBox(height: 5.0),
              Flexible(
                child: ListView(
                  children: _cardForm(snapshot.data!.docs),
                ),
              ),
              const SizedBox(height: 3.0),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _cardForm(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
    for (var document in doc) {
      items.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: DolDurmaClipper(right: MediaQuery.of(context).size.width * 0.7, holeRadius: 40),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 17, 134, 1)  ,
                    image: DecorationImage(
                      image: AssetImage('assets/llanta.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                document.get('costo').toString(),
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                ' MXN',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(192,192,192,1)
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 250,
                                alignment: Alignment.center,
                                child: Text(
                                  document.get('descripcion').toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 95,
                            height: 35,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 17, 134, 1)  ,),
                                side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                    color: Colors.white
                                  ),
                                )
                              ),
                              onPressed: () {
                                if(bloc.cartItems.isNotEmpty) {           
                                  for (var element in bloc.cartItems) {
                                    if(element.descripcion == document.get('descripcion')) {
                                      itinerarioUpdate = Itinerario(
                                        descripcion: element.descripcion,
                                        precio: element.precio.toString(),
                                        cantidad: element.cantidad,
                                        uid: element.uid,
                                        costoTotal: element.costoTotal
                                      );
                                    } else {
                                      itinerario = Itinerario(
                                        descripcion: document.get('descripcion'),
                                        precio: document.get('costo').toString(),
                                        uid: document.id, 
                                        cantidad: '', 
                                        costoTotal: '',
                                      );
                                    }
                                  }
                                } else {
                                  itinerario = Itinerario(
                                    descripcion: document.get('descripcion'),
                                    precio: document.get('costo').toString(),
                                    uid: document.id,
                                    cantidad: '',
                                    costoTotal: ''
                                  );
                                }
                              
                                if(itinerarioUpdate == null) {
                                  _settingModalBottomSheet(context, itinerario!, 1, double.parse(itinerario!.precio.toString()));
                                } else {
                                  _settingModalBottomSheet(context, itinerarioUpdate!, int.parse(itinerarioUpdate!.cantidad), double.parse(itinerarioUpdate!.costoTotal.toString()));
                                }
                              },
                              child: const Center(
                                child: Text(
                                  'Agregar', 
                                  style: TextStyle(
                                    color: Colors.white,
                                  )
                                )
                              ),
                            ), 
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ])
      );
    }
    return items;
  }

  Widget _buildBottom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(width: 3.0),
          SizedBox(
            width:  MediaQuery.of(context).size.width * 0.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Cantidad",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${bloc.counter()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            color: const Color.fromRGBO(209, 65, 12, 1),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Carrito(user: widget.user, evento: widget.evento, userRepository: widget.userRepository,))); 
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 17, 134, 1)  ,),
              ),
              child: const Center(
                child: Text(
                  "Ver Carrito",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _settingModalBottomSheet(context, Itinerario producto, int contador, double costo) {
    double _counterTotal = double.parse(producto.precio.toString());
    int _counter = contador;
    double result = costo;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc,) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async {
                setState(() {
                  itinerario = null;
                  itinerarioUpdate = null;
                  Navigator.pop(context);
                });
                return true;
              },
              child: SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(  
                      padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Text(
                        producto.descripcion,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        'Precio: \$ ${result.toString()}',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              size: 28,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                if(_counter == 1) {
                                  _counter = 1;
                                  return;
                                }
                                else {
                                  _counter--;
                                }
                                result =  result - _counterTotal;
                              });
                            },
                          ),
                          Text(
                            _counter.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 28,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _counter++;
                                result = _counterTotal * _counter;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                itinerarioCarrito = Itinerario(
                                  cantidad: _counter.toString(),
                                  descripcion: producto.descripcion,
                                  precio: producto.precio,
                                  uid: producto.uid,
                                  costoTotal: result.toString()
                                );
                                if(itinerarioUpdate == null) {
                                  bloc.addToCart(itinerarioCarrito!);
                                } else {
                                  bloc.updateToCart(itinerarioCarrito!);
                                }
                                Navigator.pop(context);
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 17, 134, 1)  ,),
                            ), 
                            child: const Center(
                              child: Text(
                                'Agregar al carrito',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ]
                )
              ),
            );
          }
        );
      }
    );
  }
 
}