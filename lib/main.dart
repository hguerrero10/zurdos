import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/login/login_screen.dart';
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
      title: 'Santiago 4x4 Pro',
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
    });
  }
} 