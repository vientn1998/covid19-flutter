import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType textInputType;
  final String hint;
  String value = '';
  final IconData iconData;
  final TextCapitalization textCapitalization;
  final isEnable;
  final Function(String) onChanged;
  TextEditingController textEditingController;
  CustomTextField({this.iconData, this.hint, this.textInputType
    , this.textCapitalization = TextCapitalization.sentences, this.isEnable = true,
    this.value, this.onChanged
    }){
    textEditingController = TextEditingController(text: value);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isEnable ? backgroundSearch : backgroundTextInput,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor)
      ),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: 15,),
          Icon(iconData, color: Colors.black38,),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 17,
              ),
              controller: textEditingController,
              onChanged: onChanged,
              onSubmitted: onChanged,
              enabled: isEnable,
              textCapitalization: textCapitalization,
              maxLines: 1,
              keyboardType: textInputType,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: hint
              ),
            ),
          ),
        ],
      ),
    );
  }
}
