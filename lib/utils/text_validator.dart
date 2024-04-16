import 'package:bloqo/utils/constants.dart';

String? emailValidator(String? email){
  return (email == null || !_validateEmail(email)) ? 'Please enter a valid email address.' : null;
}

String? passwordValidator(String? password){

  if(password == null){
    return "The password cannot be empty.";
  }
  List<bool> results = _validatePassword(password);
  int count = 0;
  for (bool result in results){
    if(result){
      count++;
    }
  }
  if(count==results.length){
    return null;
  }
  else {
    String errorMessage = _createPasswordErrorString(results);
    return errorMessage;
  }

}

String? usernameValidator(String? username) {
  if (username == null || username.length < Constants.minUsernameLength) {
    return "The username must be at least ${Constants.minUsernameLength} characters long.";
  }
  if (!_validateUsername(username)){
    return "The username must be alphanumeric.";
  }
  else{
    return null;
  }
}

String? fullNameValidator(String? fullName){
  if (fullName == null){
    return "The full name must not be empty.";
  }
  if (!_validateFullName(fullName)){
    return "The full name must be alphanumeric (spaces are allowed).";
  }
  else{
    return null;
  }
}

bool _validateEmail(String email){
  // regex definition
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  // regex test
  return emailRegex.hasMatch(email);
}

List<bool> _validatePassword(String password) {
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

String _createPasswordErrorString(List<bool> validationResults) {
  String messages = "";

  if (!validationResults[0]) {
    messages += 'Password must be at least ${Constants.minPasswordLength} characters long.\n';
  }
  if (!validationResults[1]) {
    messages+= 'Password must be at most ${Constants.maxPasswordLength} characters long.\n';
  }
  if (!validationResults[2]) {
    messages+= 'Password must contain at least one special character.\n';
  }
  if (!validationResults[3]) {
    messages+= 'Password must contain at least one number.\n';
  }
  if (!validationResults[4]) {
    messages+= 'Password must contain at least one uppercase letter.\n';
  }
  if (!validationResults[5]) {
    messages+= 'Password must contain at least one lowercase letter.\n';
  }
  return messages.trim();
}

bool _validateUsername(String username){
  final RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
  return regExp.hasMatch(username);
}

bool _validateFullName(String fullName) {
  RegExp regExp = RegExp(r'^[a-zA-Z0-9\s]+$');
  return regExp.hasMatch(fullName);
}