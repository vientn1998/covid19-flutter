import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/styles.dart';

class CustomTextField extends StatefulWidget {

  final TextInputType textInputType;
  final String hint;
  String value = '';
  final IconData iconData;
  final TextCapitalization textCapitalization;
  final isEnable;
  final Function(String) onChanged;
  final int maxLine;


  CustomTextField({this.iconData, this.hint, this.textInputType
    , this.textCapitalization = TextCapitalization.sentences, this.isEnable = true,
    this.value, this.onChanged, this.maxLine
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();

}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: widget.isEnable ? backgroundSearch : backgroundTextInput,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)
      ),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: 15,),
          Icon(widget.iconData, color: Colors.black38,),
          Expanded(
            child: TextField(
              style: kBody,
              controller: textEditingController,
              onChanged: widget.onChanged,
              enabled: widget.isEnable,
              textCapitalization: widget.textCapitalization,
              maxLines: widget.maxLine,
              keyboardType: widget.textInputType,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: widget.hint
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomTextFieldHint extends StatefulWidget {

  final TextInputType textInputType;
  final String hint, title;
  String value = '';
  final IconData iconData;
  final TextCapitalization textCapitalization;
  final isEnable;
  final Function(String) onChanged;
  final int maxLine;
  final double height;

  CustomTextFieldHint({this.iconData, this.hint, this.textInputType
    , this.textCapitalization = TextCapitalization.sentences, this.isEnable = true,
    this.value, this.onChanged, this.maxLine, this.height = 50, this.title
  });

  @override
  _CustomTextFieldLableState createState() => _CustomTextFieldLableState();
}

class _CustomTextFieldLableState extends State<CustomTextFieldHint> {

  TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.title ?? '', style: kBody,),
          ],
        ),
        SizedBox(height: 10,),
        Container(
          decoration: BoxDecoration(
              color: widget.isEnable ? backgroundSearch : backgroundTextInput,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor)
          ),
          height: widget.height,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: kBody,
                  controller: textEditingController,
                  onChanged: widget.onChanged,
                  enabled: widget.isEnable,
                  textCapitalization: widget.textCapitalization,
                  maxLines: widget.maxLine,
                  keyboardType: widget.textInputType,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: widget.hint
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}