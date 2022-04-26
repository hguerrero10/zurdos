import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/participante.dart';
import 'package:santiago4x4pro/src/carta/firma_form.dart';
import 'package:santiago4x4pro/widget/toast.dart';

class CartaResponsivaForm extends StatefulWidget {
  const CartaResponsivaForm({ Key? key }) : super(key: key);

  @override
  State<CartaResponsivaForm> createState() => _CartaResponsivaFormState();
}

class _CartaResponsivaFormState extends State<CartaResponsivaForm> {

  ScrollController scrollController = ScrollController();

  Participante? _participante;

  DateFormat dateFormat = DateFormat('yyyy/MM/dd');

  TextEditingController nombreController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController coloniaController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sangreController = TextEditingController();
  TextEditingController vehiculoController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController placasController = TextEditingController();
  TextEditingController expedicionController = TextEditingController();
  TextEditingController companiaGastosMedicosController = TextEditingController();
  TextEditingController edadController = TextEditingController();


  String? talla;
  String? participante;
  String? gastosMedicos;
  List enferdadesList = [];

  List<String> items = [
    'Piloto',
    'CoPiloto',
    'Invitado'
  ];

  List<String> medicos = [
    'Si',
    'No',
  ];

  List<String> tallas = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            bloc.deleteFirma();
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'CARTA DE RESPONSABILIDAD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Clínica de Manejo 4x4',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(dateFormat.format(DateTime.now())),
                ],
              ),
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 30),
                  child: Text('Tipo de participante*', style: TextStyle(fontSize: 18),),
                )
              ],
            ),
            dropDownParticipante(),
            input(nombreController, TextInputType.text, 100, 'Nombre completo*'),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 30),
                  child: Text('Talla*', style: TextStyle(fontSize: 18),),
                )
              ],
            ),
            dropDownTalla(),
            input(edadController, TextInputType.number, 3, 'Edad*'),
            input(direccionController, TextInputType.streetAddress, 100, 'Dirección*'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input( ciudadController, TextInputType.text, 100, 'Ciudad')),
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input( estadoController, TextInputType.text, 100, 'Estado')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(cpController, TextInputType.number, 5, 'Código Postal')),
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(telefonoController, TextInputType.phone, 10, 'Telefono*')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(emailController, TextInputType.emailAddress, 100, 'Email')),
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(celularController, TextInputType.phone, 10, 'Celular')),
              ],
            ),
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 30),
                  child: Text('Gastos medicos*', style: TextStyle(fontSize: 18),),
                )
              ],
            ),
            dropDownMedico(),
            gastosMedicos == 'Si' ? input(companiaGastosMedicosController, TextInputType.text, 50, 'Compañia') : const SizedBox(),
            participante != 'Piloto' ? const SizedBox() : input(vehiculoController, TextInputType.text, 50, 'Vehículo'),
            participante != 'Piloto' ? const SizedBox() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(anoController, TextInputType.number, 4, 'Año')),
                SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: input(placasController, TextInputType.text, 7, 'Placas')),
              ],
            ),
            const SizedBox(height: 25),
            firma(),
            const SizedBox(height: 25),
            button('Continuar', () {
              guardar();

            }, MediaQuery.of(context).size.width * 0.9),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }

  Widget dropDownParticipante() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 2,
      margin: const EdgeInsets.only(left: 15, right: 15,),
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSelectedItems: true,
        items: items,
        showClearButton: true,
        dropdownSearchDecoration: const InputDecoration(
          hintText: 'Seleccionar',
        ),
        selectedItem: participante,
        onChanged: (value) {
          setState(() {
            participante = (value);
          });
        },
      ),
    );
  }

  Widget dropDownMedico() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 2,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSelectedItems: true,
        items: medicos,
        showClearButton: true,
        dropdownSearchDecoration: const InputDecoration(
          hintText: 'Seleccionar',
        ),
        selectedItem: gastosMedicos,
        onChanged: (value) {
          setState(() {
            gastosMedicos = (value);
          });
        },
      ),
    );
  }

  Widget dropDownTalla() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 2,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        showSelectedItems: true,
        items: tallas,
        showClearButton: true,
        dropdownSearchDecoration: const InputDecoration(
          hintText: 'Seleccionar',
        ),
        selectedItem: talla,
        onChanged: (value) {
          setState(() {
            talla = (value);
          });
        },
      ),
    );
  }

  Widget input(TextEditingController textEditingController, TextInputType textInputType, int maxLenght, String label) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              keyboardType: textInputType,
              maxLength: maxLenght,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                label: Text(label),
                counterText: ''
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget firma() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ElevatedButton(
            onPressed: () {
              if(bloc.firma == null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FirmaForm()));
              } else {
                toast('Firma generada');
              }
            },  
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 59, 70, 1)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Icon(bloc.firma == null ? CupertinoIcons.hand_draw : CupertinoIcons.check_mark_circled, size: 40,),
                  ),
                  Text(
                    bloc.firma == null ? 'Toca aquí para ingresar tu firma' : 'Firma generada', 
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17
                    ),
                  ),
                ],
              ),
            )
          ),
        )
      ],
    );
  }

  Widget button(String text, onPressed, double size) {
    return SizedBox(
      height: 50,
      width: size,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(44, 197, 94, 1)),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16
            ),
          )
        ),
      ),
    );
  }

  guardar()  {
    if(
      nombreController.text.trim().isNotEmpty && direccionController.text.trim().isNotEmpty && telefonoController.text.trim().isNotEmpty &&
      edadController.text.trim().isNotEmpty && talla != null && bloc.firma != null
    ) {
      if(gastosMedicos == 'Si' && companiaGastosMedicosController.text.trim().isNotEmpty) {
        setState(() {
          _participante = null;
          _participante = Participante(
            participante: participante,
            nombre: nombreController.text.trim(),
            direccion: direccionController.text.trim(),
            colonia: coloniaController.text.trim(),
            ciudad: ciudadController.text.trim(),
            estado: estadoController.text.trim(),
            cp: cpController.text.trim(),
            telefono: telefonoController.text.trim(),
            email: emailController.text.trim(),
            celular: celularController.text.trim(),
            compania: companiaGastosMedicosController.text.trim(),
            firma: bloc.firma,
            vehiculo: vehiculoController.text.trim(),
            ano: anoController.text.trim(),
            placas: placasController.text.trim(),
            medico: gastosMedicos,
            edad: edadController.text.trim()
          );
          bloc.addParticipantes(_participante!);
          toast('Participante agregado');
          scrollController.jumpTo(0);
          nombreController = TextEditingController();
          direccionController =  TextEditingController();
          coloniaController =  TextEditingController();
          ciudadController =  TextEditingController();
          estadoController =  TextEditingController();
          cpController =  TextEditingController();
          telefonoController =  TextEditingController();
          celularController =  TextEditingController();
          emailController =  TextEditingController();
          sangreController =  TextEditingController();
          vehiculoController =  TextEditingController();
          anoController =  TextEditingController();
          colorController =  TextEditingController();
          placasController =  TextEditingController();
          expedicionController =  TextEditingController();
          edadController =  TextEditingController();
          companiaGastosMedicosController =  TextEditingController();
          bloc.deleteFirma();
          participante = null;
          talla = null;
          gastosMedicos = null;
        });
      } else if(gastosMedicos == 'No') {
        setState(() {
          _participante = null;
          _participante = Participante(
            participante: participante,
            nombre: nombreController.text.trim(),
            direccion: direccionController.text.trim(),
            colonia: coloniaController.text.trim(),
            ciudad: ciudadController.text.trim(),
            estado: estadoController.text.trim(),
            cp: cpController.text.trim(),
            telefono: telefonoController.text.trim(),
            email: emailController.text.trim(),
            celular: celularController.text.trim(),
            firma: bloc.firma,
            vehiculo: vehiculoController.text.trim(),
            ano: anoController.text.trim(),
            placas: placasController.text.trim(),
            medico: gastosMedicos,
            edad: edadController.text.trim()
          );
          bloc.addParticipantes(_participante!);
          toast('Participante agregado');
          scrollController.jumpTo(0);
          nombreController = TextEditingController();
          direccionController =  TextEditingController();
          coloniaController =  TextEditingController();
          ciudadController =  TextEditingController();
          estadoController =  TextEditingController();
          cpController =  TextEditingController();
          telefonoController =  TextEditingController();
          celularController =  TextEditingController();
          emailController =  TextEditingController();
          sangreController =  TextEditingController();
          vehiculoController =  TextEditingController();
          anoController =  TextEditingController();
          colorController =  TextEditingController();
          placasController =  TextEditingController();
          expedicionController =  TextEditingController();
          edadController =  TextEditingController();
          companiaGastosMedicosController =  TextEditingController();
          bloc.deleteFirma();
          participante = null;
          talla = null;
          gastosMedicos = null;
        });
      } else {
        toast('Falta la compañia');
      }
    } else {
      toast('Faltan campos requeridos');
    }

  }

}