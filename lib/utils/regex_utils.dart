class RegexUtils {
  static final RegExp any =
      RegExp(r".*", caseSensitive: false, multiLine: false);
  static final RegExp anyMinLength1 =
      RegExp(r".+", caseSensitive: false, multiLine: false);
  static final RegExp username =
      RegExp(r"^.{1,}$", caseSensitive: false, multiLine: false);
  static final RegExp email = RegExp(
      r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
      caseSensitive: false,
      multiLine: false);
  static final RegExp password =
      RegExp(r"^.{6,}$", caseSensitive: false, multiLine: false);
  static final RegExp zipcode =
      RegExp(r"^\d{1,7}$", caseSensitive: false, multiLine: false);

  static final RegExp phone =
      RegExp(r"\d{10,11}", caseSensitive: false, multiLine: false);

  static final RegExp emailId = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
}
