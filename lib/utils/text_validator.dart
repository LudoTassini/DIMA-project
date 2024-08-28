import 'package:bloqo/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? emailValidator({String? email, required AppLocalizations localizedText}){
  return (email == null || !validateEmail(email)) ? localizedText.error_enter_valid_email : null;
}

String? passwordValidator({String? password, required AppLocalizations localizedText}){

  if(password == null){
    return localizedText.error_password_empty;
  }
  List<bool> results = validatePassword(password);
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
    String errorMessage = _createPasswordErrorString(validationResults: results, localizedText: localizedText);
    return errorMessage;
  }

}

String? usernameValidator({String? username, required AppLocalizations localizedText}) {
  if (username == null || username.length < Constants.minUsernameLength) {
    return localizedText.error_username_short(Constants.minUsernameLength.toString());
  }
  if (!validateUsername(username)){
    return localizedText.error_username_alphanumeric;
  }
  else{
    return null;
  }
}

String? fullNameValidator({String? fullName, required AppLocalizations localizedText}){
  if (fullName == null || fullName == ""){
    return localizedText.error_full_name_empty;
  }
  if (!validateFullName(fullName)){
    return localizedText.error_full_name_alphanumeric;
  }
  else{
    return null;
  }
}

bool validateEmail(String email){
  // regex definition
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  // regex test
  return emailRegex.hasMatch(email);
}

List<bool> validatePassword(String password) {
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

String _createPasswordErrorString({required List<bool> validationResults, required AppLocalizations localizedText}) {
  String messages = "";

  if (!validationResults[0]) {
    messages += "${localizedText.error_password_short(Constants.minPasswordLength.toString())}\n";
  }
  if (!validationResults[1]) {
    messages+= '${localizedText.error_password_long(Constants.maxPasswordLength.toString())}\n';
  }
  if (!validationResults[2]) {
    messages+= '${localizedText.error_password_special_char}\n';
  }
  if (!validationResults[3]) {
    messages+= '${localizedText.error_password_number}\n';
  }
  if (!validationResults[4]) {
    messages+= '${localizedText.error_password_uppercase}\n';
  }
  if (!validationResults[5]) {
    messages+= '${localizedText.error_password_lowercase}\n';
  }
  return messages.trim();
}

bool validateUsername(String username){
  final RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
  return regExp.hasMatch(username);
}

bool validateFullName(String fullName) {
  RegExp regExp = RegExp(r"^[a-zA-Z\s']+$");
  return regExp.hasMatch(fullName);
}