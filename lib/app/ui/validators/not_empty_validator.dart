import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';

class NotEmptyValidator extends Validator {
  const NotEmptyValidator();

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}