import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  PermissionsService();

  Future<bool> requestPermissionContacts({Function onPermissionDenied}) async {
    var result = await Permission.contacts.request();
    if (result.isGranted) {
      return true;
    } else {
      onPermissionDenied();
    }
  }

  Future<bool> hasPermissionContacts() async {
    final request = await Permission.contacts.isGranted;
    return request ?? false;
  }

}