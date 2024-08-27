import 'package:bloqo/utils/text_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  test("Well-formatted email is validated test", () {
    const test = "test@bloqo.com";
    final result = validateEmail(test);
    expect(result, true);
  });

  test("Badly-formatted email is not validated test", () {
    const test = "test@bloqo.c";
    final result = validateEmail(test);
    expect(result, false);
  });

  test("Well-formatted password is validated test", () {
    const test = "Test123!";
    final results = validatePassword(test);
    for (final result in results) {
      expect(result, true);
    }
  });

  test("Badly-formatted password (not long enough) is not validated test", () {
    const test = "Te123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Badly-formatted password (too long) is not validated test", () {
    const test = "TestTestTestTestTestTestTestTest123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Badly-formatted password (no special character) is not validated test", () {
    const test = "RealTest123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Badly-formatted password (no number) is not validated test", () {
    const test = "RealTest!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Badly-formatted password (no upper case character) is not validated test", () {
    const test = "test123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Badly-formatted password (no lower case character) is not validated test", () {
    const test = "TEST123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results){
      if(result){
        trueCount++;
      }
    }
    expect(trueCount, equals(5));
  });

  test("Password too short and no special character test", () {
    const test = "Test123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too short and no number test", () {
    const test = "Test!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too short and no uppercase character test", () {
    const test = "te123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too short and no lowercase character test", () {
    const test = "TE123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too long and no special character test", () {
    const test = "TestTestTestTestTestTestTestTest123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too long and no number test", () {
    const test = "TestTestTestTestTestTestTestTest!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too long and no uppercase character test", () {
    const test = "testtesttesttesttesttesttesttest123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too long and no lowercase character test", () {
    const test = "TESTTESTTESTTESTTESTTESTTESTTEST123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No special character and no number test", () {
    const test = "RealTest";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No special character and no uppercase character test", () {
    const test = "realtest123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No special character and no lowercase character test", () {
    const test = "REALTEST123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No number and no uppercase character test", () {
    const test = "realtest!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No number and no lowercase character test", () {
    const test = "REALTEST!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("No uppercase character and no lowercase character test", () {
    const test = "12345678!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(4));
  });

  test("Password too short, no special character, and no number test", () {
    const test = "Test";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no special character, and no uppercase character test", () {
    const test = "test123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no special character, and no lowercase character test", () {
    const test = "TEST123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no number, and no uppercase character test", () {
    const test = "test!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no number, and no lowercase character test", () {
    const test = "TEST!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no uppercase character, and no lowercase character test", () {
    const test = "123!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no special character, and no number test", () {
    const test = "TestTestTestTestTestTestTestTestTest";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no special character, and no uppercase character test", () {
    const test = "testtesttesttesttesttesttesttest123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no special character, and no lowercase character test", () {
    const test = "TESTTESTTESTTESTTESTTESTTESTTEST123";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no number, and no uppercase character test", () {
    const test = "testtesttesttesttesttesttesttest!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no number, and no lowercase character test", () {
    const test = "TESTTESTTESTTESTTESTTESTTESTTEST!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too long, no uppercase character, and no lowercase character test", () {
    const test = "1234567890123456789012345678901234567890!";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("No special character, no number, and no uppercase character test", () {
    const test = "realtest";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("No special character, no number, and no lowercase character test", () {
    const test = "REALTEST";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("No special character, no uppercase character, and no lowercase character test", () {
    const test = "123456789";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("No number, no uppercase character, and no lowercase character test", () {
    const test = "!@#\$%^&*";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(3));
  });

  test("Password too short, no special character, no number, and no uppercase character test", () {
    const test = "test";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no special character, no number, and no lowercase character test", () {
    const test = "TEST";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no special character, no uppercase character, and no lowercase character test", () {
    const test = "1234";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no number, no uppercase character, and no lowercase character test", () {
    const test = "!@#";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no special character, no number, and no uppercase character test", () {
    const test = "testtesttesttesttesttesttesttesttest";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no special character, no number, and no lowercase character test", () {
    const test = "TESTTESTTESTTESTTESTTESTTESTTESTTEST";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no special character, no uppercase character, and no lowercase character test", () {
    const test = "1234567890123456789012345678901234";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no number, no uppercase character, and no lowercase character test", () {
    const test = "!@#\$%^&*()_+{}|:<>?[];',./`~!@#\$%^&*()";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("No special character, no number, no uppercase character, and no lowercase character test", () {
    const test = "            ";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no special character, no number, and no lowercase character test", () {
    const test = "TEST";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no number, no uppercase character, and no lowercase character test", () {
    const test = "!@#";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no special character, no uppercase character, and no lowercase character test", () {
    const test = "1234567890123456789012345678901234";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no special character, no number, and no uppercase character test", () {
    const test = "testtesttesttesttesttesttesttesttest";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too short, no number, no special character, and no lowercase character test", () {
    const test = "TEST";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Password too long, no number, no uppercase character, and no lowercase character test", () {
    const test = "!@#\$%^&*()_+{}|:<>?[];',./`~!@#\$%^&*()";
    final results = validatePassword(test);
    int trueCount = 0;
    for (final result in results) {
      if (result) {
        trueCount++;
      }
    }
    expect(trueCount, equals(2));
  });

  test("Well-formatted username is validated test", () {
    const test = "BloqoTester21";
    final result = validateUsername(test);
    expect(result, true);
  });

  test("Badly-formatted username is not validated test", () {
    const test = "Bloqo Tester";
    final result = validateUsername(test);
    expect(result, false);
  });

  test("Well-formatted full name is validated test", () {
    const test = "Vanessa Visconti";
    final result = validateFullName(test);
    expect(result, true);
  });

  test("Badly-formatted full name is not validated test", () {
    const test = "Vanessa Visconti 00";
    final result = validateFullName(test);
    expect(result, false);
  });

}