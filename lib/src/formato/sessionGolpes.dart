import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:santiago4x4pro/models/formatocfosc01.dart';
import 'package:santiago4x4pro/models/respuesta_utility_model.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/home/home_form.dart';
import 'package:santiago4x4pro/widget/toast.dart';

class SessionGolpes extends StatefulWidget {

  final UserModel user; 
  final UserRepository userRepository;

  final int folio;
  final int id;

  const SessionGolpes({ Key? key, required this.user, required this.userRepository, required this.folio, required this.id }) : super(key: key);

  @override
  State<SessionGolpes> createState() => _SessionGolpesState();
}

class _SessionGolpesState extends State<SessionGolpes> {

  String urlUpdateGolpes = 'https://zurdosapi.tlk.com.mx/upGolpesPart1';
  String urlUpdateGolpes2 = 'https://zurdosapi.tlk.com.mx/upGolpesPart2';
  String urlUpdateGolpes3 = 'https://zurdosapi.tlk.com.mx/upGolpesPart3';
  String urlGetLID = 'https://zurdosapi.tlk.com.mx/getLastID'; 



  List images1 = [];

  String? urlFoto1;

  File? foto1; 
  bool? validateFoto1;
  String? base64Foto1;

  final pickerFoto1 = ImagePicker();

  List<Asset> imagesFoto1 = <Asset>[];

  List images2 = [];

  String? urlFoto2;

  File? foto2; 
  bool? validateFoto2;
  String? base64Foto2;

  final pickerFoto2 = ImagePicker();

  List<Asset> imagesFoto2 = <Asset>[];

  List images3 = [];

  String? urlFoto3;

  File? foto3; 
  bool? validateFoto3;
  String? base64Foto3;

  final pickerFoto3 = ImagePicker();

  List<Asset> imagesFoto3 = <Asset>[];

  List images4 = [];

  String? urlFoto4;

  File? foto4;   
  bool? validateFoto4;
  String? base64Foto4;

  final pickerFoto4 = ImagePicker();

  List<Asset> imagesFoto4 = <Asset>[];

  List images5 = [];

  String? urlFoto5;

  File? foto5;   
  bool? validateFoto5;
  String? base64Foto5;

  final pickerFoto5 = ImagePicker();

  List<Asset> imagesFoto5 = <Asset>[];

  List images6 = [];

  String? urlFoto6;

  File? foto6;   
  bool? validateFoto6;
  String? base64Foto6;

  final pickerFoto6 = ImagePicker();

  List<Asset> imagesFoto6 = <Asset>[];

  List images7 = [];

  String? urlFoto7;

  File? foto7;   
  bool? validateFoto7;
  String? base64Foto7;

  final pickerFoto7= ImagePicker();

  List<Asset> imagesFoto7= <Asset>[];

  List images8 = [];

  String? urlFoto8;

  File? foto8;   
  bool? validateFoto8;
  String? base64Foto8;

  final pickerFoto8= ImagePicker();

  List<Asset> imagesFoto8= <Asset>[];


  List images9 = [];

  String? urlFoto9;

  File? foto9;   
  bool? validateFoto9;
  String? base64Foto9;

  final pickerFoto9= ImagePicker();

  List<Asset> imagesFoto9= <Asset>[];

  List images10 = [];

  String? urlFoto10;

  File? foto10;   
  bool? validateFoto10;
  String? base64Foto10;

  final pickerFoto10= ImagePicker();

  List<Asset> imagesFoto10= <Asset>[];


