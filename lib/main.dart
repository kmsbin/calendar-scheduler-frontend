import 'package:calendar_scheduler_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import 'injector.dart';

void main() {
  configureDependencies();
  setPathUrlStrategy();
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Calendar scheduler',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
    );
  }
}