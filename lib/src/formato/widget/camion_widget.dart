import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santiago4x4pro/src/formato/bloc/formato_bloc.dart';

class CamionWidget extends StatefulWidget {
  const CamionWidget({ Key? key }) : super(key: key);

  @override
  State<CamionWidget> createState() => _CamionWidgetState();
}

class _CamionWidgetState extends State<CamionWidget> {

  String? selectUno;
  String? selectDos;
  String? selectTres;
  String? selectCuatro;
  String? selectCinco;
  String? selectSeis;
  String? selectSiete;
  String? selectOcho;
  String? selectNueve;
  String? selectDiez;
  String? selectOnce;
  String? selectDoce;
  String? selectTrece;
  String? selectCatorce;
  String? selectQuince;
  String? selectDieciseis;

  TextEditingController uno = TextEditingController();
  TextEditingController dos = TextEditingController();
  TextEditingController tres = TextEditingController();
  TextEditingController cuatro = TextEditingController();
  TextEditingController cinco = TextEditingController();
  TextEditingController seis = TextEditingController();
  TextEditingController siete = TextEditingController();
  TextEditingController ocho = TextEditingController();
  TextEditingController nueve = TextEditingController();
  TextEditingController diez = TextEditingController();
  TextEditingController once = TextEditingController();
  TextEditingController doce = TextEditingController();
  TextEditingController trece = TextEditingController();
  TextEditingController catorce = TextEditingController();
  TextEditingController quince = TextEditingController();
  TextEditingController dieciseis = TextEditingController();

  final String _opcionSeleccionadaUno = 'Si';
  final List<String> _uno = [
    "Si",
    "No",
  ];

