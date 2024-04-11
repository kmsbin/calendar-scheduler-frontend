import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyUrlComponent extends StatefulWidget {
  final String url;
  const CopyUrlComponent({
    required this.url,
    super.key,
  });

  @override
  State<CopyUrlComponent> createState() => _CopyUrlComponentState();
}

class _CopyUrlComponentState extends State<CopyUrlComponent> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: widget.url),
              );
              if (!isCopied) { // prevents unnecessary rebuild
                setState(() => isCopied = true);
              }
            },
            child: Card(
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(kPadding/2).copyWith(left: kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: kPadding*2),
                        child: Text(
                          widget.url,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.9)),
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.transparent),
                      ),
                      elevation: 0,
                      avatar: isCopied
                          ? const Icon(Icons.check)
                          : const Icon(Icons.copy_rounded),
                      label: Text(
                        isCopied
                          ? 'Copied'
                          : 'Copy',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
