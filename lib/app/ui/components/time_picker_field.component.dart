import 'package:flutter/material.dart';

class TimePickerFieldComponent extends StatefulWidget {
  final void Function(TimeOfDay) onChanged;
  final TimeOfDay initialTime;
  final String labelText;
  final String? Function(TimeOfDay)? validator;

  const TimePickerFieldComponent({
    required this.onChanged,
    required this.labelText,
    this.initialTime = const TimeOfDay(hour: 0, minute: 0),
    this.validator,
    super.key,
  });

  @override
  State<TimePickerFieldComponent> createState() => _TimePickerFieldComponentState();
}

class _TimePickerFieldComponentState extends State<TimePickerFieldComponent> {
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
    );
    if (result != null) {
      setValue(result);
      widget.onChanged(result);
    }
  }
}
