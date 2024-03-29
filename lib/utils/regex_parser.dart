class RegexParser{

  static bool isEmail(String email){
    // regex definition
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    // regex test
    return emailRegex.hasMatch(email);
  }

}