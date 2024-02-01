import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Widget title;
  final Key? buttonKey;

  const BottomButton({
    required this.onTap,
    required this.title,
    this.buttonKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, -7),
          ),
        ],
      ),
      padding: const EdgeInsets.all(kPadding),
      child: SafeArea(
        child: FilledButton(
          key: buttonKey,
          onPressed: onTap,
          child: title,
        ),
      ),
    );
  }
}