import 'package:flutter/material.dart';
import 'custom_dialog.dart';

dialog(String titulo, String contenido, IconData iconData, Color color, Color colorIcon, context, onTap, Widget widget, onTap2) {
  showGeneralDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 800),
    transitionBuilder: (context, a1, a2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: a1,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeOutCubic
        ),
        child: CustomDialog(
          title: titulo,
          content: contenido,
          positiveBtnText: "Aceptar",
          negativeBtnText: "Cancelar",
          iconData: iconData,
          color: color,
          colorIcon: colorIcon,
          positiveBtnPressed: onTap,
          widget: widget,
          negativeBtnPressed: onTap2,
        ),
      );
    },
    pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
      return const SizedBox();
    });
  }