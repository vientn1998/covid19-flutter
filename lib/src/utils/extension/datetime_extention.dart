extension DateTimeExtension on DateTime {
  DateTime setTimeStart() {
    return this.add(Duration(hours: 0, minutes: 0, seconds: 0, microseconds: 0, milliseconds: 0));
  }
}