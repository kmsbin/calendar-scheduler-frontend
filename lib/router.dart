import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/ui/components/home_bottom.component.dart';
import 'app/ui/views/auth/reset_password/reset_password.view.dart';
import 'app/ui/views/auth/send-reset-password-email/send_reset_password_email.view.dart';
import 'app/ui/views/views.dart';

final router = GoRouter(
  initialLocation: '/events',
  routes: [
    GoRoute(
      path: '/auth',
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (_, __) => const SignInView(),
        ),
        GoRoute(
          path: 'sign-up',
          builder: (_, __) => const SignUpView()
        ),
        GoRoute(
          path: 'reset-password/:code',
          builder: (_, state) => ResetPasswordView(state.pathParameters['code'].toString()),
        ),
        GoRoute(
          path: 'send-reset-password-email',
          builder: (_, state) => SendResetPasswordEmailView(state.extra?.toString() ?? ''),
        ),
      ],
      redirect: (_, __) async => null,
    ),
    GoRoute(
      path: '/',
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: 'events',
              pageBuilder: (_, state) {
                return pageTransitionBuilder(state, const ResumeMeetingView(), -1);
              },
            ),
            GoRoute(
              path: 'user',
              pageBuilder: (_, state) {
                return pageTransitionBuilder(state, const UserView(), 1);
              },
            ),
          ],
          builder: (context, state, child) => HomeBottonComponent(child: child)
        ),
        GoRoute(
          path: 'create-event',
          builder: (_, __) => const RegisterMeetingView(),
        ),
      ],
      redirect: _redirectApp
    ),
    GoRoute(
        path: '/guest/:code',
        builder: (_, state) => GuestEventView(state.pathParameters['code'].toString())
    ),
  ],
);

Page<T> pageTransitionBuilder<T extends Widget>(GoRouterState state, T child, double x) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 400),
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, animationBehind, child) {
      final tween = Tween(
        begin: Offset(x, 0.0),
        end: Offset.zero,
      ).chain(
        CurveTween(
          curve: Curves.easeInOut,
        ),
      );
      // animationBehind.drive(tween2);
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Future<String?> _redirectApp(BuildContext context, GoRouterState state) async {
  if (state.fullPath?.contains('/auth') ?? false) return null;
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('token')) {
    return '/auth/sign-in';
  }
  return null;
}