import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/models/user_model.dart';

class ComprasForm extends StatefulWidget {
  
  final UserModel user;
  const ComprasForm({Key? key, required this.user}) : super(key: key);

  @override
  _ComprasFormState createState() => _ComprasFormState();
}

class _ComprasFormState extends State<ComprasForm> {

  List<DocumentSnapshot> documents = [];
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('compras').where('uidUser', isEqualTo: widget.user.uid).snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          documents.clear();
          documents.addAll(snapshot.data!.docs);
          return snapshot.data!.docs.isNotEmpty ?
          Column(
            children: [
              Flexible(
                child: ListView(
                  children:  _producto(snapshot.data!.docs)
                ),
              ) 
            ],
          ) 
          : _nocompras();      
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
          },
          child: SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width * 1.2,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Image.network(
                            document.get('urlImage'), 
                            fit: BoxFit.cover,
                            height: 90,
                            width: 130,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(document.get('producto').toString(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 15))),
                                const SizedBox(height: 10),
                                Text('\$' + document.get('total').toString() + ' MXN', style: const TextStyle(fontSize: 15)),
                                const SizedBox(height: 5),
                                Text(document.get('fecha').toString(), style: const TextStyle(fontSize: 15))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
                )
              )
            ),
          ),
        )
      );
    }
    return items;
  }

  Widget _nocompras() {
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
              'No haz realizado compras',
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