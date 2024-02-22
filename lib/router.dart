import 'package:calendar_scheduler_mobile/app/ui/auth/sign_in.view.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/ui/events/create_event/register_meeting.view.dart';
import 'app/ui/events/resume/resume_meeting.view.dart';
import 'app/ui/guest_scheduler/guest_scheduler.view.dart';

final router = GoRouter(
  initialLocation: '/app/events',
  routes: [
    GoRoute(
      path: '/auth',
      routes: [
        GoRoute(
          path: 'signin',
          builder: (context, state) => SignInView(),
        ),
      ],
      redirect: (_, __) async => null,
    ),
    GoRoute(
      path: '/app',
      routes: [
        GoRoute(
          path: 'events',
          builder: (context, state) => const ResumeMeetingView(),
        ),
        GoRoute(
          // name: 'create-event',
          path: 'create-event',
          builder: (context, state) => const RegisterMeetingView(),
        ),
      ],
      redirect: _redirectApp
    ),
    GoRoute(
      path: '/guest/:code',
      builder: (context, state) => GuestEventView(state.pathParameters['code'].toString())
    )
  ],
);

Future<String?> _redirectApp(BuildContext context, GoRouterState state) async {
  if (state.fullPath?.contains('/auth') ?? false) return null;
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('token')) {
    return '/auth/signin';
  }
  return null;
}