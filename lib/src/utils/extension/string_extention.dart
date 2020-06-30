extension StringExtention on String {
  String stringValue() {
    if (this == null || this.isEmpty) {
      return "N/a";
    }
    return this;
  }
}