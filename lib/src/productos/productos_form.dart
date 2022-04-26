import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/producto.dart';
import 'package:santiago4x4pro/src/productos/producto_detalle_form.dart';
import 'package:url_launcher/url_launcher.dart';

class Productos extends StatefulWidget {
  
  const Productos({Key? key}) : super(key: key);

  @override
  _ProductosState createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {

  late Producto producto;
  late Producto productoCarrito;
  late Producto productoUpdate;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('productos').snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          documents.clear();
          documents.addAll(snapshot.data!.docs);
          return Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 180,
                child: GestureDetector(
                  child: Image.asset(
                    'assets/logo_tienda_offroad.png'
                  ),
                  onTap: ()=> _launchURL('https://www.tiendaoffroad.com/'),
                )
              ),
              const SizedBox(height: 15),
              snapshot.data!.docs.isNotEmpty ? Flexible(
                child: ListView(
                  children: _producto(snapshot.data!.docs),
                ),
              ) : Column(
                children: [
                  const SizedBox(height: 120),
                  _noProductos(),
                ],
              ),
            ],
          );
        } 
        else {
          const SizedBox();
        }
        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  List<Widget> _producto(List<DocumentSnapshot> doc) {
    List<Widget> items = [];
    for (var document in doc) {
      items.add(  
        GestureDetector(
          onTap: () {
            producto = Producto(
              uid: document.id.toString(),
              producto: document.get('producto').toString(), 
              talla: document.get('talla').toString(), 
              descripcion: document.get('descripcion').toString(), 
              precio: document.get('precio').toString(),
              urlImage: document.get('urlImage').toString(),
              categoria: document.get('categoria').toString(),
            );
            Navigator.push(context,  MaterialPageRoute(builder: (context) => DetalleProducto(product: producto, user: bloc.userBloc)));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    document.get('producto').toString(), 
                  ),
                  subtitle: Text(document.get('talla').toString()),
                ),
                FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif', 
                  image: document.get('urlImage').toString(),
                  height: 150,
                  width: 150,
                  fit: BoxFit.fill,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        '\$ ' + document.get('precio').toString(),
                        style: const TextStyle(
                          color: Color.fromRGBO(44, 197, 94, 1),
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    TextButton(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          'Ver mas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(44, 197, 94, 1),
                          )
                        ),  
                      ),
                      onPressed: () {
                        producto = Producto(
                          uid: document.id.toString(),
                          producto: document.get('producto').toString(), 
                          talla: document.get('talla').toString(), 
                          descripcion: document.get('descripcion').toString(), 
                          precio: document.get('precio').toString(),
                          urlImage: document.get('urlImage').toString(),
                          categoria: document.get('categoria').toString(),
                        );
                        Navigator.push(context,  MaterialPageRoute(builder: (context) => DetalleProducto(product: producto, user: bloc.userBloc)));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      );
    }
    return items;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _noProductos() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.cart,
            color: Colors.grey[400],
            size: 120,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'No hay mercancía disponible',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nuber Next Regular',
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