import 'package:intl/intl.dart';
class DateTimeUtils {
  String formatDateString(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String formatTimeString(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatMonthYearString(DateTime dateTime) {
    return DateFormat('MMM, yyyy').format(dateTime);
  }

  String formatDateTimeString(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy HH:mm').format(dateTime);
  }

  String formatDayString(DateTime dateTime) {
    return DateFormat('dd').format(dateTime);
  }

  String formatMonthString(DateTime dateTime) {
    return DateFormat('MMM').format(dateTime);
  }
}