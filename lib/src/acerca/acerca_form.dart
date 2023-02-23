import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Acerca extends StatelessWidget {
  const Acerca({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: const Color.fromRGBO(0, 17, 134, 1)  ,
            height: 350,
            child: Center(
              child: inicio()
            )
          ),
          const Divider(),
          _botonesContacto(),
          const Divider(),
          contacto(),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Santiago 4x4 Pro es una pista de juego y practicas donde todos los aficionados al 4x4 y off road pueden asistir y divertirse todos los fines de semana.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17, 
              )
            ) 
          ),
          const SizedBox(
            height: 30
          )
        ],
      )
    );
  }
}

Widget contacto() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
     _tel(),
     _email(),  
    ],
  );
}

Widget _tel() {
  return Row(
    children: <Widget>[
      TextButton(
        child: const Icon(
          CupertinoIcons.phone,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {},
      ),
      const Text(
        "81 1690 7747", 
        style: TextStyle(
          fontSize: 17, 
        )
      )
    ],
  );
}

Widget _email() {
  return Row(
    children: <Widget>[
      TextButton(
        child: const Icon(
          CupertinoIcons.mail,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {},
      ),
      const Text(
        "pista.santiago4x4@gmail.com", 
        style: TextStyle(
          fontSize: 17, 
        )
      )
    ],
  );
}

Widget inicio() {
  return Column(
    children: <Widget>[
     const SizedBox(height: 30),
     _logo(),
     const SizedBox(height: 30),
     _texto(),
    ],
  );
}

Widget _logo() {
  return Image.asset(
    "assets/acerca.png",
    width: 163,  
  );
}

Widget _texto(){
  return Column(
    children: const [
      Text(
        "El objetivo de de la pista es capacitar a los aficionados principiantes para que puedan realizar rutas y recorridos de manera segura y ordenada, sin arriesgar a sus familias.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Todo es mejor en familia, puedes venir con tus papás, hijos, esposa/o, amigos, etc. Diversos escenarios para practicar Offroad, miércoles, sábado y domingo estamos para tí.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic
        ),
      ),
    ]
  );
}

Widget _botonesContacto() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _telefono(),
      _correo(),
      _whatsapp(),
      _info(),     
    ],
  );
}

Widget _telefono() {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  return Column(
    children: <Widget>[
      TextButton(
        child: Image.asset('assets/instagram.png', width: 35, height: 35,),
        onPressed: ()=> _makePhoneCall("https://www.instagram.com/santiago4x4pro/"),
      ),
      const Text(
        "Instagram", 
      )
    ],
  );
}

Widget _correo() {
  void _makeEmail(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  return Column(
    children: <Widget>[
      TextButton(
        child: Image.asset('assets/facebook.png', width: 35, height: 35,),
        onPressed: ()=> _makeEmail('https://www.facebook.com/Santiago4x4Pro/'),
      ),
      const Text("Facebook")
    ],
  );
}

void whatsAppOpen(String phone, String msg) async {
  final link = WhatsAppUnilink(
    phoneNumber: phone,
    text: msg,
  );
  await launch('$link');
}

Widget _whatsapp() {
  return Column(
    children: <Widget>[
      TextButton(
        child: Image.asset(
          "assets/whatsapp.png", 
          height: 35, 
          width: 35
        ),
        onPressed: ()=> whatsAppOpen('528116907747', '')
      ),
      const Text(
        "WhatsApp", 
      )
    ],
  );
}

Widget _info() {
    void _makeEmail(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
  return Column(
    children: <Widget>[
      TextButton(
        child: Image.asset('assets/youtube.png', width: 40, height: 40,),
        onPressed: () => _makeEmail('https://www.youtube.com/channel/UCeRCYrXW2wTS738aPc5NlfQ'),
      ),
      const Text(
        "Youtube", 
      )
    ],
  );
}