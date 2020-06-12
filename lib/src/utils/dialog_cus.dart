import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:template_flutter/src/utils/styles.dart';

class DialogCus {
  BuildContext context;
  DialogCus(this.context);
  Future<void> show({@required String message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(message, style: TextStyle(fontSize: 16),),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}