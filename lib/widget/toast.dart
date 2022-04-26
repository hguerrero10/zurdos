import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 13.0
  );
}