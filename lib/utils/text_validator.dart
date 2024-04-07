import 'package:bloqo/utils/constants.dart';

class TextValidator{

  static bool validateEmail(String email){
    // regex definition
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    // regex test
    return emailRegex.hasMatch(email);
  }

  static List<bool> validatePassword(String password) {
    // Define regex patterns to match the password requirements
    RegExp specialCharPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp numberPattern = RegExp(r'[0-9]');
    RegExp upperCasePattern = RegExp(r'[A-Z]');
    RegExp lowerCasePattern = RegExp(r'[a-z]');

    // Initialize the list to store the validation results
    List<bool> validationResults = [];

    // Check each condition individually
    validationResults.add(password.length >= Constants.minPasswordLength);
    validationResults.add(password.length <= Constants.maxPasswordLength);
    validationResults.add(specialCharPattern.hasMatch(password));
    validationResults.add(numberPattern.hasMatch(password));
    validationResults.add(upperCasePattern.hasMatch(password));
    validationResults.add(lowerCasePattern.hasMatch(password));

    return validationResults;
  }

  static bool validateUsername(String username){
    final RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
    return regExp.hasMatch(username);
  }

  static bool validateFullName(String fullName) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9\s]+$');
    return regExp.hasMatch(fullName);
  }

}