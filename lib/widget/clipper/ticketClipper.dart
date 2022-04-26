import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
 @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 60;//este es mas picos
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 5 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}