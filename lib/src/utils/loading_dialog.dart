import 'package:loading_hud/loading_hud.dart';
import 'package:flutter/material.dart';
import 'package:loading_hud/loading_indicator.dart';
class LoadingDialog {

  BuildContext _context;
  LoadingDialog(context);

  show() {
    LoadingHud(_context).show();
  }

  dismiss() {
    LoadingHud(_context).dismiss();
  }
}