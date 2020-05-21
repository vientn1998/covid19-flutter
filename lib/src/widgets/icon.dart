import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/color.dart';
import 'package:template_flutter/src/utils/define.dart';
import 'package:template_flutter/src/utils/styles.dart';

class IconBox extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  IconBox({Key key, this.iconData, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: sizeBoxIcon,
        width: sizeBoxIcon,
        child: Icon(
          iconData,
          size: sizeIconHome,
        ),
      ),
    );
  }
}

class IconMenuBox extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final String title;
  final Color background;

  IconMenuBox(
      {Key key, this.iconData, this.onPressed, this.background, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: <Widget>[
          Container(
            height: sizeBoxIcon,
            width: sizeBoxIcon,
            decoration: BoxDecoration(
                color: background, borderRadius: BorderRadius.circular(8)),
            child: Icon(
              iconData,
              size: sizeIconHome,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: heightSpaceSmall,
          ),
          Text(
            title,
            style: kSmallBold,
          )
        ],
      ),
    );
  }
}
