
class EstimatePasswordStrength {
  bool _minimumCharacteres(String password) => password.length > 6;

  bool _hasNonAlphanumericChar(String password) =>
      RegExp(r'[^a-zA-Z\d\s:]').hasMatch(password);

  bool _hasDigit(String password) => RegExp(r'\d').hasMatch(password);

  bool _hasLower(String password) => RegExp(r'[a-z]').hasMatch(password);

  bool _hasUpper(String password) => RegExp(r'[A-Z]').hasMatch(password);

  String? findErrorMessage(String? password) {
    if(password == null) return null;
    if (password.isEmpty) return "You must have a password";
    if (!_minimumCharacteres(password)) {
      return "Passwords must be at least 6 characters";
    }
    if (!_hasNonAlphanumericChar(password)) {
      return "Passwords must have at least one non alphanumeric character";
    }
    if (!_hasDigit(password)) {
      return "Passwords must have at least one digit ('0'-'9')";
    }
    if (!_hasLower(password)) {
      return "Passwords must have at least one lowercase ('a'-'z')";
    }
    if (!_hasUpper(password)) {
      return "Passwords must have at least one uppercase ('A'-'Z')";
    }
    return null;
  }
}
