import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/material.dart';

class UserCardComponent extends StatelessWidget {
  final String title, value;
  
  const UserCardComponent({
    required this.title, 
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(
                color: Colors.transparent,
                height: kPadding/2,
              ),
              Text(
                value,
                style: TextStyle(color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
