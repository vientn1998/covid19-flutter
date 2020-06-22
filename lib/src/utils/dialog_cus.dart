import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_hud/loading_hud.dart';
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

  Future<void> showDialogs({@required String message,bool isDismiss = false ,
    String titleLef,String titleRight, Function funcLeft, Function funRight}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isDismiss, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Covid App'),
          content: Text(message, style: TextStyle(fontSize: 16),),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(titleLef),
              onPressed: funcLeft == null ? () => Navigator.pop(context) : funcLeft,
            ),
            CupertinoDialogAction(
              child: Text(titleRight),
              onPressed: funRight == null ? () => Navigator.pop(context) : funRight,
            ),
          ],
        );
      },
    );
  }
}

toast(String message,{ToastGravity gravity = ToastGravity.CENTER}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
//      backgroundColor: Colors.red,
//      textColor: Colors.white,
      fontSize: 15.0
  );
}

showLoading(BuildContext context) {
  var loading = LoadingHud(context, cancelable: true, canceledOnTouchOutside: false);
  loading.show();
}
dismissLoading(BuildContext context) {
  LoadingHud(context).dismiss();
}