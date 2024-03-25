import 'package:calendar_scheduler_mobile/app/domain/repositories/auth_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/auth_exception.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendResetPasswordEmailView extends StatefulWidget {
  final String email;

  const SendResetPasswordEmailView(this.email, {super.key});

  @override
  State<SendResetPasswordEmailView> createState() => _SendResetPasswordEmailViewState();
}

class _SendResetPasswordEmailViewState extends State<SendResetPasswordEmailView> {
  late final _emailController = TextEditingController(text: widget.email);
  final _fieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send reset password'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: _fieldKey,
                controller: _emailController,
                validator: Validator.compose([
                  const NotEmptyValidator(),
                  const EmailValidator(),
                ]),
                decoration: const InputDecoration(
                  labelText: 'Account email',
                ),
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
      await authRepository.sendRequestToResetPassword(_emailController.text);

      _sendSnackMessage('Account recovery link sent to your email successfully');
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return;
      context.pop();
    } on AuthException catch (e) {
      _sendSnackMessage(e.message);
    }
  }

  void _sendSnackMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          content: Text(message),
        ),
      );
  }
}
