import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/styles.dart';

class TextFieldDropDown extends StatefulWidget {

  String value = '';
  final IconData iconData;
  final Function() onChanged;
  TextFieldDropDown({this.value, this.iconData, this.onChanged});

  @override
  _TextFieldDropDownState createState() => _TextFieldDropDownState();
}

class _TextFieldDropDownState extends State<TextFieldDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundSearch,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)
      ),
      height: 50,
      child: Material(
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(width: 15,),
              Text(widget.value, style: kTitle,),
              Spacer(),
              Icon(widget.iconData, color: colorIcon,),
              SizedBox(width: 15,),
            ],
          ),
          onTap: widget.onChanged,
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.transparent,
      ),
    );
  }
}

class TextFieldDropDownHint extends StatefulWidget {

  String value = '';
  String hint = '';
  final IconData iconData;
  final Function() onChanged;
  TextFieldDropDownHint({this.value, this.iconData, this.onChanged, this.hint});

  @override
  _TextFieldDropDownHintState createState() => _TextFieldDropDownHintState();
}

class _TextFieldDropDownHintState extends State<TextFieldDropDownHint> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.hint ?? '', style: kTitle,),
          ],
        ),
        SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
              color: backgroundSearch,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor)
          ),
          height: 50,
          child: Material(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Text(widget.value, style: kTitle,),
                  Spacer(),
                  Icon(widget.iconData, color: colorIcon,),
                  SizedBox(width: 15,),
                ],
              ),
              onTap: widget.onChanged,
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

