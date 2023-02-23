import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:santiago4x4pro/models/ordenes.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/entradas/entradas.dart';
import 'package:santiago4x4pro/src/formato/formato_entrada_form.dart';
import 'package:santiago4x4pro/src/formato/formatoe_screen.dart';
import 'package:santiago4x4pro/src/formato/formatos_screen.dart';
import 'package:santiago4x4pro/src/formato/select.dart';
import 'package:santiago4x4pro/src/login/login_screen.dart';
import 'package:santiago4x4pro/src/ordenes/detalles.dart';
import 'package:santiago4x4pro/src/ordenes/ordenes.dart';
import 'package:santiago4x4pro/src/recepciones/recepcions.dart';
import 'package:santiago4x4pro/src/splash_creen.dart';
import 'bloc/authentication_bloc/bloc.dart';
import 'src/home/home_screen.dart';

Future<void> main() async {
  GestureBinding.instance?.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_live_51KXCunIi9nxf6bRR2yPBXUGtV6dvdc1Bhj6N9hOQMmFmhtjEkeVI1pCmn5eGsGxenmAUhNzfNoAuYYQRRP8Uhlpr00lrkq6hDP";
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  late UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
    create: (context) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
    child: MyApp(userRepository: userRepository),
    )
  );
}

class MyApp extends StatefulWidget {

  final UserRepository _userRepository;

  const MyApp({Key? key, required UserRepository userRepository}) : _userRepository = userRepository, super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'TRANSPORTES ZURDOS',
      routes: {
      '/': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            }
            if (state is Authenticated) {
              return HomeScreen(userRepository: widget._userRepository, user: state.user);
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: widget._userRepository);
            }
            return Container();
          },
        );
      },

      'entrada': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return FormatoEScreen(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },

      'ordenes': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return Ordenes(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },
      'recepcion': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return RecepcionForm(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },
      'entradas': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return EntradasFormE(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },
      'salida': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return FormatoSScreen(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },
      'select': (BuildContext context) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is Authenticated) {
            return SelectForm(userRepository: widget._userRepository, user: state.user);
          }

          return LoginScreen(userRepository: widget._userRepository);
        });
      },



    });
  }
} 