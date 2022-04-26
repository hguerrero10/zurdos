import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, content, positiveBtnText, negativeBtnText;
  final GestureTapCallback positiveBtnPressed, negativeBtnPressed;
  final IconData iconData;
  final Color color, colorIcon;
  final Widget widget;

  const CustomDialog({
    Key? key, 
    required this.title,
    required this.content,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.positiveBtnPressed,
    required this.iconData,
    required this.color,
    required this.colorIcon,
    required this.widget,
    required this.negativeBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text(
                //   content,
                //   style: const TextStyle(
                //     fontFamily: 'Nuber Next Regular',
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                widget,
                ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        negativeBtnText,
                      ),
                      onPressed: negativeBtnPressed
                    ),
                    TextButton(
                      child: Text(
                        positiveBtnText,
                      ),
                      onPressed: positiveBtnPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar( // Top Circle with icon
            backgroundColor: color,
            maxRadius: 40.0,
            child: Icon(iconData, size: 40, color: colorIcon),
          ),
        ],
      ),
    );
  }
}