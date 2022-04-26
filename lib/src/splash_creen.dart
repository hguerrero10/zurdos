import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/jeep.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 127,
                width: 327 
              )
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(44, 197, 94, 1)),
              strokeWidth: 5,
            )
          ],
        ),
      )     
    );
  }
}