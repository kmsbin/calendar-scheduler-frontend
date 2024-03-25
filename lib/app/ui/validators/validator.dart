import 'package:calendar_scheduler_mobile/app/ui/validators/password_validator.dart';

export 'email_validator.dart';
export 'not_empty_validator.dart';
export 'password_validator.dart';

typedef ValidatorExecutor = String? Function(String?);

abstract class Validator {

  const Validator();

  String? validate(String? value);

  static ValidatorExecutor compose(List<Validator> validators) {
    return (String? value) {
      for (final validator in validators) {
        if (validator(value) case final String error) return error;
      }
      return null;
    };
  }

  /// this is similar to Callable in java and can be called as a function in object instance, example PasswordValidator()('my pass')
  /// and this behavior can be passed by inheritance
  String? call(String? value) => validate(value);
}
