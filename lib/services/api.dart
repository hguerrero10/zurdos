// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:montemorelos_app/models/reporte_model.dart';
// import 'package:montemorelos_app/util/constantes.dart';

// class Api {

//   Api._();
//   static final Api instance = Api._();

//   static const HOST = '192.168.100.1';
//   static const PORT = 5000;

//   Future<http.Response> subirReporte({
//     required ReporteModel reporteModel
//   }) async {
//     Uri url = Uri(
//       scheme: 'http',
//       host: HOST,
//       port: PORT,
//       path: 'insertReport',
//     );
//     return await http.post(
//       url,
//       headers: headers,
//       body:  const JsonEncoder().convert(reporteModel.toJson()),
//     );
//   }
// }