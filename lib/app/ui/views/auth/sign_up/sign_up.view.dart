import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/auth/sign_up/sign_up.bloc.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/auth/sign_up/sign_up.events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final bloc = SignUpBloc();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: _stateListener,
            bloc: bloc,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: const NotEmptyValidator(),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: Validator.compose([
                      const NotEmptyValidator(),
                      const EmailValidator(),
                    ]),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: const PasswordValidator(),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _sendForm,
                    child: const Text('Register'),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Future<void> _sendForm() async {
    if (!formKey.currentState!.validate()) return;
    final event = RegisterSignUpEvent(
      name: nameController.text,
      password: passwordController.text,
      email: emailController.text,
    );
    bloc.add(event);
  }

  void _stateListener(BuildContext context, SignUpState state) {
    if (state is SuccessSignUpState) {
      context.go('/events');
    }
    if (state is ErrorSignUpState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
