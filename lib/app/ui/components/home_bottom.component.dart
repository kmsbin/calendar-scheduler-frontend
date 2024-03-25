import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBottonComponent extends StatefulWidget {
  final Widget child;

  const HomeBottonComponent({
    required this.child,
    super.key,
  });

  @override
  State<HomeBottonComponent> createState() => _HomeBottonComponentState();
}

class _HomeBottonComponentState extends State<HomeBottonComponent> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: StatefulBuilder(
        builder: (context, setState) {
          return BottomNavigationBar(
            currentIndex: index,
            onTap: (index) async {
              if (index == 2) {
                // signIn.re
                final uri = Uri.parse('https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=536852565523-rnm7n3d4bj00uu5tmb513bls2ucpepev.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fset-token-google&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcalendar.events&state=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJlbWFpbCI6ImthdWxpc2FiaW5vMjdAZ21haWwuY29tIiwiZXhwIjoxNzA5MTgzMDIzfQ.M77aixYjU1_3ry7YiG102VZh4BNKTFd7OHdE6T0ZczfaCqpuXO6p4Ou27DIHnwc9tGFdL6RxXCtB66uUWhgV_A');
                // if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, webViewConfiguration: WebViewConfiguration());
                // }
                return;
              }
              if (index == this.index) return;
              setState(() => this.index = index);
              final route = switch (index) {
                0 => '/app/events',
                1 => '/app/user',
                _ => '',
              };
              context.go(route);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.event_rounded),
                label: 'events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_rounded),
                label: 'user profile'
              ),
            ],
          );
        }
      ),
    );
  }
}

