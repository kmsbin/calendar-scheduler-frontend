import 'package:flutter/material.dart';

class LinearProgressTimerAnimated extends StatefulWidget {
  final Duration duration;

  const LinearProgressTimerAnimated({
    required this.duration,
    super.key,
  });

  @override
  State<LinearProgressTimerAnimated> createState() => _LinearProgressTimerAnimatedState();
}

class _LinearProgressTimerAnimatedState
    extends State<LinearProgressTimerAnimated>
    with TickerProviderStateMixin<LinearProgressTimerAnimated> {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));
    controller.animateTo(1);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: controller.value,
    );
  }
}