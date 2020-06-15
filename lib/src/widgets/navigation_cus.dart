import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/styles.dart';

class NavigationCus extends StatefulWidget {

  Function functionBack, functionRight;

  NavigationCus({this.functionBack, this.functionRight, Key key}): super(key: key);

  @override
  _NavigationCusState createState() => _NavigationCusState();
}

class _NavigationCusState extends State<NavigationCus> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        height: heightNavigation,
        decoration: BoxDecoration(
          color: colorActive
        ),
        child: Row(
          children: [
            FlatButton(
              child: Icon(Icons.arrow_back_ios),
              onPressed: widget.functionBack,
            ),
            Expanded(
              child: Text('Navigation', style: kTitle,),
            ),
            FlatButton(
              child: Icon(Icons.map),
              onPressed: widget.functionRight,
            ),
          ],
        ),
      ),
    );
  }
}
