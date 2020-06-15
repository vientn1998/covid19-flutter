import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/styles.dart';

class NavigationCus extends StatefulWidget {

  Function functionBack, functionRight;
  bool isHidenIconRight;
  String title;


  NavigationCus({this.functionBack, this.functionRight, Key key
    , this.isHidenIconRight = true, this.title = 'CovidApp'}): super(key: key);

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
            Container(
              height: heightNavigation,
              width: heightNavigation,
              child: FlatButton(
                child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                onPressed: widget.functionBack,
              ),
            ),
            Expanded(
              child: Text(widget.title, style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ), textAlign: TextAlign.center,),
            ),
            widget.isHidenIconRight ? Container(height: heightNavigation,
              width: heightNavigation,) : FlatButton(
              child: Icon(Icons.map, color: Colors.white,),
              onPressed: widget.functionRight,
            ),
          ],
        ),
      ),
    );
  }
}
