class AuthRegex {
  static final RegExp any = RegExp(
    r".*",
    caseSensitive: false,
    multiLine: false,
  );
  static final RegExp emptyValue = RegExp(
    r"^$",
    caseSensitive: false,
    multiLine: false,
  );
  static final RegExp username = RegExp(
    r"^.{5,}$",
    caseSensitive: false,
    multiLine: false,
  );
  static final RegExp email = RegExp(
    r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    caseSensitive: false,
    multiLine: false,
  );
  static final RegExp password = RegExp(
    r"^.{6,}$",
    caseSensitive: false,
    multiLine: false,
  );

  /*
  * min. 6 chars,
    min. 1 capital Letter,
    min. 1 number,
    min. 1 special character (,.:-_#+~<>!§$%&(){}=?@)
  * */
  static bool isPasswordCompliant(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }
    int minLength = 6;
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@~+#$%^&*(),.?":{}=|<>]'));
    bool hasMinLength = password.length >= minLength;
    bool hasWhiteSpace = password.contains(RegExp(r'\s'));

    return hasDigits & hasUppercase & hasMinLength & hasSpecialCharacters &&
        !hasWhiteSpace;
  }
}
