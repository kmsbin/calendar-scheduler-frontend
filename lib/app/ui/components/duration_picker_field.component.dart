import 'package:flutter/material.dart';

class DurationPickerFieldComponent extends StatefulWidget {
  final void Function(TimeOfDay) onChanged;
  final TimeOfDay initialTime;
  final String labelText;
  final String? Function(TimeOfDay)? validator;

  const DurationPickerFieldComponent({
    required this.onChanged,
    required this.labelText,
    this.initialTime = const TimeOfDay(hour: 0, minute: 0),
    this.validator,
    super.key,
  });

  @override
  State<DurationPickerFieldComponent> createState() => _DurationPickerFieldComponentState();
}

class _DurationPickerFieldComponentState extends State<DurationPickerFieldComponent> {
  final textController = TextEditingController();
  late TimeOfDay _currentTime = widget.initialTime;

  @override
  void initState() {
    super.initState();
    setValue(widget.initialTime);
  }

  void setValue(TimeOfDay timeOfDay) {
    _currentTime = timeOfDay;
    textController.text = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: textController,
        readOnly: true,
        onTap: _setInitialTime,
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorMaxLines: 2,
        ),
        validator: (_) => widget.validator?.call(_currentTime),
      ),
    );
  }

  Future<void> _setInitialTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: widget.initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child!,
          ),
        );
      },
    );
    if (result != null) {
      setValue(result);
      widget.onChanged(result);
    }
  }
}
