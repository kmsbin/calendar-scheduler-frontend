import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:calendar_scheduler_mobile/app/ui/components/linear_progress_timer_animated.component.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/validators/password_validator.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatefulWidget {
  final String code;

  const ResetPasswordView(this.code, {super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final passwordController = TextEditingController();
  final _fieldKey = GlobalKey<FormFieldState>();
  bool _showPassword = false;

  static const _snackBarDuration = Duration(seconds: 3);

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return TextFormField(
                    key: _fieldKey,
                    controller: passwordController,
                    obscureText: !_showPassword,
                    validator: const PasswordValidator(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: kPadding),
                child: ElevatedButton(
                  onPressed: _sendEmail,
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendEmail() async {
    try {
      final authRepository = getIt.get<AuthRepository>();

      if (!_fieldKey.currentState!.validate()) return;
      await authRepository.sendResetPassword(
        widget.code,
        passwordController.text,
      );

      _redirectToLogin();
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.message),
        ),
      );
    }
  }

  Future<void> _redirectToLogin() async {
    if (!mounted) return;
    await ScaffoldMessenger.of(context)
        .showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.zero,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Text('Password reseted with success!'),
                ),
                LinearProgressTimerAnimated(duration: _snackBarDuration),
              ],
            ),
          ),
        )
        .closed;

    if (!mounted) return;
    context.pushReplacement('/auth/sign-in');
  }
}
