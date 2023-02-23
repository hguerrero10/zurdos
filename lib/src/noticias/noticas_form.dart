import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Noticias extends StatefulWidget {
  const Noticias({Key? key}) : super(key: key);

  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('publications').snapshots(),
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
                  children: _publicacion(snapshot.data!.docs),
                ),  
              ),
            ],
          ) : _noNoticias();
        } 
        else {
          const SizedBox();
        }
        return const Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }


  List<Widget> _publicacion(List<DocumentSnapshot> doc) {
    List<Widget> items = [];

    for (var document in doc) {
      items.add(  
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Column(
            children: <Widget>[
              ListTile(
                leading:  Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage (
                      fit: BoxFit.fill,
                      image: AssetImage('assets/perfil.jpg')
                    )
                  )    
                ),
                title: const Text(
                  'Pista Santiago 4x4 Pro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
                subtitle: Text(
                  document.get('date').toString()
                ),
              ),
              ListTile(
                title: Text(
                  document.get('descripcion').toString(),
                  style: const TextStyle(   
                    fontSize: 15
                  ),
                ),
              ),
              Card(
                child: FadeInImage.assetNetwork(
                placeholder: 'assets/loadPublications.gif', 
                  image: document.get('urlImage').toString(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: const Text(
                      "Facebook",
                      style: TextStyle(
                        color: Color.fromRGBO(59, 89, 152, 1),
                        fontSize: 15
                      ) 
                    ),
                    onPressed: () {
                      _launchURL(document.get('publicationLink').toString());
                    },
                  ),  
                ],
              )
            ],
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

  Widget _noNoticias() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.news,
            color: Colors.grey[400],
            size: 120,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'No hay noticias',
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