
import 'package:flutter/foundation.dart';

class ReceivedNotification {
  int id;
  String title;
  String body;
  String payload;

  ReceivedNotification({
     this.id,
     this.title,
     this.body,
     this.payload,
  });
  @override
  String toString() {
    return "$id - $title - $body";
  }
}