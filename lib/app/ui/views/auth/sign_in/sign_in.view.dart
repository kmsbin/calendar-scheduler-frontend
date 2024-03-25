import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'sign_in.bloc.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInBloc = SignInBloc();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    super.dispose();
    signInBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BlocConsumer<SignInBloc, SignInState>(
                bloc: signInBloc,
                listener: _stateListener,
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          StatefulBuilder(
                            builder: (context, setState) {
                              return TextFormField(
                                controller: passwordController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _showPassword = !_showPassword),
                                    icon: Icon(_showPassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded),
                                  )
                                ),
                              );
                            }
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: ElevatedButton(
                              onPressed: sendLogin,
                              child: const Text('Send'),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () => context.push(
                                '/auth/send-reset-password-email',
                                extra: emailController.text,
                              ),
                              child: const Text(
                                "Don't remember your password?",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => context.push('/auth/sign-up'),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(text: 'Not a user yet? ', style: TextStyle(color: Colors.black87)),
                      TextSpan(text: 'Register here', style: TextStyle(color: Colors.blueAccent))
                    ],
                  ),
                ),
              ),
            ),
          ],
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
}
