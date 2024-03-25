import 'package:calendar_scheduler_mobile/app/ui/validators/password_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validate = PasswordValidator().validate;

  test('Must fail because value is empty or null', () {
    expect(validate(null), 'This password field cannot be empty');
    expect(validate(''), 'This password field cannot be empty');
  });

  test("Must fail because the password is too small", () {
    expect(validate('tiny'), 'The password must have at least 6 characters');
  });

  test("Must fail because value hasn't a number ", () {
    expect(validate('random pass'), 'The password must contain at least 1 number');
  });

  test("Must fail because value hasn't a special character ", () {
    expect(validate('random3pass'), 'The password must contain at least 1 special character');
  });

  test("Must pass because value has at least 6 chars, a number and a special char ", () {
    expect(validate('r1ghtP4ss'), 'The password must contain at least 1 special character');
  });
}