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
              if (index == this.index) return;
              setState(() => this.index = index);
              final route = switch (index) {
                0 => '/events',
                1 => '/user',
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

