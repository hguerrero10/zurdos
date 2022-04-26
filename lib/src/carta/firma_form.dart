import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class FirmaForm extends StatefulWidget {
  const FirmaForm({ Key? key }) : super(key: key);

  @override
  _FirmaFormState createState() => _FirmaFormState();
}

class _FirmaFormState extends State<FirmaForm> {
  
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 59, 70, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(44, 59, 70, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.delete_solid), 
            onPressed: () {
              _signaturePadKey.currentState!.clear();
              setState(() {
                bloc.firma = null;
              });
            }
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.check_mark_circled_solid), 
            onPressed: () async {
              await crearImagen();
              Navigator.pop(context);
            }
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 1.1,
            child: SfSignaturePad(
              key: _signaturePadKey,
              strokeColor: Colors.white,
              minimumStrokeWidth: 2.0,
              maximumStrokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  crearImagen() async {
    ui.Image data = await _signaturePadKey.currentState!.toImage(pixelRatio: 2.0);
    final byteData = await data.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = byteData!.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    bloc.firma = base64Encode(imageBytes);
  }
}