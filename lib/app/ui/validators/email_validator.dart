import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';

class EmailValidator extends Validator {
  const EmailValidator();

  @override
  String? validate(String? value) {
    if (value == null) return 'The email field cannot be empty';
    final matcher = RegExp(r'^[a-z0-9.]+@[a-z0-9]+\.[a-z]+(\.[a-z]+)?$');
    if (matcher.hasMatch(value)) return null;
    return 'Invalid email, try again';
  }
}