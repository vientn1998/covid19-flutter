import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';

class ButtonCustom extends StatelessWidget {

  String title;
  VoidCallback onPressed;
  Color background;
  double textSize, borderRadius;

  ButtonCustom({Key key, @required this.title, @required this.onPressed, this.background, this.textSize, this.borderRadius = 8}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.borderRadius)
      ),
      color: background,
      textColor: Colors.white,
      child: Text(title, style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),),
      onPressed: onPressed,
    );
  }
}

class ButtonOutlineCustom extends StatelessWidget {

  String title;
  VoidCallback onPressed;
  Color background, colorBorder, color;
  double textSize, borderRadius;

  ButtonOutlineCustom({Key key, @required this.title,this.color = textColor,this.colorBorder = borderColor,this.borderRadius = 8, @required this.onPressed, this.background, this.textSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
      ),
      borderSide: BorderSide(
        color: this.colorBorder
      ),
      color: background,
      textColor: color,
      child: Text(title, style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),),
      onPressed: onPressed,
    );
  }
}