  List<DropdownMenuItem<String>> getDropDownMenuItemsFormato() {
    List<DropdownMenuItem<String>> items = [];

    for (var value in _uno) {
      items.add(DropdownMenuItem(value: value, child: Text(value)));
    }
    return items;
  }

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 17, 134, 1),
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          
          formatoBloc.opcion1Add(selectUno);
          formatoBloc.opcion2Add(selectDos);
          formatoBloc.opcion3Add(selectTres);
          formatoBloc.opcion4Add(selectCuatro);
          formatoBloc.opcion5Add(selectCinco);
          formatoBloc.opcion5Add(selectSeis);
          formatoBloc.opcion5Add(selectSiete);
          formatoBloc.opcion5Add(selectOcho);
          formatoBloc.opcion5Add(selectNueve);
          formatoBloc.opcion5Add(selectDiez);
          formatoBloc.opcion5Add(selectOnce);
          formatoBloc.opcion5Add(selectDoce);
          formatoBloc.opcion5Add(selectTrece);
          formatoBloc.opcion5Add(selectCatorce);
          formatoBloc.opcion5Add(selectQuince);
          formatoBloc.opcion5Add(selectDieciseis);

          formatoBloc.comentario1Add(uno.text);
          formatoBloc.comentario2Add(dos.text);
          formatoBloc.comentario3Add(tres.text);
          formatoBloc.comentario4Add(cuatro.text);
          formatoBloc.comentario5Add(cinco.text);
          formatoBloc.comentario5Add(seis.text);
          formatoBloc.comentario5Add(siete.text);
          formatoBloc.comentario5Add(ocho.text);
          formatoBloc.comentario5Add(nueve.text);
          formatoBloc.comentario5Add(diez.text);
          formatoBloc.comentario5Add(once.text);
          formatoBloc.comentario5Add(doce.text);
          formatoBloc.comentario5Add(trece.text);
          formatoBloc.comentario5Add(catorce.text);
          formatoBloc.comentario5Add(quince.text);
          formatoBloc.comentario5Add(dieciseis.text);

          Navigator.pop(context);
        }
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/tractoreferencia.png'),
            fit: BoxFit.cover
          )
        ),
        child: Stack(
          children: [
            _boton(300, 18, '1', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('1.- DEFENSA, LUCES, COFRE, POLVERAS.'),
                    _crearDropDownUno(),
                    _input(uno),
                  ],
                )
              );
            }),
            _boton(101, 25, '2', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('2.- MOTOR: RADIADOR,CARTER,MANGUERAS,  FILTRO DE AIRE.'),
                    _crearDropDownDos(),
                    _input(dos),
                  ],
                )
              );
            }),
            _boton(96, 85, '3', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('3.- PISO DE CABINA, PUERTAS, MARCO DE PUERTAS, BASE DE ASIENTOS.'),
                    _crearDropDowntres(),
                    _input(tres),
                  ],
                )
              );
            }),
            _boton(295, 123, '4', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('4.- TANQUE DE DIESEL, CLARO DE LUZ DEBAJO DE CABINA.'),
                    _crearDropDownCuatro(),
                    _input(cuatro),
                  ],
                )
              );
            }),
            _boton(321, 70, '5', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('5.- LLANTAS DE TRACTOR Y CAJA-CONTENEDOR.'),
                    _crearDropDowncinco(),
                    _input(cinco),
                  ],
                )
              );
            }),
            _boton(290, 173, '6', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('6.- BARRA CARDAL, PIÑON DE TRASMISION Y BOTES DE FRENOS.'),
                    _crearDropDownseis(),
                    _input(seis),
                  ],
                )
              );
            }),
            _boton(80, 130, '7', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('7.- BISERAS, COMPARTIMIENTOS, CAMAROTE,COLCHON, GUANTERA.'),
                    _crearDropDownsiete(),
                    _input(siete),
                  ],
                )
              );
            }),
            _boton(255, 197, '8', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('8.- AREA DE COMPRESORES,BATERIAS Y CAJA DE HERRAMIENTAS.'),
                    _crearDropDownocho(),
                    _input(ocho),
                  ],
                )
              );
            }),
            _boton(50, 175, '9', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('9.- AREA DE DELFECTOR Y MOFLE DE ESCAPE.'),
                    _crearDropDownnueve(),
                    _input(nueve),
                  ],
                )
              );
            }),
            _boton2(66, 224, '10', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('10.- REFRIGERACION: TERMOKING,MANGUERAS Y TANQUE DE COMBUSTIBLE.'),
                    _crearDropDowndiez(),
                    _input(diez),
                  ],
                )
              );
            }),
            _boton2(278, 245, '11', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('11.- AREA DE QUINTA RUEDA Y MUELA DE QUINTA RUEDA.'),
                    _crearDropDownonce(),
                    _input(once),
                  ],
                )
              );
            }),
            _boton2(278, 418, '12', () {
            _dialog(
                Column(
                  children: [
                    _encabezadoText('12.- COSTILLAS,MANGUERAS Y BOTES DE FRENOS DE LA CAJA'),
                    _crearDropDowndoce(),
                    _input(doce),
                  ],
                )
              );
            }),
            _boton2(50, 628, '13', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('13.- SISTEMA DE CIEERE DE PUERTAS , CAIMANES Y TUERCAS, SOLDADURA EN BISAGRAS.'),
                    _crearDropDowntrece(),
                    _input(trece),
                  ],
                )
              );
            }),
            _boton2(45, 332, '14', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('14.- PARED FRONTA, PAREDES LATERALES  Y LUCES DE LA CAJA.'),
                    _crearDropDowncatorce(),
                    _input(catorce),
                  ],
                )
              );
            }),
            _boton2(45, 479, '15', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('15.- TECHO Y PISO, PRUEBA DE LUZ, LIMPIEZA DE LA CAJA.'),
                    _crearDropDownquince(),
                    _input(quince),
                  ],
                )
              );
            }),
            _boton2(272, 625, '16', () {
              _dialog(
                Column(
                  children: [
                    _encabezadoText('16.- DEFENZA, LUCES TRASERAS Y SELLOS, CONTAMINACION AGRICOLA'),
                    _crearDropDowndieciseis(),
                    _input(dieciseis),
                  ],
                )
              );
            }),
          
          
          ],
        ),
        
      ),
    );
  }

  Future _dialog(Widget widget) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 200,
            width: 350,
            child: Column(
              children: [
                widget
              ],
            ),
          ),
        );
      } 
    );
  }

  Widget _boton(double top, double left, String text, onTap) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        height: 30,
        width: 40,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black)
              )
            )
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      )
    );
  }

  Widget _boton2(double top, double left, String text, onTap) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        height: 30,
        width: 45,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black)
              )
            )
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11
            ),
          ),
        ),
      )
    );
  }

  Widget _encabezadoText(String encabezdo) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              encabezdo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 17, 134, 1),
                fontSize: 15.0
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _input(TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20.0, right: 40.0),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(0, 17, 134, 3),
            width: 0.5,
            style: BorderStyle.solid
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: controller,
              // initialValue: report?.folio,
              // onSaved: (value) => report?.description = (value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Ingresar la parte uno';
                } else {
                  return null;
                }
              },
              obscureText: false,
              textAlign: TextAlign.left,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Comentario',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearDropDownUno() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectUno,
        onChanged: (value) {
          setState(() {
            selectUno = (value);
          });
        },
      ),
    );
  }

  Widget _crearDropDownDos() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectDos,
        onChanged: (value) {
          setState(() {
            selectDos = (value);
          });
        },
      ),
    );
  }

  Widget _crearDropDowntres() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectTres,
        onChanged: (value) {
          setState(() {
            selectTres = (value);
          });
        },
      ),
    );
  }

  Widget _crearDropDownCuatro() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectCuatro,
        onChanged: (value) {
          setState(() {
            selectCuatro = (value);
          });
        },
      ),
    );
  }

  Widget _crearDropDowncinco() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectCinco,
        onChanged: (value) {
          setState(() {
            selectCinco = (value);
          });
        },
      ),
    );
  }
 
  Widget _crearDropDownseis() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectSeis,
        onChanged: (value) {
          setState(() {
            selectSeis = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDownsiete() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectSiete,
        onChanged: (value) {
          setState(() {
            selectSiete = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDownocho() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectOcho,
        onChanged: (value) {
          setState(() {
            selectOcho = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDownnueve() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectNueve,
        onChanged: (value) {
          setState(() {
            selectNueve = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDowndiez() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectDiez,
        onChanged: (value) {
          setState(() {
            selectDiez = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDownonce() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectOnce,
        onChanged: (value) {
          setState(() {
            selectOnce = (value);
          });
        },
      ),
    );
  }

  Widget _crearDropDowndoce() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectDoce,
        onChanged: (value) {
          setState(() {
            selectDoce = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDowntrece() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectTrece,
        onChanged: (value) {
          setState(() {
            selectTrece = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDowncatorce() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectCatorce,
        onChanged: (value) {
          setState(() {
            selectCatorce = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDownquince() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectQuince,
        onChanged: (value) {
          setState(() {
            selectQuince = (value);
          });
        },
      ),
    );
  }
  
  Widget _crearDropDowndieciseis() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey[200]!
          )
      ),
      child: DropdownSearch<String>(
        showSearchBox: false,
        hint: "Seleccionar...",
        mode: Mode.MENU,
        showSelectedItems: true,
        items: _uno,
        showClearButton: true,
        selectedItem: selectDieciseis,
        onChanged: (value) {
          setState(() {
            selectDieciseis = (value);
          });
        },
      ),
    );
  }
  
}