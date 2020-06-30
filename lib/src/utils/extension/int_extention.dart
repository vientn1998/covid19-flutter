extension IntExtension on int {

  String getTypeTimeSchedule() {
    switch (this) {
      case 7:
        return "07:00 - 08:00";
        break;
      case 8:
        return "08:00 - 09:00";
        break;
      case 9:
        return "09:00 - 10:00";
        break;
      case 10:
        return "10:00 - 11:00";
        break;
      case 11:
        return "11:00 - 12:00";
        break;
      case 13:
        return "13:00 - 14:00";
        break;
      case 14:
        return "14:00 - 15:00";
        break;
      case 15:
        return "15:00 - 16:00";
        break;
      case 16:
        return "16:00 - 17:00";
        break;
      default:
        return '';
    }
  }

  DateTime convertDatetime() {
    return DateTime.fromMillisecondsSinceEpoch(this) ?? DateTime.now();
  }
}