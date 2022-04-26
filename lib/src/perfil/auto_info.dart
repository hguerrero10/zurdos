import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/models/user_model.dart';

class AutoInfo extends StatefulWidget {
  final UserModel user;
  final DocumentSnapshot documentSnapshot;
  const AutoInfo({Key? key, required this.user , required this.documentSnapshot}) : super(key: key);

  @override
  _AutoInfoState createState() => _AutoInfoState();
}

class _AutoInfoState extends State<AutoInfo> {

  late int color;

  @override
  void initState() {
    super.initState();
    color = int.parse((widget.documentSnapshot['color'].toString().replaceAll(')', ' ').replaceAll('Color(', ' ').trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif' ,
                    image: widget.documentSnapshot.get('urlImage'),
                      fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 1.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white,),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)
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
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Row(
                        children: [
                          Text(
                            widget.documentSnapshot['marca'],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 30,
                              letterSpacing: 3,
                              fontFamily: 'Nuber Next',
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Row(
                        children: [
                          Text(
                            widget.documentSnapshot['modelo'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 25,
                              letterSpacing: 3,
                              fontFamily: 'Nuber Next Regular',
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Color',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                              color: Color(color)
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(color: Colors.grey[400],)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Placa',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            widget.documentSnapshot['placa'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(color: Colors.grey[400],)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seguro',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            widget.documentSnapshot['seguro'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(color: Colors.grey[400],)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fecha subida',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            widget.documentSnapshot['createAt'],
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Nuber Next Regular',
                              color: Colors.grey[400],
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Divider(color: Colors.grey[400],)
                    )
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
  
  Widget _nombreCoche(String nombre, Color colorFondoCirculo){
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: [
          Expanded(child: Container(),),
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(50),
              border: Border.all(
                width: .5,
                color: Colors.white
              )
            ),
            child: const Image(
              image: AssetImage('assets/jeep-logo.png'),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _precio() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            children: [
              const Text("Placa", style: TextStyle(color: Colors.white),),
              Text('${widget.documentSnapshot.get('placa')}', style: const TextStyle(color: Colors.white30),)
            ],
          ),
        ),
        Expanded(child: Container()),
        Container(
          width: 200,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.only(topLeft: Radius.circular(40), bottomLeft: Radius.circular(40))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 15,),
              Icon(Icons.info_outline),
              SizedBox(width: 15,),
              Text("Informacion", style: TextStyle(fontWeight: FontWeight.w900,)),
            ],
          ),
        )
      ],
    );
  }

  Widget _caracteristicas(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _catacteristica(Icons.security_sharp, "Seguro", widget.documentSnapshot.get('seguro'),""),
        _catacteristica(Icons.color_lens_outlined, "Color", widget.documentSnapshot.get('color'),""),
      ],
    );
  }

  Widget _catacteristica(IconData icono, String descripcion, String valor, String unidad){
    return Column(
      children: <Widget>[
        Icon(icono, color: Colors.white,size: 50,),
        const SizedBox(height: 10,),
        Text(descripcion, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),),
        const SizedBox(height: 10,),
        Text(valor.toString(), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),),
        Text(unidad, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w200),),
      ],
    );

  }
}
// class CustomClipPath extends CustomClipper<Path> {
//   var radius=10.0;
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     path.lineTo(0, size.height);
//     path.quadraticBezierTo(size.width / 4, size.height - 40, size.width / 2, size.height - 20);
//     path.quadraticBezierTo(3 / 4 * size.width, size.height, size.width, size.height - 30);
//     path.lineTo(size.width, 0);

//     return path;
//   }
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }