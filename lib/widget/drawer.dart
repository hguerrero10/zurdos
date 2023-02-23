import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/bloc/authentication_bloc/bloc.dart';
import 'package:santiago4x4pro/bloc/cart_items_bloc.dart';
import 'package:santiago4x4pro/models/user_model.dart';
import 'package:santiago4x4pro/src/compras/compras_screen.dart';
import 'package:santiago4x4pro/src/misEventos/miseventos_screen.dart';
import 'package:santiago4x4pro/src/patrocinadores/patrocinadores_screen.dart';
import 'package:santiago4x4pro/src/perfil/perfil_screen.dart';
import 'package:santiago4x4pro/src/reglamento/reglamento_screen.dart';
import 'package:url_launcher/url_launcher.dart';

  class MenuDrawer extends StatefulWidget {
    
    final UserModel user;
    const MenuDrawer({Key? key, required this.user}) : super(key: key);
  
    @override
    _MenuDrawerState createState() => _MenuDrawerState();
  }
  
  class _MenuDrawerState extends State<MenuDrawer> {

    @override
    Widget build(BuildContext context) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(
                      widget.user.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0, 
                        fontWeight: FontWeight.w500,
                      )
                    ),
                    accountName: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              widget.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22.0, 
                                fontWeight: FontWeight.w500,
                              )
                            ),
                          ),
                        ),
                        widget.user.socio != '0' ? 
                          const Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            color: Colors.amberAccent,
                        ) : const SizedBox()
                      ],
                    ),
                    decoration: const BoxDecoration( 
                      color: Color.fromRGBO(0, 17, 134, 1)     
                    ),
                  ),

                  _item(context, CupertinoIcons.home, 'Inicio', ()=> Navigator.pop(context)),
                  // _item(context, CupertinoIcons.person, 'Perfil', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> PerfilScreen(user: widget.user)))),
                  // _item(context, CupertinoIcons.tickets, 'Mis eventos', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> MisEventosScreen(user: widget.user)))),
                  // _item(context, CupertinoIcons.cart, 'Compras', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ComprasScreen(user: widget.user)))),
                  // _item(context, CupertinoIcons.star, 'Patrocinadores', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const PatrocinadoresScreen()))),
                  // _item(context, CupertinoIcons.book, 'Reglamento', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const ReglamentoScreen()))),
                  // _item(context, Icons.add, 'Productos', ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AgregarForm()))),
                  
                  // Column(
                  //   children: <Widget>[
                  //     Row(
                  //       children: const [
                  //         SizedBox(
                  //           height: 20,
                  //           width: 20
                  //         ),
                  //         Text(
                  //           'Visita nuestra tienda',
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(height: 7),
                  //     ListTile(
                  //       leading: Image.asset(
                  //         'assets/logo_tienda_offroad.png',
                  //         width: 130,
                  //       ),
                  //       title: const Text(''),
                  //       onTap: ()=> _launchURL('https://www.tiendaoffroad.com/')
                  //     ),
                  //   ],
                  // ),   

                ]
              )
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  _item(context, Icons.exit_to_app_outlined, 'Cerrar Sesión', () {
                    bloc.deleteCartEvent();
                    bloc.deletePartipantes();
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  }),
                ],
              )
            )
          ],
        )
      );
    }

    Widget _item(BuildContext context, IconData icono, String titulo, ontap) {
      return ListTile(
        leading: Icon( icono, color: Colors.black ),
        title: Text( titulo, 
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        onTap: ontap      
      );
    }

    _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }