import 'package:calendar_scheduler_mobile/app/ui/auth/sign_in.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInView extends StatefulWidget {

  SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInBloc = SignInBloc();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    signInBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<SignInBloc, SignInState>(
          bloc: signInBloc,
          listener: _stateListener,
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    validator: _fieldValidator,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: _fieldValidator,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: sendLogin,
                    child: const Text('Signin'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _stateListener(BuildContext context, SignInState state) {
    if (state is SuccessSignInState) {
      GoRouter.of(context).go('/app/events');
    }
    if (state is FailSignInState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void sendLogin() async {
    if (_formKey.currentState!.validate()) {
      signInBloc.add(RequestSignInEvent(emailController.text, passwordController.text));
    }
  }

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Type a value for this field';
    }
    return null;
  }
}
