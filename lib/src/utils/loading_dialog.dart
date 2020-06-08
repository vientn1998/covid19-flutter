import 'package:loading_hud/loading_hud.dart';
import 'package:flutter/material.dart';
import 'package:loading_hud/loading_indicator.dart';
class LoadingDialog {
  static BuildContext context;
  LoadingDialog(context);
  var loadingHud = LoadingHud(
      context,
      cancelable: true,                  // Cancelable when pressing Android back key
      canceledOnTouchOutside: false,      // Cancelable when touch outside of the LoadingHud
      dimBackground: true,               // Dimming background when LoadingHud is showing
      hudColor: Color(0x99000000),       // Color of the ProgressHud
      indicator: DefaultLoadingIndicator(
        color: Colors.white,
      ),
  );
}