  @override
  void initState() { 
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
      appBar: AppBar(
        title: Text('Fotografias'),
        backgroundColor: Color(0xfb234798),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Parte 1'),
              Tab(text: 'Parte 2'),
              Tab(text: 'Parte 3'),
            ],
          ),
        ),
       body: TabBarView(
          children: [
            SingleChildScrollView(child: parte1()),
            SingleChildScrollView(child: parte2()),
            SingleChildScrollView(child: parte3()),
          ],
        )
      )
    );
  }


  Future<http.Response> updateFormatoApi({required FormatoModel formatoModel}) async {
    // return await http.post(Uri.parse('$urlUpdateFotos/${widget.recepcionModel.idrecepcion}'), body: formatoModel.toJson());
    return await http.put(Uri.parse('$urlUpdateGolpes/${widget.id}'), body: formatoModel.toJson());
  }

  Future<RespuestaUtilityModel> updateFoto() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      FormatoModel formatoModel = FormatoModel();

      await uploadImageFoto1(imagesFoto1);
      await uploadImageFoto2(imagesFoto2);
      await uploadImageFoto3(imagesFoto3);

      formatoModel.folio = widget.folio.toString();
      formatoModel.foto1 = urlFoto1!;
      formatoModel.foto2 = urlFoto2!;
      formatoModel.foto3 = urlFoto3!;

      await updateFormatoApi(formatoModel: formatoModel).then((http.Response response) {
        print(response.statusCode);
        print(response.body);
        
        if(response.statusCode != 200) {
          throw 'Error';
        }
        
        print(response.statusCode);
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }


  Future<http.Response> updateFormatoApi2({required FormatoModel formatoModel}) async {
    // return await http.post(Uri.parse('$urlUpdateFotos/${widget.recepcionModel.idrecepcion}'), body: formatoModel.toJson());
    return await http.put(Uri.parse('$urlUpdateGolpes2/${widget.id}'), body: formatoModel.toJson());
  }

  Future<RespuestaUtilityModel> updateFoto2() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      FormatoModel formatoModel = FormatoModel();

      await uploadImageFoto4(imagesFoto4);
      await uploadImageFoto5(imagesFoto5);
      await uploadImageFoto6(imagesFoto6);

     

      formatoModel.folio = widget.folio.toString();
      formatoModel.foto4 = urlFoto4!;
      formatoModel.foto5 = urlFoto5!;
      formatoModel.foto6 = urlFoto6!;

      await updateFormatoApi2(formatoModel: formatoModel).then((http.Response response) {
        print(response.statusCode);
        print(response.body);
        
        if(response.statusCode != 200) {
          throw 'Error';
        }
        
        print(response.statusCode);
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }

  Future<http.Response> updateFormatoApi3({required FormatoModel formatoModel}) async {
    // return await http.post(Uri.parse('$urlUpdateFotos/${widget.recepcionModel.idrecepcion}'), body: formatoModel.toJson());
    return await http.put(Uri.parse('$urlUpdateGolpes3/${widget.id}'), body: formatoModel.toJson());
  }

  Future<RespuestaUtilityModel> updateFoto3() async {
    RespuestaUtilityModel respuestaUtilityModel = RespuestaUtilityModel();
    try{

      FormatoModel formatoModel = FormatoModel();

      await uploadImageFoto7(imagesFoto7);
      await uploadImageFoto8(imagesFoto8);
      await uploadImageFoto9(imagesFoto9);
      await uploadImageFoto10(imagesFoto10);

     

      formatoModel.folio = widget.folio.toString();
      formatoModel.foto7 = urlFoto7!;
      formatoModel.foto8 = urlFoto8!;
      formatoModel.foto9 = urlFoto9!;
      formatoModel.foto10 = urlFoto10!;

      await updateFormatoApi3(formatoModel: formatoModel).then((http.Response response) {
        print(response.statusCode);
        print(response.body);
        
        if(response.statusCode != 200) {
          throw 'Error';
        }
        
        print(response.statusCode);
      }).catchError((error) {
        throw error;
      });
    } catch (error) {
      respuestaUtilityModel.error = true;
      respuestaUtilityModel.mensaje = error.toString();
    }
    return respuestaUtilityModel;
  }












  Widget nameButton(String name,double wi, double he, ico) {
    return Container(
      width: wi,
      height: he,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xfbb0afb5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ico, color: Colors.white),
          SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white
            ),
          ),
        ],
      )
    );
  }

  Widget nameButton2(String name,double wi, double he, ico) {
    return Container(
      width: wi,
      height: he,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xfb234798)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ico, color: Colors.white),
          SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white
            ),
          ),
        ],
      )
    );
  }


  Widget parte1() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: 20),

          Text(widget.folio.toString()),
          Text(widget.id.toString()),

          GestureDetector(
            onTap: () async {
              loadFoto1();
                  
            },
            child: nameButton('Foto 1', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto2();
            },
            child: nameButton('Foto 2', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto3();
            },
            child: nameButton('Foto 3', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 40),



          GestureDetector(
            onTap: () async {
              RespuestaUtilityModel respuestaUtilityModel = await updateFoto();
              if(!respuestaUtilityModel.error) {
                // Navigator.pop(context);
                 toast('Fotos enviadas');
              } else {
                toast(respuestaUtilityModel.mensaje);
              }
            },
            child: nameButton2('Subir fotos', 250, 80, Icons.send_outlined)
          ),

        ],
      ),
    );
  }
  
  Widget parte2() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto4();
            },
            child: nameButton('Foto 4', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto5();
            },
            child: nameButton('Foto 5', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto6();
            },
            child: nameButton('Foto 6', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 40),



          GestureDetector(
            onTap: () async {
              RespuestaUtilityModel respuestaUtilityModel = await updateFoto2();
              if(!respuestaUtilityModel.error) {
                // Navigator.pop(context);
                toast('Fotos enviadas');
              } else {
                toast(respuestaUtilityModel.mensaje);
              }
            },
            child: nameButton2('Subir fotos', 250, 80, Icons.send_outlined)
          ),

          
        ],
      ),
    );
  }

  Widget parte3() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          
          
          GestureDetector(
            onTap: () async {
              loadFoto7();
            },
            child: nameButton('Foto 7', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto8();
            },
            child: nameButton('Foto 8', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto9();
            },
            child: nameButton('Foto 9', 220, 100, Icons.camera_alt)
          ),
          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              loadFoto10();
            },
            child: nameButton('Foto 10', 220, 100, Icons.camera_alt)
          ),

          SizedBox(height: 40),



          GestureDetector(
            onTap: () async {
              RespuestaUtilityModel respuestaUtilityModel = await updateFoto3();
              if(!respuestaUtilityModel.error) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeForm(userRepository: widget.userRepository, user: widget.user)), (route) => false);
                toast('Fotos enviadas');
              } else {
                toast(respuestaUtilityModel.mensaje);
              }
            },
            child: nameButton2('Subir fotos', 250, 80, Icons.send_outlined)
          ),

          
        ],
      ),
    );
  }


  Future<void> loadFoto1() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto1,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto1 = [];
      imagesFoto1 = resultList;
      if(imagesFoto1.isNotEmpty) {
        validateFoto1 = true;
      } else {
        validateFoto1 = false;
      }
    });
  }

  Future<void> uploadImageFoto1(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images1.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images1.length; i++) {
        if (i == 0) {
          urlFoto1 = images1[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto2() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto2,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto2 = [];
      imagesFoto2 = resultList;
      if(imagesFoto2.isNotEmpty) {
        validateFoto2 = true;
      } else {
        validateFoto2 = false;
      }
    });
  }

  Future<void> uploadImageFoto2(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images2.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images2.length; i++) {
        if (i == 0) {
          urlFoto2 = images2[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto3() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto3,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto3 = [];
      imagesFoto3 = resultList;
      if(imagesFoto3.isNotEmpty) {
        validateFoto3 = true;
      } else {
        validateFoto3 = false;
      }
    });
  }

  Future<void> uploadImageFoto3(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images3.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images3.length; i++) {
        if (i == 0) {
          urlFoto3 = images3[0].toString();
        }
      }
    });
  }





  Future<void> loadFoto4() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto4,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto4 = [];
      imagesFoto4 = resultList;
      if(imagesFoto4.isNotEmpty) {
        validateFoto4 = true;
      } else {
        validateFoto4 = false;
      }
    });
  }

  Future<void> uploadImageFoto4(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images4.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images4.length; i++) {
        if (i == 0) {
          urlFoto4 = images4[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto5() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto5,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto5 = [];
      imagesFoto5 = resultList;
      if(imagesFoto5.isNotEmpty) {
        validateFoto5 = true;
      } else {
        validateFoto5 = false;
      }
    });
  }

  Future<void> uploadImageFoto5(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images5.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images5.length; i++) {
        if (i == 0) {
          urlFoto5 = images5[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto6() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto6,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto6 = [];
      imagesFoto6 = resultList;
      if(imagesFoto6.isNotEmpty) {
        validateFoto6 = true;
      } else {
        validateFoto6 = false;
      }
    });
  }

  Future<void> uploadImageFoto6(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images6.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images6.length; i++) {
        if (i == 0) {
          urlFoto6 = images6[0].toString();
        }
      }
    });
  }





  Future<void> loadFoto7() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto7,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto7 = [];
      imagesFoto7 = resultList;
      if(imagesFoto7.isNotEmpty) {
        validateFoto7 = true;
      } else {
        validateFoto7 = false;
      }
    });
  }

  Future<void> uploadImageFoto7(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images7.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images7.length; i++) {
        if (i == 0) {
          urlFoto7 = images7[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto8() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto8,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto8 = [];
      imagesFoto8 = resultList;
      if(imagesFoto8.isNotEmpty) {
        validateFoto8 = true;
      } else {
        validateFoto8 = false;
      }
    });
  }

  Future<void> uploadImageFoto8(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images8.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images8.length; i++) {
        if (i == 0) {
          urlFoto8 = images8[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto9() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto9,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto9 = [];
      imagesFoto9 = resultList;
      if(imagesFoto9.isNotEmpty) {
        validateFoto9 = true;
      } else {
        validateFoto9 = false;
      }
    });
  }

  Future<void> uploadImageFoto9(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images9.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images9.length; i++) {
        if (i == 0) {
          urlFoto9 = images9[0].toString();
        }
      }
    });
  }

  Future<void> loadFoto10() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: imagesFoto10,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#234798",
          actionBarTitle: "Fotos",
          allViewTitle: "Todas las fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      imagesFoto10 = [];
      imagesFoto10 = resultList;
      if(imagesFoto10.isNotEmpty) {
        validateFoto10 = true;
      } else {
        validateFoto10 = false;
      }
    });
  }

  Future<void> uploadImageFoto10(List<Asset> assets) async {
    for (var image in assets) {
      ByteData byteData = await image.requestOriginal(quality: 25);
      List<int> imagenes = byteData.buffer.asUint8List();
      images10.add(base64Encode(imagenes));
    }
    setState(() {
      for (var i = 0; i < images10.length; i++) {
        if (i == 0) {
          urlFoto10 = images10[0].toString();
        }
      }
    });
  }


}