import 'package:shared_preferences/shared_preferences.dart';

const String sharedLogged = "USER_IS_LOGGED";
const String sharedUserEmail = "USER";
const String sharedUserID = "USER_ID";
const String sharedPassword = "PASSWORD";

Future<void> addSharedPreferences({required String id, required String email, required String password}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(sharedLogged, true);
  await prefs.setString(sharedUserEmail, email);
  await prefs.setString(sharedUserID, id);
  await prefs.setString(sharedPassword, password);
}

Future<void> deleteSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(sharedLogged);
  await prefs.remove(sharedUserEmail);
  await prefs.remove(sharedUserID);
  await prefs.remove(sharedPassword);
}