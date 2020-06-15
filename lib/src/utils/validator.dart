String phoneNumberValidator(String value) {
  Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Phone Number';
  else
    return null;
}
