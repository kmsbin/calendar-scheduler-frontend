import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';

class PasswordValidator extends Validator {
  const PasswordValidator();

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return 'This password field cannot be empty';
    if (value.length < 6) return 'The password must have at least 6 characters';
    if (!value.contains(RegExp(r'\d+'))) return 'The password must contain at least 1 number';
    if (!value.contains(RegExp(r'[`!@#$%^&*()_\-+=\[\]{};:\\|,.<>/?~ ]'))) return 'The password must contain at least 1 special character';
    return null;
  }
}