
import 'define.dart';

extension StringExtension on String {
  getTypeData() {
    if (this == "All day") {
      return "all";
    }
  }

  toCastStringIntoEnum() {
    if (this.toString() == StatusSchedule.New.toCastEnumIntoString()) {
      return StatusSchedule.New;
    }
    if (this.toString() == StatusSchedule.Approved.toCastEnumIntoString()) {
      return StatusSchedule.Approved;
    }
    if (this.toString() == StatusSchedule.Done.toCastEnumIntoString()) {
      return StatusSchedule.Done;
    }
    if (this.toString() == StatusSchedule.Canceled.toCastEnumIntoString()) {
      return StatusSchedule.Canceled;
    }
    return StatusSchedule.Canceled;
  }

  String stringValue() {
    if (this == null || this.isEmpty) {
      return "N/a";
    }
    return this;
  }
}