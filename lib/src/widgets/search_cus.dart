import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';

class SearchCusWidget extends StatefulWidget {
  String hint;
  bool isHiddenClear, isFocus;
  Function(String) onChange;
  SearchCusWidget({this.onChange, this.hint, this.isHiddenClear = true, this.isFocus = true});
  @override
  _SearchCusWidgetState createState() => _SearchCusWidgetState();
}

class _SearchCusWidgetState extends State<SearchCusWidget> {

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(paddingNavi, paddingNavi, paddingNavi, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundTextInput
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(width: 10,),
          Icon(Icons.search),
          Expanded(child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              hintText: widget.hint,
              border: InputBorder.none,
            ),
            autofocus: widget.isFocus,
            textCapitalization: TextCapitalization.words,
            autocorrect: false,
            textInputAction: TextInputAction.search,
            controller: _textEditingController,
            onChanged: (value) {
              print('text change $value');

            },
          ),),
          !widget.isHiddenClear ? InkWell(
            child: Container(
              height: 24,
              width: 24,
              child: Icon(Icons.close, size: 16,),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
            ),
            onTap: () {
              print('clear search');
            },
          ) : Container(),
          SizedBox(width: 10,),
        ],
      ),
    );
  }
}
