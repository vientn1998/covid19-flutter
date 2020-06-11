import 'package:intl/intl.dart';
class DateTimeUtils {
  String formatDateString(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String formatTimeString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
}