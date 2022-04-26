import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PatrocinadoresForm extends StatelessWidget {
  const PatrocinadoresForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(child: _patrocinador('assets/logos/bfgoodrich.png', 'https://www.bfgoodrich.com.mx/', context))
        ],
      )
    );
  }

  Widget _patrocinador(String img, String link, context) {
    return GestureDetector(
      child: Card(
        child: Image.asset(
          img,
          width: MediaQuery.of(context).size.width * 0.9,
          height: 70,
        ),
      ),
      onTap: () {
        _launchURL(link);
      },
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