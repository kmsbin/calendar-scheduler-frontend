import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/material.dart';

class FilledResumeComponent extends StatelessWidget {
  final MeetingRange range;

  const FilledResumeComponent({
    required this.range,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: Padding(
        padding: const EdgeInsets.only(top: kPadding, left: kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  range.summary,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (range.authUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(right: kPadding),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
            const Divider(
              color: Colors.transparent,
              height: kPadding/2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time range: ${range.start.format(context)} - ${range.end.format(context)}'),
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(child: Text('Edit')),
                      const PopupMenuItem(child: Text('Delete')),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
