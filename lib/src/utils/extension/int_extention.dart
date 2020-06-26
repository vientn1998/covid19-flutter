extension IntExtension on int {
  getTypeTimeSchedule() {
    switch (this) {
      case 1:
        return "07:00 - 08:00";
        break;
      case 2:
        return "08:00 - 09:00";
        break;
      case 3:
        return "09:00 - 10:00";
        break;
      case 4:
        return "10:00 - 11:00";
        break;
      case 5:
        return "11:00 - 12:00";
        break;
      case 6:
        return "13:00 - 14:00";
        break;
      case 7:
        return "14:00 - 15:00";
        break;
      case 8:
        return "15:00 - 16:00";
        break;
      case 9:
        return "6:00 - 17:00";
        break;
      default:
        return '';
    }
  }

  DateTime convertDatetime() {
    return DateTime.fromMillisecondsSinceEpoch(this) ?? DateTime.now();
  }
}